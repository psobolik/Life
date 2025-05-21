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
}