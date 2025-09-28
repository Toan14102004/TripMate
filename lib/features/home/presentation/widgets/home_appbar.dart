import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import '../../data/sources/home_api_source.dart';
import 'package:trip_mate/commons/helpers/is_dark_mode.dart';

class HomeAppBar extends StatefulWidget {
  const HomeAppBar({super.key});

  @override
  State<HomeAppBar> createState() => _HomeAppBarState();
}

class _HomeAppBarState extends State<HomeAppBar> {
  String _location = "Loading...";
  String? _avatarUrl;

  @override
  void initState() {
    super.initState();
    _getLocation();
    _getAvatar();
  }

  Future<void> _getLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );
      if (placemarks.isNotEmpty) {
        final place = placemarks.first;
        setState(() {
          _location = "${place.locality}, ${place.country}";
        });
      }
    } catch (e) {
      setState(() {
        _location = "Unknown location";
      });
    }
  }

  Future<void> _getAvatar() async {
    final url = await HomeApiSource().fetchUserAvatarUrl();
    setState(() {
      _avatarUrl = url;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          radius: 22,
          backgroundImage: _avatarUrl != null
              ? AssetImage(_avatarUrl!)
              : const AssetImage('assets/images/avatar.png'),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.location_on, color: Colors.orange, size: 18),
                const SizedBox(width: 4),
                Text(_location, style: const TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
          ],
        ),
        const Spacer(),
        Container(
          decoration: BoxDecoration(
            color: context.isDarkMode ? Colors.grey.shade700 :Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4)],
          ),
          child: const Icon(Icons.more_vert),
        ),
      ],
    );
  }
}