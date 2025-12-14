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
      'title': 'The Catcher in the Rye',
      'author': 'J.D. Salinger',
      'action': 'Exchange',
      'distance': '5.3 km',
      'category': 'Comedy',
      'readers': null,
      'days_ago': '2 days ago',
      'user': 'Srey Mom',
      'image':
          'https://m.media-amazon.com/images/I/71QKQ9mwV7L._AC_UF1000,1000_QL80_.jpg',
      'owner_image_url': 'https://randomuser.me/api/portraits/women/44.jpg',
      "location": const LatLng(11.5580, 104.9290),
    },
    {
      "id": "book_2",
      'title': 'Harry Potter',
      'author': 'J.K. Rowling',
      'action': 'Borrow',
      'distance': '2.1 km',
      'category': 'Fantasy',
      'readers': null,
      'days_ago': '5 hours ago',
      'user': 'Srey Mom',
      'image':
          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQsfxrcUtlaLqSTTpA7N9cWKIopvRNtXngM2A&s',
      'owner_image_url': 'https://randomuser.me/api/portraits/women/44.jpg',
      "location": const LatLng(11.5540, 104.9270),
    },
    {
      "id": "book_3",
      'title': 'Anime Story',
      'author': 'Unknown',
      'action': 'Exchange',
      'distance': '1.2 km',
      'category': 'Manga',
      'readers': null,
      'days_ago': '1 day ago',
      'user': 'Srey Mom',
      'image':
          'https://marketplace.canva.com/EAGUhHGuQOg/1/0/1003w/canva-orange-and-blue-anime-cartoon-illustrative-novel-story-book-cover-WZE2VIj5AVQ.jpg',
      'owner_image_url': 'https://randomuser.me/api/portraits/women/44.jpg',
      "location": const LatLng(11.5600, 104.9300),
    },
    {
      "id": "book_4",
      'title': 'Flutter Development',
      'author': 'Google',
      'action': 'Donation',
      'distance': '0.5 km',
      'category': 'Education',
      'readers': null,
      'days_ago': 'Just now',
      'user': 'Srey Mom',
      'image':
          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS36GaImhQXaqzdQkhgvQ1ZZtbru_p5-PsOaw&s',
      "location": const LatLng(11.5500, 104.9200),
    },
  ];

  @override
  void initState() {
    super.initState();
    _loadBookMarkers();
  }

  // --- HELPER: GET COLOR BASED ON ACTION ---
  Color _getActionColor(String action) {
    switch (action) {
      case 'Donation':
      case 'Donate':
        return Colors.green;
      case 'Borrow':
        return Colors.deepPurple;
      case 'Exchange':
        return Colors.orange;
      default:
        return Colors.teal;
    }
  }

  // --- NAVIGATION HELPER ---
  void _navigateToDetail(Map<String, dynamic> book) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => BookDetailScreen(book: book)),
    );
  }

  // --- IMAGE PROCESSING FOR MARKERS ---
  Future<BitmapDescriptor> _createCustomMarkerBitmap(
    String url,
    Color borderColor,
  ) async {
    try {
      final ByteData data = await NetworkAssetBundle(Uri.parse(url)).load("");
      final Uint8List bytes = data.buffer.asUint8List();

      final ui.Codec codec = await ui.instantiateImageCodec(
        bytes,
        targetWidth: 150,
        targetHeight: 150,
      );
      final ui.FrameInfo fi = await codec.getNextFrame();
      final ui.Image image = fi.image;

      final int size = 120;
      final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
      final Canvas canvas = Canvas(pictureRecorder);
      final Paint paint = Paint()..isAntiAlias = true;
      final double radius = size / 2;

      // Draw White Background Circle (Keep white so markers pop on map)
      paint.color = Colors.white;
      paint.style = PaintingStyle.fill;
      canvas.drawCircle(Offset(radius, radius), radius, paint);

      // Draw Colored Border Outline
      paint.color = borderColor;
      paint.style = PaintingStyle.stroke;
      paint.strokeWidth = 6;
      canvas.drawCircle(Offset(radius, radius), radius - 3, paint);

      // Clip Path for the Image
      paint.style = PaintingStyle.fill;
      Path clipPath = Path()
        ..addOval(
          Rect.fromCircle(center: Offset(radius, radius), radius: radius - 8),
        );
      canvas.clipPath(clipPath);

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
      Color bookColor = _getActionColor(book['action']);

      BitmapDescriptor icon = await _createCustomMarkerBitmap(
        book['image'],
        bookColor,
      );

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

  // --- MAP OPTIONS MODAL ---
  void _showMapOptions(ThemeData theme, ColorScheme colors) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          decoration: BoxDecoration(
            color: theme.cardColor, // Dynamic Background
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Map Type",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: colors.onSurface,
                ),
              ),
              const SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildMapTypeOption(
                    "Default",
                    MapType.normal,
                    Icons.map,
                    colors,
                  ),
                  _buildMapTypeOption(
                    "Satellite",
                    MapType.satellite,
                    Icons.satellite,
                    colors,
                  ),
                  _buildMapTypeOption(
                    "Terrain",
                    MapType.terrain,
                    Icons.terrain,
                    colors,
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const Divider(),
              SwitchListTile(
                title: Text(
                  "Traffic Details",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: colors.onSurface,
                  ),
                ),
                secondary: const Icon(Icons.traffic, color: Colors.orange),
                value: _trafficEnabled,
                activeThumbColor: Colors.amber,
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

  Widget _buildMapTypeOption(
    String label,
    MapType type,
    IconData icon,
    ColorScheme colors,
  ) {
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
                color: isSelected
                    ? Colors.amber
                    : colors.outline.withValues(alpha: 0.3),
                width: 2,
              ),
              color: isSelected
                  ? Colors.amber.withValues(alpha: 0.1)
                  : Colors.transparent,
            ),
            child: Icon(
              icon,
              color: isSelected
                  ? Colors.amber
                  : colors.onSurface.withValues(alpha: 0.6),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.amber : colors.onSurface,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  // --- CUSTOM POPUP WIDGET ---
  Widget _buildCustomPopup(
    Map<String, dynamic> book,
    ThemeData theme,
    ColorScheme colors,
  ) {
    Color actionColor = _getActionColor(book['action']);

    return Positioned(
      top: 260,
      left: 40,
      right: 40,
      child: Material(
        color: Colors.transparent,
        child: Container(
          decoration: BoxDecoration(
            color: theme.cardColor, // Dynamic Background
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.2),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
            border: Border.all(
              color: actionColor.withValues(alpha: 0.3),
              width: 1,
            ),
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
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: colors.onSurface, // Dynamic Text
                            ),
                          ),
                          Text(
                            book['distance'],
                            style: TextStyle(
                              color: actionColor,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              InkWell(
                                onTap: () => _navigateToDetail(book),
                                child: Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    color: actionColor,
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
                                    color: actionColor.withValues(alpha: 0.1),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.share,
                                    size: 16,
                                    color: actionColor,
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
                  icon: Icon(
                    Icons.close,
                    size: 16,
                    color: colors.onSurface.withValues(alpha: 0.5),
                  ),
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
    // ---------------- THEME DATA ----------------
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

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
              mapType: _currentMapType,
              trafficEnabled: _trafficEnabled,
              markers: _markers,
              onMapCreated: (GoogleMapController controller) {
                _mapController = controller;
              },
              onTap: (LatLng point) {
                if (_selectedBook != null) {
                  setState(() {
                    _selectedBook = null;
                  });
                }
              },
              zoomControlsEnabled: false,
              mapToolbarEnabled: false,
              compassEnabled: true,
              myLocationEnabled: true,
              myLocationButtonEnabled: false,
            ),
          ),

          // 2. CUSTOM POPUP
          if (_selectedBook != null)
            _buildCustomPopup(_selectedBook!, theme, colors),

          // 3. HEADER
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: _buildHeader(context, theme, colors),
          ),

          // 4. MAP LAYERS BUTTON
          Positioned(
            top: 200,
            right: 16,
            child: FloatingActionButton(
              heroTag: "layersBtn",
              mini: true,
              backgroundColor: theme.cardColor, // Dynamic Background
              elevation: 4,
              onPressed: () => _showMapOptions(theme, colors),
              child: Icon(Icons.layers_outlined, color: colors.onSurface),
            ),
          ),

          // 5. FIND ME BUTTON
          Positioned(
            top: 145,
            right: 16,
            child: FloatingActionButton(
              heroTag: "gpsBtn",
              mini: true,
              backgroundColor: theme.cardColor, // Dynamic Background
              elevation: 4,
              child: Icon(Icons.my_location, color: Colors.amber),
              onPressed: () {
                _mapController?.animateCamera(
                  CameraUpdate.newCameraPosition(
                    CameraPosition(target: _initialPosition, zoom: 14),
                  ),
                );
              },
            ),
          ),

          // 7. DRAGGABLE LIST SHEET
          DraggableScrollableSheet(
            initialChildSize: 0.4,
            minChildSize: 0.15,
            maxChildSize: 0.9,
            builder: (BuildContext context, ScrollController scrollController) {
              return Container(
                decoration: BoxDecoration(
                  color:
                      theme.scaffoldBackgroundColor, // Dynamic Sheet Background
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.2),
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
                        color: colors.onSurface.withValues(alpha: 0.2),
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
                          Text(
                            "Books Near You",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: colors.onSurface, // Dynamic Text
                            ),
                          ),
                          Text(
                            "${_books.length} found",
                            style: TextStyle(
                              color: colors.onSurface.withValues(alpha: 0.6),
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
                            theme: theme,
                            colors: colors,
                            onTap: () {
                              _navigateToDetail(b);
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

  // ------------------ HEADER ------------------
  Widget _buildHeader(
    BuildContext context,
    ThemeData theme,
    ColorScheme colors,
  ) {
    return SafeArea(
      child: Container(
        margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        decoration: BoxDecoration(
          color: theme.cardColor, // Dynamic Background
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                style: TextStyle(color: colors.onSurface), // Dynamic Input Text
                cursorColor: Colors.amber,
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: "Search Book Title, author...",
                  hintStyle: TextStyle(
                    color: colors.onSurface.withValues(alpha: 0.5),
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                ),
              ),
            ),
            IconButton(
              icon: Icon(Icons.search, color: Colors.amber),
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }

  // ------------------ BOOK CARD ------------------
  Widget _buildBookCard({
    required String title,
    required String author,
    required String distance,
    required String action,
    required String imageUrl,
    required VoidCallback onTap,
    required ThemeData theme,
    required ColorScheme colors,
  }) {
    Color actionColor = _getActionColor(action);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: theme.cardColor, // Dynamic Card Background
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 5,
              offset: const Offset(0, 2),
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
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: colors.onSurface, // Dynamic Title
                    ),
                  ),
                  Text(
                    author,
                    style: TextStyle(
                      fontSize: 13,
                      color: colors.onSurface.withValues(alpha: 0.6),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Icon(
                        Icons.location_on,
                        size: 14,
                        color: colors.onSurface.withValues(alpha: 0.5),
                      ),
                      Text(
                        distance,
                        style: TextStyle(
                          fontSize: 12,
                          color: colors.onSurface.withValues(alpha: 0.6),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: actionColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: actionColor.withValues(alpha: 0.3)),
              ),
              child: Text(
                action,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: actionColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
