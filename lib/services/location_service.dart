import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:trip_mate/commons/log.dart';

class LocationService {
  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      logDebug('Dịch vụ định vị chưa được bật.');
      return Future.error('Dịch vụ định vị chưa được bật.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        logDebug('Quyền truy cập vị trí bị từ chối.');
        return Future.error('Quyền truy cập vị trí bị từ chối.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      logDebug(
        'Quyền truy cập vị trí bị từ chối vĩnh viễn. Vui lòng bật trong cài đặt.',
      );
      return Future.error(
        'Quyền truy cập vị trí bị từ chối vĩnh viễn. Vui lòng bật trong cài đặt.',
      );
    }

    return true;
  }

  Future<String> getCurrentCityName() async {
    try {
      if (!(await _handleLocationPermission())) {
        logError("Không thể xác định vị trí: Thiếu quyền.");
        return "Không thể xác định vị trí: Thiếu quyền.";
      }

      Position position = await Geolocator.getCurrentPosition();

      logDebug("Tọa độ: LAT=${position.latitude}, LNG=${position.longitude}");

      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        Placemark placemark = placemarks.first;
        logDebug("== Dữ liệu Placemark nhận được ==");
        logDebug("locality: ${placemark.locality}");
        logDebug("administrativeArea: ${placemark.administrativeArea}");
        logDebug("subAdministrativeArea: ${placemark.subAdministrativeArea}");
        logDebug("=======================");
        String? cityName = '${placemark.administrativeArea}, ${placemark.subAdministrativeArea}';
        logDebug(cityName.trim());
        return cityName.trim();
      } else {
        logError("Không tìm thấy địa chỉ từ tọa độ.");
        return "Không tìm thấy địa chỉ từ tọa độ.";
      }
    } catch (e) {
      logError("Lỗi khi lấy vị trí: $e");
      return "Lỗi: ${e.toString()}";
    }
  }
}
