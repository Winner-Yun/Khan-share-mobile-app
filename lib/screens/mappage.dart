import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_marker_popup/flutter_map_marker_popup.dart'; // IMPORT THIS
import 'package:khan_share_mobile_app/screens/book_detailscreen.dart';
import 'package:latlong2/latlong.dart';

class MapViewScreen extends StatefulWidget {
  const MapViewScreen({super.key});

  @override
  State<MapViewScreen> createState() => _MapViewScreenState();
}

class _MapViewScreenState extends State<MapViewScreen> {
  final MapController _mapController = MapController();
  final PopupController _popupController =
      PopupController(); // 1. Add Controller
  final TextEditingController _searchController = TextEditingController();
  final LatLng _initialPosition = const LatLng(11.5564, 104.9282);

  List<Marker> _bookMarkers = [];
  Marker? _userPinMarker;

  final List<Map<String, dynamic>> _books = [
    {
      "title": "To Kill a Mockingbird",
      "author": "Harper Lee",
      "distance": "2.5 km",
      "action": "Donate",
      "image":
          "https://m.media-amazon.com/images/I/81OthjkJBuL._AC_UF1000,1000_QL80_.jpg",
      "location": const LatLng(11.5580, 104.9290),
    },
    {
      "title": "1984",
      "author": "George Orwell",
      "distance": "1.8 km",
      "action": "Exchange",
      "image":
          "https://m.media-amazon.com/images/I/71kxa1-0mfL._AC_UF1000,1000_QL80_.jpg",
      "location": const LatLng(11.5540, 104.9270),
    },
    {
      "title": "The Great Gatsby",
      "author": "F. Scott Fitzgerald",
      "distance": "3.2 km",
      "action": "Donate",
      "image":
          "https://m.media-amazon.com/images/I/71FTb9X6wsL._AC_UF1000,1000_QL80_.jpg",
      "location": const LatLng(11.5600, 104.9300),
    },
    {
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

  void _loadBookMarkers() {
    setState(() {
      _bookMarkers = _books.map((book) {
        return Marker(
          point: book['location'],
          width: 80,
          height: 80,
          alignment: Alignment.topCenter, // Aligns pin correctly
          // NOTE: No GestureDetector here anymore. The PopupLayer handles the tap!
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.teal, width: 2),
                  boxShadow: const [
                    BoxShadow(blurRadius: 5, color: Colors.black26),
                  ],
                ),
                child: CircleAvatar(
                  radius: 22,
                  backgroundImage: NetworkImage(book['image']),
                ),
              ),
              const Icon(Icons.arrow_drop_down, color: Colors.teal, size: 28),
            ],
          ),
        );
      }).toList();
    });
  }

  void _setUserPin(LatLng tappedPoint) {
    _popupController.hideAllPopups(); // Hide popups if clicking elsewhere
    setState(() {
      _userPinMarker = Marker(
        point: tappedPoint,
        width: 60,
        height: 60,
        child: const Icon(
          Icons.location_on,
          color: Colors.red,
          size: 50,
          shadows: [Shadow(blurRadius: 10, color: Colors.black45)],
        ),
      );
    });
  }

  void _clearUserPin() {
    setState(() {
      _userPinMarker = null;
    });
  }

  // --- CUSTOM POPUP WIDGET (The Card Style) ---
  Widget _buildCustomPopup(Map<String, dynamic> book) {
    return Container(
      width: 280,
      margin: const EdgeInsets.only(bottom: 10),
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
                // Image
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    book['image'],
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 12),
                // Text Content
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
                        style: TextStyle(color: Colors.teal[700], fontSize: 12),
                      ),
                      const SizedBox(height: 8),
                      // Action Buttons
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
                            onTap: () {}, // Share logic
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
          // Close Button
          Positioned(
            top: 0,
            right: 0,
            child: IconButton(
              icon: const Icon(Icons.close, size: 16, color: Colors.grey),
              onPressed: () => _popupController.hideAllPopups(),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 1. MAP LAYER
          Positioned.fill(
            child: FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                initialCenter: _initialPosition,
                initialZoom: 14.0,
                // Hide popups AND set user pin when clicking map
                onTap: (tapPosition, point) => _setUserPin(point),
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.example.khan_share_mobile_app',
                ),

                // Layer for User Pin (Standard Marker)
                if (_userPinMarker != null)
                  MarkerLayer(markers: [_userPinMarker!]),

                // Layer for Books (Popup Marker Layer)
                PopupMarkerLayer(
                  options: PopupMarkerLayerOptions(
                    popupController: _popupController,
                    markers: _bookMarkers,
                    popupDisplayOptions: PopupDisplayOptions(
                      builder: (BuildContext context, Marker marker) {
                        // Find the book data that matches this marker
                        final book = _books.firstWhere(
                          (b) => b['location'] == marker.point,
                        );
                        return _buildCustomPopup(book);
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),

          // 2. HEADER
          Positioned(top: 0, left: 0, right: 0, child: _buildHeader(context)),

          // 3. CLEAR PIN BUTTON
          if (_userPinMarker != null)
            Positioned(
              top: 200,
              right: 16,
              child: FloatingActionButton.extended(
                heroTag: "clearBtn",
                onPressed: _clearUserPin,
                backgroundColor: Colors.red,
                icon: const Icon(Icons.close, color: Colors.white),
                label: const Text(
                  "Clear Pin",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),

          // 4. FIND ME BUTTON
          Positioned(
            top: 135,
            right: 16,
            child: FloatingActionButton(
              heroTag: "gpsBtn",
              mini: true,
              backgroundColor: Colors.white,
              child: const Icon(Icons.my_location, color: Colors.teal),
              onPressed: () {
                _mapController.move(_initialPosition, 14.0);
              },
            ),
          ),

          // 5. DRAGGABLE LIST SHEET
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
                              _mapController.move(b['location'], 15.0);
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
        // Reduced vertical padding slightly so the cursor is centered nicely
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
            // THE REAL TEXT FIELD
            Expanded(
              child: TextField(
                style: TextStyle(color: Colors.black),
                cursorColor: Colors.teal,
                controller: _searchController,
                decoration: const InputDecoration(
                  hintText: "Search Book Title, author...",
                  hintStyle: TextStyle(color: Colors.black54),
                  border: InputBorder.none, // Removes the underline
                  contentPadding: EdgeInsets.symmetric(horizontal: 10),
                ),
                onSubmitted: (value) {
                  debugPrint("User searched for: $value");
                },
              ),
            ),

            // Search Icon
            IconButton(
              icon: const Icon(Icons.search, color: Colors.teal),
              onPressed: () {
                // Logic to search using _searchController.text
              },
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
