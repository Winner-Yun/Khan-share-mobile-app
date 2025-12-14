import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:google_fonts/google_fonts.dart';
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

  // Session token for billing optimization
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

  Future<List<PlacePrediction>> _getPlacePredictions(String query) async {
    if (query.isEmpty) return [];

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
        _handleTap(newPos);

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
      FocusScope.of(context).unfocus();
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
    // ---------------- THEME DATA ----------------
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: const AssetImage("assets/images/background.jpg"),
              fit: BoxFit.cover,
              opacity: isDark ? 0.2 : 0,
            ),
          ),
        ),
        title: Text(
          "Pick Location",
          style: GoogleFonts.poppins(
            // Use dynamic primary color
            color: Colors.amber,
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: Colors.amber),
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
                color: theme.cardColor, // Dynamic Background
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: TypeAheadField<PlacePrediction>(
                controller: _searchController,
                builder: (context, controller, focusNode) {
                  return TextField(
                    controller: controller,
                    focusNode: focusNode,
                    style: TextStyle(
                      color: colors.onSurface,
                    ), // Typing text color
                    cursorColor: Colors.amber,
                    textInputAction: TextInputAction.search,
                    decoration: InputDecoration(
                      hintText: "Search places in Phnom Penh...",
                      hintStyle: TextStyle(
                        color: colors.onSurface.withValues(alpha: 0.5),
                      ),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 14,
                      ),
                      prefixIcon: Icon(Icons.search, color: Colors.amber),
                      suffixIcon: IconButton(
                        icon: Icon(
                          Icons.clear,
                          color: colors.onSurface.withValues(alpha: 0.5),
                        ),
                        onPressed: () => controller.clear(),
                      ),
                    ),
                  );
                },
                suggestionsCallback: (pattern) async {
                  return await _getPlacePredictions(pattern);
                },
                emptyBuilder: (context) {
                  return Container(
                    padding: const EdgeInsets.all(20.0),
                    decoration: BoxDecoration(
                      color: theme.cardColor,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.search_off_rounded,
                          size: 20,
                          color: colors.onSurface.withValues(alpha: 0.5),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          "No places found",
                          style: TextStyle(
                            color: colors.onSurface.withValues(alpha: 0.6),
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  );
                },
                itemBuilder: (context, prediction) {
                  return ListTile(
                    tileColor: theme.cardColor, // Dynamic list background
                    leading: Icon(Icons.location_on, color: Colors.amber),
                    title: Text(
                      prediction.description,
                      style: TextStyle(color: colors.onSurface), // Dynamic text
                    ),
                  );
                },
                onSelected: (prediction) {
                  _searchController.text = prediction.description;
                  _getPlaceDetails(prediction.placeId);
                },
                decorationBuilder: (context, child) {
                  return Material(
                    type: MaterialType.card,
                    elevation: 4,
                    color: theme.cardColor, // Dropdown container color
                    borderRadius: BorderRadius.circular(15),
                    child: child,
                  );
                },
                offset: const Offset(0, 5),
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
              backgroundColor: theme.cardColor, // Dynamic Background
              onPressed: () => _showMapOptions(theme, colors),
              child: Icon(Icons.layers_outlined, color: colors.onSurface),
            ),
          ),

          // 4. MY LOCATION BUTTON
          Positioned(
            top: 230,
            right: 20,
            child: FloatingActionButton(
              heroTag: "gpsBtn",
              mini: true,
              backgroundColor: theme.cardColor, // Dynamic Background
              child: Icon(Icons.my_location, color: Colors.amber),
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
                backgroundColor: Colors.amber, // Dynamic Amber
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
                  color: Colors.white, // Text is always white on primary button
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- BOTTOM SHEET ---
  void _showMapOptions(ThemeData theme, ColorScheme colors) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          decoration: BoxDecoration(
            color: theme.cardColor, // Dynamic Sheet Background
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
                  color: colors.onSurface, // Dynamic Title
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

  Widget _buildMapTypeOption(
    String label,
    MapType type,
    IconData icon,
    ColorScheme colors,
  ) {
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
