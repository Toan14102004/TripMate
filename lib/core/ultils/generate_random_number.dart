import 'dart:math';

int generateRandomNumber({required int min, required int max}) {
    final random = Random();
    return min + random.nextInt(max - min + 1);
  }