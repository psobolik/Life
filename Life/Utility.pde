static class Utility {
  static boolean isPointInRect(
      int pointLeft,
      int pointTop,
      int rectLeft,
      int rectTop,
      int rectWidth,
      int rectHeight) {
    var left = pointLeft - rectLeft;
    var top = pointTop - rectTop;
    return left > 0 && left < rectWidth && top > 0 && top < rectHeight;
  }

  static int saturatingAdd(int value, int valueToAdd) {
    return value < Integer.MAX_VALUE - valueToAdd
        ? value + valueToAdd
        : Integer.MAX_VALUE;
  }

  static int saturatingSub(int value, int valueToSubtract) {
    return value > valueToSubtract
        ? value - valueToSubtract
        : 0;
  }

  static long hexStringToLong(String hexString) {
    final String hexDigits = "0123456789abcdef";

    long accumulator = 0;

    for (char hexDigit: hexString.toLowerCase().toCharArray()) {
      var decimalDigit = hexDigits.indexOf(hexDigit);
      if (decimalDigit < 0) continue; // Ignore invalid characters
      accumulator = (accumulator << 4) + decimalDigit;
    }
    return accumulator;
  }

}
// Can't call 'color' in a static method!
color hexStringToColor(String hexString) {
  var rgbColor = new RgbColor(hexString);
  return color(rgbColor.red, rgbColor.green, rgbColor.blue);
}
