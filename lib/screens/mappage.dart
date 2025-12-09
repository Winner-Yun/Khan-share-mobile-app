import 'dart:async';
import 'dart:ui' as ui; // Needed for image processing

import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Needed for NetworkAssetBundle
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:khan_share_mobile_app/screens/book_detailscreen.dart';

class MapViewScreen extends StatefulWidget {
  const MapViewScreen({super.key});

  @override
  State<MapViewScreen> createState() => _MapViewScreenState();
}

class _MapViewScreenState extends State<MapViewScreen> {
  // 1. Google Map Controller
  GoogleMapController? _mapController;
  final TextEditingController _searchController = TextEditingController();

  // Initial Position
  final LatLng _initialPosition = const LatLng(11.5564, 104.9282);

  // 2. State for Google Map Markers and Options
  Set<Marker> _markers = {};
  MapType _currentMapType = MapType.normal; // State for Map Type
  bool _trafficEnabled = false; // State for Traffic Layer

  // State to track selected book for the Custom Popup
  Map<String, dynamic>? _selectedBook;
  Marker? _userPinMarker;

  final List<Map<String, dynamic>> _books = [
    {
      "id": "book_1",
      "title": "To Kill a Mockingbird",
      "author": "Harper Lee",
      "distance": "2.5 km",
      "action": "Donate",
      "image":
          "https://m.media-amazon.com/images/I/81OthjkJBuL._AC_UF1000,1000_QL80_.jpg",
      "location": const LatLng(11.5580, 104.9290),
    },
    {
      "id": "book_2",
      "title": "1984",
      "author": "George Orwell",
      "distance": "1.8 km",
      "action": "Exchange",
      "image":
          "https://m.media-amazon.com/images/I/71kxa1-0mfL._AC_UF1000,1000_QL80_.jpg",
      "location": const LatLng(11.5540, 104.9270),
    },
    {
      "id": "book_3",
      "title": "The Great Gatsby",
      "author": "F. Scott Fitzgerald",
      "distance": "3.2 km",
      "action": "Donate",
      "image":
          "https://m.media-amazon.com/images/I/71FTb9X6wsL._AC_UF1000,1000_QL80_.jpg",
      "location": const LatLng(11.5600, 104.9300),
    },
    {
      "id": "book_4",
      "title": "Harry Potter",
      "author": "J.K. Rowling",
      "distance": "5.0 km",
      "action": "Exchange",
      "image":
          "https://m.media-amazon.com/images/I/71-++hbbERL._AC_UF1000,1000_QL80_.jpg",
      "location": const LatLng(11.5500, 104.9200),
    },
  ];

  @override
  void initState() {
    super.initState();
    _loadBookMarkers();
  }

