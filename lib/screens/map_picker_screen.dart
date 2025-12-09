import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:khan_share_mobile_app/config/appColors.dart'; // Ensure you have this or use Colors.amber

class MapPickerScreen extends StatefulWidget {
  const MapPickerScreen({super.key});

  @override
  State<MapPickerScreen> createState() => _MapPickerScreenState();
}

class _MapPickerScreenState extends State<MapPickerScreen> {
  // 1. Map Controller
  GoogleMapController? _mapController;
  final TextEditingController _searchController = TextEditingController();

  // 2. Map State
  LatLng _selectedLocation = const LatLng(11.5564, 104.9282); // Default
  MapType _currentMapType = MapType.normal;
  bool _trafficEnabled = false;

  // 3. Handle Tap on Map
  void _handleTap(LatLng point) {
    setState(() {
      _selectedLocation = point;
      FocusScope.of(context).unfocus(); // Close keyboard
    });
    // Optional: Animate camera to the tapped point
    _mapController?.animateCamera(CameraUpdate.newLatLng(point));
  }

  // 4. Confirm Selection
  void _confirmSelection() {
    String locationString =
        "Lat: ${_selectedLocation.latitude.toStringAsFixed(4)}, Long: ${_selectedLocation.longitude.toStringAsFixed(4)}";
    Navigator.pop(context, locationString);
  }

  // 5. Map Options Modal
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
                color: isSelected ? Colors.amber : Colors.grey.shade300,
                width: 2,
              ),
              color: isSelected ? Colors.amber.withOpacity(0.1) : Colors.white,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset:
          false, // Prevents FABs moving up when keyboard opens
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

          // 2. SEARCH BAR (Visual Only)
          Positioned(
            top: 130, // Below AppBar
            left: 20,
            right: 20,
            child: Container(
              height: 45,
              padding: const EdgeInsets.symmetric(horizontal: 16),
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
              child: TextField(
                controller: _searchController,
                textInputAction: TextInputAction.search,
                cursorColor: Colors.black,
                style: const TextStyle(color: Colors.black),
                decoration: InputDecoration(
                  hintText: "Search places...",
                  border: InputBorder.none,
                  icon: const Icon(Icons.search, color: Colors.amber),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.clear, color: Colors.grey),
                    onPressed: () {
                      _searchController.clear();
                    },
                  ),
                ),
                onSubmitted: (value) {
                  // Placeholder for future logic
                  debugPrint("Search submitted: $value");
                  FocusScope.of(context).unfocus();
                },
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
                backgroundColor:
                    Colors.amber, // Using amber instead of AppColor.exchange
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
}
