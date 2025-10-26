import 'dart:math';

double randomDoubleInRange(double min, double max) {
  final random = Random();
  return (max - min) * random.nextDouble() + min;
}

int randomIntInRange(int min, int max) {
  final random = Random();
  return random.nextInt(max - min + 1) + min;
}
