class RgbColor {
  int red;
  int green;
  int blue;

  RgbColor(String hexString) {
    hexString = hexString.startsWith("#") 
      ? hexString.substring(1) 
      : hexString.startsWith("0x") 
        ? hexString.substring(2) 
        : hexString;
    if (hexString.length() == 6) {
      red = int(Utility.hexStringToLong(hexString.substring(0, 2)));
      green = int(Utility.hexStringToLong(hexString.substring(2, 4)));
      blue = int(Utility.hexStringToLong(hexString.substring(4, 6)));
    }
  }
}
