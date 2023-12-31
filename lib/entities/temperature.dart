class Temperature {
  Temperature.celsius(this.celsius);
  factory Temperature.fahrenheit(double fahrenheit) =>
      Temperature.celsius((fahrenheit - 32) / 1.8);
  factory Temperature.kelvin(double kelvin) =>
      Temperature.celsius(kelvin - absoluteZero);

  static double absoluteZero = 273.15;

  final double celsius;
  double get farhenheit => celsius * 1.8 + 32;
}
