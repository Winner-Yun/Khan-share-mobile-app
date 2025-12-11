import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';

class MapPickerScreen extends StatefulWidget {
  const MapPickerScreen({super.key});

  @override
  State<MapPickerScreen> createState() => _MapPickerScreenState();
}

class _MapPickerScreenState extends State<MapPickerScreen> {
  // 1. Google Maps & Search Controllers
  GoogleMapController? _mapController;
  final TextEditingController _searchController = TextEditingController();

  // Replace with your valid Google Places API Key
  final String _googleApiKey = "AIzaSyDFnazV9bdy9sHWHZyMW6Bx3fYakQ_-Ax4";

  // Session token for billing optimization (Reduces cost significantly)
  var _sessionToken = const Uuid().v4();

  // 2. Map State
  LatLng _selectedLocation = const LatLng(
    11.5564,
    104.9282,
  ); // Default: Phnom Penh
  MapType _currentMapType = MapType.normal;
  bool _trafficEnabled = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // --- API LOGIC ---

  // Fetch Autocomplete Suggestions
  Future<List<PlacePrediction>> _getPlacePredictions(String query) async {
    if (query.isEmpty) return [];

    // UPDATED URL:
    // 1. components=country:kh  -> Restrict results to Cambodia
    // 2. location=11.5564,104.9282 -> Bias towards Phnom Penh coordinates
    // 3. radius=25000 -> Prioritize results within 25km of the city center
    final String url =
        "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$query&key=$_googleApiKey&sessiontoken=$_sessionToken&components=country:kh&location=11.5564,104.9282&radius=25000";

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['status'] == 'OK') {
        return (data['predictions'] as List)
            .map((p) => PlacePrediction.fromJson(p))
            .toList();
      }
    }
    return [];
  }

  // Fetch Lat/Lng for a selected Place ID
  Future<void> _getPlaceDetails(String placeId) async {
    final String url =
        "https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=$_googleApiKey&sessiontoken=$_sessionToken";

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['status'] == 'OK') {
        final location = data['result']['geometry']['location'];
        final lat = location['lat'];
        final lng = location['lng'];

        final newPos = LatLng(lat, lng);
        _handleTap(newPos); // Update map

        // Regenerate session token after a selection is made (Google Requirement)
        setState(() {
          _sessionToken = const Uuid().v4();
        });
      }
    }
  }

  // --- MAP LOGIC ---

  void _handleTap(LatLng point) {
    setState(() {
      _selectedLocation = point;
      FocusScope.of(context).unfocus(); // Close keyboard
    });
    _mapController?.animateCamera(CameraUpdate.newLatLng(point));
  }

  void _confirmSelection() {
    String locationString =
        "Lat: ${_selectedLocation.latitude.toStringAsFixed(4)}, Long: ${_selectedLocation.longitude.toStringAsFixed(4)}";
    Navigator.pop(context, locationString);
  }

  // --- UI BUILDER ---

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/background.jpg"),
              fit: BoxFit.cover,
            ),
          ),
        ),
        title: const Text(
          "Pick Location",
          style: TextStyle(color: Colors.amber, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.amber),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Stack(
        children: [
          // 1. GOOGLE MAP
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: _selectedLocation,
              zoom: 15.0,
            ),
            mapType: _currentMapType,
            trafficEnabled: _trafficEnabled,
            onMapCreated: (controller) => _mapController = controller,
            onTap: _handleTap,
            markers: {
              Marker(
                markerId: const MarkerId("picked_loc"),
                position: _selectedLocation,
                icon: BitmapDescriptor.defaultMarkerWithHue(
                  BitmapDescriptor.hueRed,
                ),
              ),
            },
            zoomControlsEnabled: false,
            mapToolbarEnabled: false,
            myLocationButtonEnabled: false,
            myLocationEnabled: true,
            compassEnabled: true,
          ),

          // 2. AUTOCOMPLETE SEARCH BAR
          Positioned(
            top: 120, // Adjusted for SafeArea
            left: 20,
            right: 20,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                    offset: Offset(0, 5),
                  ),
                ],
              ),
              child: TypeAheadField<PlacePrediction>(
                controller: _searchController,
                builder: (context, controller, focusNode) {
                  return TextField(
                    controller: controller,
                    focusNode: focusNode,
                    cursorColor: Colors.black,
                    textInputAction: TextInputAction.search,
                    decoration: InputDecoration(
                      hintText: "Search places in Phnom Penh...",
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 14,
                      ),
                      prefixIcon: const Icon(Icons.search, color: Colors.amber),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.clear, color: Colors.grey),
                        onPressed: () => controller.clear(),
                      ),
                    ),
                  );
                },
                suggestionsCallback: (pattern) async {
                  return await _getPlacePredictions(pattern);
                },
                emptyBuilder: (context) {
                  return SizedBox(
                    height: 50,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Row(
                        spacing: 8,
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.search_off_rounded,
                            size: 20,
                            color: Colors.grey,
                          ),
                          const SizedBox(height: 10),
                          Text(
                            "No places found",
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
                itemBuilder: (context, prediction) {
                  return ListTile(
                    leading: const Icon(Icons.location_on, color: Colors.amber),
                    title: Text(prediction.description),
                  );
                },
                onSelected: (prediction) {
                  _searchController.text = prediction.description;
                  _getPlaceDetails(prediction.placeId);
                },
                // Customizing the suggestion box
                decorationBuilder: (context, child) {
                  return Material(
                    type: MaterialType.card,
                    elevation: 4,
                    borderRadius: BorderRadius.circular(15),
                    child: child,
                  );
                },
                offset: const Offset(0, 5), // Gap between field and list
              ),
            ),
          ),

          // 3. MAP LAYERS BUTTON
          Positioned(
            top: 180,
            right: 20,
            child: FloatingActionButton(
              heroTag: "layersBtn",
              mini: true,
              backgroundColor: Colors.white,
              onPressed: _showMapOptions,
              child: const Icon(Icons.layers_outlined, color: Colors.black87),
            ),
          ),

          // 4. MY LOCATION BUTTON
          Positioned(
            top: 230,
            right: 20,
            child: FloatingActionButton(
              heroTag: "gpsBtn",
              mini: true,
              backgroundColor: Colors.white,
              child: const Icon(Icons.my_location, color: Colors.amber),
              onPressed: () {
                _mapController?.animateCamera(
                  CameraUpdate.newCameraPosition(
                    CameraPosition(target: _selectedLocation, zoom: 15),
                  ),
                );
              },
            ),
          ),

          // 5. CONFIRM BUTTON
          Positioned(
            bottom: 30,
            left: 20,
            right: 20,
            child: ElevatedButton(
              onPressed: _confirmSelection,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.amber,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                elevation: 5,
                shadowColor: Colors.black45,
              ),
              child: const Text(
                "Confirm Location",
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- BOTTOM SHEET (Unchanged Logic) ---
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
                secondary: const Icon(Icons.traffic, color: Colors.amber),
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

  Widget _buildMapTypeOption(String label, MapType type, IconData icon) {
    final bool isSelected = _currentMapType == type;
    return GestureDetector(
      onTap: () {
        setState(() => _currentMapType = type);
        Navigator.pop(context);
      },
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: isSelected ? Colors.amber : Colors.grey.shade300,
                width: 2,
              ),
              color: isSelected
                  ? Colors.amber.withValues(alpha: 0.1)
                  : Colors.white,
            ),
            child: Icon(
              icon,
              color: isSelected ? Colors.amber : Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.amber : Colors.black87,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}

// Helper Class for Predictions
class PlacePrediction {
  final String description;
  final String placeId;

  PlacePrediction({required this.description, required this.placeId});

  factory PlacePrediction.fromJson(Map<String, dynamic> json) {
    return PlacePrediction(
      description: json['description'] ?? '',
      placeId: json['place_id'] ?? '',
    );
  }
}
