// Thêm biến instance UUID
import 'package:uuid/uuid.dart';

// Helper method để sinh UUID
String generateUuid() {
  const uuid = Uuid();
  return uuid.v4(); // Sử dụng UUID version 4 (random)
}