  // --- NAVIGATION HELPER ---
  void _navigateToDetail(Map<String, dynamic> book) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => BookDetailScreen(book: book)),
    );
  }

  // --- IMAGE PROCESSING FOR MARKERS ---
  Future<BitmapDescriptor> _createCustomMarkerBitmap(String url) async {
    try {
      // 1. Download image
      final ByteData data = await NetworkAssetBundle(Uri.parse(url)).load("");
      final Uint8List bytes = data.buffer.asUint8List();

      // 2. Decode image to get dimensions
      final ui.Codec codec = await ui.instantiateImageCodec(
        bytes,
        targetWidth: 150, // Resize to keep marker size reasonable
        targetHeight: 150,
      );
      final ui.FrameInfo fi = await codec.getNextFrame();
      final ui.Image image = fi.image;

      // 3. Create Canvas to draw Circle + Border + Image
      final int size = 120; // Pixel size of the marker
      final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
      final Canvas canvas = Canvas(pictureRecorder);
      final Paint paint = Paint()..isAntiAlias = true;
      final double radius = size / 2;

      // Draw White Border Circle
      paint.color = Colors.white;
      canvas.drawCircle(Offset(radius, radius), radius, paint);

      // Draw Teal Border Outline (Optional)
      paint.color = Colors.teal;
      paint.style = PaintingStyle.stroke;
      paint.strokeWidth = 4;
      canvas.drawCircle(Offset(radius, radius), radius - 2, paint);

      // Clip Path for the Image (Inner Circle)
      paint.style = PaintingStyle.fill;
      Path clipPath = Path()
        ..addOval(
          Rect.fromCircle(center: Offset(radius, radius), radius: radius - 8),
        );
      canvas.clipPath(clipPath);

      // Draw the Image centered
      double imageWidth = image.width.toDouble();
      double imageHeight = image.height.toDouble();

      double scale = (size / imageWidth) > (size / imageHeight)
          ? (size / imageWidth)
          : (size / imageHeight);

      scale = scale * 1.2;

      canvas.drawImageRect(
        image,
        Rect.fromLTWH(0, 0, imageWidth, imageHeight),
        Rect.fromLTWH(
          (size - imageWidth * scale) / 2,
          (size - imageHeight * scale) / 2,
          imageWidth * scale,
          imageHeight * scale,
        ),
        Paint(),
      );

      // 4. Convert Canvas to BitmapDescriptor
      final ui.Image markerAsImage = await pictureRecorder
          .endRecording()
          .toImage(size, size);
      final ByteData? byteData = await markerAsImage.toByteData(
        format: ui.ImageByteFormat.png,
      );
      final Uint8List uint8List = byteData!.buffer.asUint8List();

      // ignore: deprecated_member_use
      return BitmapDescriptor.fromBytes(uint8List);
    } catch (e) {
      debugPrint("Error loading marker image: $e");
      return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueCyan);
    }
  }

  // --- MARKER LOGIC ---
  Future<void> _loadBookMarkers() async {
    Set<Marker> newMarkers = {};

    for (var book in _books) {
      BitmapDescriptor icon = await _createCustomMarkerBitmap(book['image']);

      newMarkers.add(
        Marker(
          markerId: MarkerId(book['id']),
          position: book['location'],
          icon: icon,
          onTap: () {
            setState(() {
              _selectedBook = book;
            });
            _mapController?.animateCamera(
              CameraUpdate.newLatLng(book['location']),
            );
          },
        ),
      );
    }

    if (_userPinMarker != null) {
      newMarkers.add(_userPinMarker!);
    }

    if (mounted) {
      setState(() {
        _markers = newMarkers;
      });
    }
  }

  void _setUserPin(LatLng tappedPoint) {
    setState(() {
      _selectedBook = null;
    });

    final userMarker = Marker(
      markerId: const MarkerId("user_pin"),
      position: tappedPoint,
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
    );

    setState(() {
      _userPinMarker = userMarker;
      _markers.add(userMarker);
    });
  }

  void _clearUserPin() {
    setState(() {
      _userPinMarker = null;
    });
    _loadBookMarkers();
  }

  // --- MAP OPTIONS MODAL ---
  void _showMapOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Map Type",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildMapTypeOption("Default", MapType.normal, Icons.map),
                  _buildMapTypeOption(
                    "Satellite",
                    MapType.satellite,
                    Icons.satellite,
                  ),
                  _buildMapTypeOption(
                    "Terrain",
                    MapType.terrain,
                    Icons.terrain,
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const Divider(),
              SwitchListTile(
                title: const Text(
                  "Traffic Details",
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                secondary: const Icon(Icons.traffic, color: Colors.orange),
                value: _trafficEnabled,
                activeThumbColor: Colors.teal,
                onChanged: (bool value) {
                  setState(() {
                    _trafficEnabled = value;
                  });
                  Navigator.pop(context);
                },
              ),
              const SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMapTypeOption(String label, MapType type, IconData icon) {
    final bool isSelected = _currentMapType == type;
    return GestureDetector(
      onTap: () {
        setState(() {
          _currentMapType = type;
        });
        Navigator.pop(context);
      },
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: isSelected ? Colors.teal : Colors.grey.shade300,
                width: 2,
              ),
              color: isSelected
                  ? Colors.teal.withValues(alpha: 0.1)
                  : Colors.white,
            ),
            child: Icon(
              icon,
              color: isSelected ? Colors.teal : Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.teal : Colors.black87,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  // --- CUSTOM POPUP WIDGET ---
  Widget _buildCustomPopup(Map<String, dynamic> book) {
    return Positioned(
      top: 260,
      left: 40,
      right: 40,
      child: Material(
        color: Colors.transparent,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 10,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        book['image'],
                        width: 60,
                        height: 60,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          width: 60,
                          height: 60,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            book['title'],
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            book['distance'],
                            style: TextStyle(
                              color: Colors.teal[700],
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              InkWell(
                                onTap: () => _navigateToDetail(book),
                                child: Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: const BoxDecoration(
                                    color: Colors.teal,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.arrow_forward,
                                    size: 16,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              InkWell(
                                onTap: () {},
                                child: Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    color: Colors.blue[50],
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.share,
                                    size: 16,
                                    color: Colors.blue,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                top: 0,
                right: 0,
                child: IconButton(
                  icon: const Icon(Icons.close, size: 16, color: Colors.grey),
                  onPressed: () {
                    setState(() {
                      _selectedBook = null;
                    });
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 1. GOOGLE MAP LAYER
          Positioned.fill(
            child: GoogleMap(
              initialCameraPosition: CameraPosition(
                target: _initialPosition,
                zoom: 14.0,
              ),
              mapType: _currentMapType, // Use state
              trafficEnabled: _trafficEnabled, // Use state
              markers: _markers,
              onMapCreated: (GoogleMapController controller) {
                _mapController = controller;
              },
              onTap: (LatLng point) {
                if (_selectedBook != null) {
                  setState(() {
                    _selectedBook = null;
                  });
                } else {
                  _setUserPin(point);
                }
              },
              zoomControlsEnabled: false,
              mapToolbarEnabled: false,
              compassEnabled: true,
              myLocationEnabled: true, // Try to show blue dot
              myLocationButtonEnabled: false,
            ),
          ),

          // 2. CUSTOM POPUP
          if (_selectedBook != null) _buildCustomPopup(_selectedBook!),

          // 3. HEADER
          Positioned(top: 0, left: 0, right: 0, child: _buildHeader(context)),

          // 4. MAP LAYERS BUTTON (New)
          Positioned(
            top: 200, // Positioned below search bar
            right: 16,
            child: FloatingActionButton(
              heroTag: "layersBtn",
              mini: true,
              backgroundColor: Colors.white,
              elevation: 4,
              onPressed: _showMapOptions,
              child: const Icon(Icons.layers_outlined, color: Colors.black87),
            ),
          ),

          // 5. FIND ME BUTTON
          Positioned(
            top: 145, // Moved down slightly
            right: 16,
            child: FloatingActionButton(
              heroTag: "gpsBtn",
              mini: true,
              backgroundColor: Colors.white,
              elevation: 4,
              child: const Icon(Icons.my_location, color: Colors.teal),
              onPressed: () {
                _mapController?.animateCamera(
                  CameraUpdate.newCameraPosition(
                    CameraPosition(target: _initialPosition, zoom: 14),
                  ),
                );
              },
            ),
          ),

          // 6. CLEAR PIN BUTTON
          if (_userPinMarker != null)
            Positioned(
              top: 260, // Moved down slightly
              right: 16,
              child: FloatingActionButton.extended(
                heroTag: "clearBtn",
                onPressed: _clearUserPin,
                backgroundColor: Colors.white,
                icon: const Icon(Icons.close, color: Colors.red),
                label: const Text(
                  "Clear Pin",
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ),

          // 7. DRAGGABLE LIST SHEET
          DraggableScrollableSheet(
            initialChildSize: 0.4,
            minChildSize: 0.15,
            maxChildSize: 0.9,
            builder: (BuildContext context, ScrollController scrollController) {
              return Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    const SizedBox(height: 12),
                    Container(
                      width: 50,
                      height: 5,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 5,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Books Near You",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "${_books.length} found",
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        controller: scrollController,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 10,
                        ),
                        itemCount: _books.length,
                        itemBuilder: (context, index) {
                          final b = _books[index];
                          return _buildBookCard(
                            title: b["title"],
                            author: b["author"],
                            distance: b["distance"],
                            action: b["action"],
                            imageUrl: b["image"],
                            onTap: () {
                              _mapController?.animateCamera(
                                CameraUpdate.newLatLngZoom(b['location'], 15.0),
                              );
                              setState(() {
                                _selectedBook = b;
                              });
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  // ------------------ HEADER (Unchanged) ------------------
  Widget _buildHeader(BuildContext context) {
    return SafeArea(
      child: Container(
        margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                style: const TextStyle(color: Colors.black),
                cursorColor: Colors.teal,
                controller: _searchController,
                decoration: const InputDecoration(
                  hintText: "Search Book Title, author...",
                  hintStyle: TextStyle(color: Colors.black54),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(horizontal: 10),
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.search, color: Colors.teal),
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }

  // ------------------ BOOK CARD (Unchanged) ------------------
  Widget _buildBookCard({
    required String title,
    required String author,
    required String distance,
    required String action,
    required String imageUrl,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 5,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                imageUrl,
                width: 60,
                height: 90,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    Container(width: 60, height: 90, color: Colors.grey),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    author,
                    style: TextStyle(fontSize: 13, color: Colors.grey[700]),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on,
                        size: 14,
                        color: Colors.grey,
                      ),
                      Text(distance, style: const TextStyle(fontSize: 12)),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: action == "Donate"
                    ? Colors.green[100]
                    : Colors.orange[100],
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                action,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: action == "Donate" ? Colors.green : Colors.orange,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
