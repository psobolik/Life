public Theme loadTheme(String fileName) {
  var theme = new Theme();
  theme.setFromJson(loadJSONObject(fileName));
  return theme;
}

public class CellTheme {
  public color edge;
  public color populated;
  public color vacant;

  public void setFromJson(JSONObject json) {
    edge = hexStringToColor(json.getString("edge"));
    populated = hexStringToColor(json.getString("populated"));
    vacant = hexStringToColor(json.getString("vacant"));
  }

  public String toJson() {
    return String.format("{\"edge\": #%04X, \"populated\": #%04X, \"vacant\": #%04X}", edge, populated, vacant);
  }
}

public class BorderTheme {
  public color main;
  public color highlight;

  public void setFromJson(JSONObject json) {
    main = hexStringToColor(json.getString("main"));
    highlight = hexStringToColor(json.getString("highlight"));
  }

  public String toJson() {
    return String.format("{\"main\": #%04X, \"highlight\": #%04X}", main, highlight);
  }
}

public class GridTheme {
  public CellTheme cellTheme;
  public BorderTheme borderTheme;

  public GridTheme() {
    cellTheme = new CellTheme();
    borderTheme = new BorderTheme();
  }

  public void setFromJson(JSONObject json) {
    cellTheme.setFromJson(json.getJSONObject("cell"));
    borderTheme.setFromJson(json.getJSONObject("border"));
  }

  public String toJson() {
    return String.format("{\"cell\": %s, \"border\": %s}", cellTheme.toJson(), borderTheme.toJson());
  }
}

public class HeaderTheme {
  public color background;
  public color text;

  public void setFromJson(JSONObject json) {
    background = hexStringToColor(json.getString("background"));
    text = hexStringToColor(json.getString("text"));
  }

  public String toJson() {
    return String.format("{\"background\": %04X, \"text\": %04X}", background, text);
  }
} 

public class ButtonTheme {
  public color icon;
  public color fill;
  public color stroke;

  public void setFromJson(JSONObject json) {
    icon = hexStringToColor(json.getString("icon"));
    fill = hexStringToColor(json.getString("fill"));
    stroke = hexStringToColor(json.getString("stroke"));
  }

  public String toJson() {
    return String.format("{\"icon\": %04X, \"fill\": %04X, \"stroke\": %04X}", icon, fill, stroke);
  }
}

public class HoverButtonTheme {
  public ButtonTheme normal;
  public ButtonTheme hover;

  public HoverButtonTheme() {
    normal = new ButtonTheme();
    hover = new ButtonTheme();
  }

  public void setFromJson(JSONObject json) {
    normal.setFromJson(json.getJSONObject("normal"));
    hover.setFromJson(json.getJSONObject("hover"));
  }

  public String toJson() {
    return String.format("{\"normal\": %s, \"hover\": %s}", normal.toJson(), hover.toJson());
  }
}

public class MenuItemTheme {
  public color background;
  public color text;

  public void setFromJson(JSONObject json) {
    background = hexStringToColor(json.getString("background"));
    text = hexStringToColor(json.getString("text"));
  }

  public String toJson() {
    return String.format("{\"background\": %04X, \"text\": %04X}", background, text);
  }
}

public class MenuTheme {
  public color border;
  public MenuItemTheme normalMenuItem;
  public MenuItemTheme hoverMenuItem;

  public MenuTheme() {
    normalMenuItem = new MenuItemTheme();
    hoverMenuItem = new MenuItemTheme();
  }

  public void setFromJson(JSONObject json) {
    border = hexStringToColor(json.getString("border"));
    normalMenuItem.setFromJson(json.getJSONObject("normal"));
    hoverMenuItem.setFromJson(json.getJSONObject("hover"));
  }

  public String toJson() {
    return String.format("{\"normalMenuItem\": %s, \"hoverMenuItem\"; %s}", normalMenuItem.toJson(), hoverMenuItem.toJson());
  }
}

public class Theme {
  public GridTheme gridTheme;
  public HeaderTheme headerTheme;
  public HoverButtonTheme hoverButtonTheme;
  public MenuTheme menuTheme;

  public Theme() {
    gridTheme = new GridTheme();
    headerTheme = new HeaderTheme();
    hoverButtonTheme = new HoverButtonTheme();
    menuTheme = new MenuTheme();
  }

  public void setFromJson(JSONObject json) {
    gridTheme.setFromJson(json.getJSONObject("grid"));
    headerTheme.setFromJson(json.getJSONObject("header"));
    hoverButtonTheme.setFromJson(json.getJSONObject("button"));
    menuTheme.setFromJson(json.getJSONObject("menu"));
  }

  public String toJson() {
    return String.format("{\"grid\": %s, \"header\": %s, \"button\": %s, \"menu\": %s}", 
      gridTheme.toJson(),
      headerTheme.toJson(),
      hoverButtonTheme.toJson(),
      menuTheme.toJson()
    );
  }
}
