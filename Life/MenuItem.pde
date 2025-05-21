class MenuItem {
  private MenuAction _action;
  private String _text;
  private String _hotKey;
  private int _left;
  private int _top;
  private int _width;
  private int _height;
  
  public MenuItem(
    MenuAction action, 
    String text, 
    String hotKey,  
    int left,
    int top,
    int width,
    int height) {
    _action = action;
    _text = text;
    _hotKey = hotKey;
    _left = left;
    _top = top;
    _width = width;
    _height = height;
  }
  public MenuAction getAction() { return _action; }
  public String getText() { return _text; }
  public String getHotKey() { return _hotKey; }
  public int getLeft() { return _left; }
  public int getTop() { return _top; }
  public int getWidth() { return _width; }
  public int getHeight() { return _height; }
}
