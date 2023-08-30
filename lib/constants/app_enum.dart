enum SharedPreferencesKey {
  locationAddress,
}

extension SharedPreferencesDefinition on SharedPreferencesKey {
  String get definition {
    switch (this) {
      case SharedPreferencesKey.locationAddress:
        return "locationAddress";
      default:
        return "default case";
    }
  }
}