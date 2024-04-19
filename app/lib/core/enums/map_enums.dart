enum MapMode { WALKING, CYCLE, TWO_WHEELER }

extension MapModeExtension on MapMode {
  String get textValue {
    switch (this) {
      case MapMode.WALKING:
        return "Walking distance";
      case MapMode.CYCLE:
        return "Cycling distance";
      case MapMode.TWO_WHEELER:
        return "Driving distance";
    }
  }
}
