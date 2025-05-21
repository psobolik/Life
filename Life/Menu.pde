public class Menu {
    private final color MENU_BORDER_COLOR = #000000;
    private final color MENU_COLOR = #404040;
    private final color MENU_TEXT_COLOR = #ffffff;
    private final color MENU_HOVER_COLOR = #8888ff;
    private final color MENU_TEXT_HOVER_COLOR = #ffffff;

    private final int MENU_ITEM_WIDTH = 235;
    private final int MENU_ITEM_HEIGHT = 32;
    private final int MENU_TEXT_SIZE = 16;

    private ArrayList<MenuItem> _menuItems = new ArrayList<MenuItem>();
    private boolean _isMenuOpen = false;

    public Menu(int left, int top) {
        _menuItems.add(new MenuItem(MenuAction.File, "Insert Pattern from File…", "Ctrl+O", left, top, MENU_ITEM_WIDTH, MENU_ITEM_HEIGHT));
        top += MENU_ITEM_HEIGHT;
        _menuItems.add(new MenuItem(MenuAction.Random, "Insert Random Pattern", "R", left, top, MENU_ITEM_WIDTH, MENU_ITEM_HEIGHT));
        top += MENU_ITEM_HEIGHT;
        _menuItems.add(new MenuItem(MenuAction.Clear, "Clear grid", "C", left, top, MENU_ITEM_WIDTH, MENU_ITEM_HEIGHT));
        top += MENU_ITEM_HEIGHT;
        _menuItems.add(new MenuItem(MenuAction.Quit, "Quit", "Ctrl+C", left, top, MENU_ITEM_WIDTH, MENU_ITEM_HEIGHT));
    }
    public boolean isOpen() { return _isMenuOpen; }
    public void setOpen() { _isMenuOpen = true; }
    public void setClosed() { _isMenuOpen = false; }

    public MenuAction getAction(int x, int y) {
        for (MenuItem menuItem : _menuItems) {
            if (Utility.isPointInRect(x, y, menuItem.getLeft(), menuItem.getTop(), menuItem.getWidth(), menuItem.getHeight())) {
                return menuItem.getAction();
            }
        }
        return MenuAction.None;
    }
    private boolean mouseInMenu() {
        if (!_isMenuOpen || _menuItems.size() < 1) return false;

        int left = _menuItems.get(0).getLeft();
        int top = _menuItems.get(0).getTop();
        int width = _menuItems.get(0).getWidth();
        int height = 0;
        for (MenuItem menuItem : _menuItems) {
            height += menuItem.getHeight();
        }
        return Utility.isPointInRect(pmouseX, pmouseY, left, top, width, height);
    }
    void draw() {
        if (!isOpen()) return;

        final int margin = 5;

        push();
        
        textSize(MENU_TEXT_SIZE);
        textAlign(LEFT, CENTER);

        for (MenuItem menuItem : _menuItems) {
            var left = menuItem.getLeft();
            var top = menuItem.getTop();
            var width = menuItem.getWidth();
            var height = menuItem.getHeight();
            var hover = Utility.isPointInRect(pmouseX, pmouseY, left, top, width, height);
            // Box
            stroke(MENU_BORDER_COLOR);
            fill(hover ? MENU_HOVER_COLOR : MENU_COLOR);
            rect(left, top, width, height);
            // Text
            stroke(MENU_TEXT_COLOR);
            left += margin;
            fill(hover ? MENU_TEXT_HOVER_COLOR : MENU_TEXT_COLOR);
            text(menuItem.getText(), left, top, width, height);
            // Hot key
            var hotKey = menuItem.getHotKey();
            if (hotKey != null) {
                left = width - int(textWidth(hotKey));
                text(hotKey, left, top, width, height);
            }
        }
        pop();
    }
}
