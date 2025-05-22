public static class Utility {
  public static boolean isPointInRect(
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

  private static int saturatingAdd(int value, int valueToAdd) {
    return value < Integer.MAX_VALUE - valueToAdd
        ? value + valueToAdd
        : Integer.MAX_VALUE;
  }

  private static int saturatingSub(int value, int valueToSubtract) {
    return value > valueToSubtract
        ? value - valueToSubtract
        : 0;
  }
}