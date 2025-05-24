static final int MARGIN = 10;
static final int HEADER_HEIGHT = 40;

static final int DEFAULT_DELAY = 10;
static final int DELAY_STEP = 1;

static final int CELL_COUNT = 100;
static final int GRID_SIZE = 800;

static final int CONTROL_C = 3;
static final int CONTROL_O = 15;
static final int CONTROL_Q = 17;

private static String _patternName = "";

private static boolean _forceDraw = false;
private static int _delay = DEFAULT_DELAY;
private static int _delay_counter = 0;

private static boolean _running = false;
private Grid _grid;
private Header _header;
private Menu _menu;
private Theme _theme = new Theme();

// Processing callbacks
void setup() {
  // width = GRID_SIZE + MARGIN + MARGIN
  // height = HEADER_HEIGHT + MARGIN + MARGIN
  size(820, 860);

  _theme = loadTheme("theme.json");
  // println(_theme.toJson());
  _grid = new Grid(CELL_COUNT, 0, HEADER_HEIGHT, GRID_SIZE, MARGIN, _theme.gridTheme);
  _header = new Header(GRID_SIZE + MARGIN + MARGIN, HEADER_HEIGHT, _theme.headerTheme, _theme.hoverButtonTheme);
  _menu = new Menu(_header.getButtonLeft(), _header.getButtonBottom(), _theme.menuTheme);

  _grid.draw();
}

void draw() {
  setTitle();
  _header.draw(_running, _grid.getGenerations(), _delay);
  _menu.draw(); // Only draws itself if it's open

  if (_running) {
    if (!_menu.isOpen() && ++_delay_counter > _delay) {
      _delay_counter = 0;
      _grid.evolve();
    }
    _grid.draw();
  } else if (_forceDraw) {
    _forceDraw = false;
    _grid.draw();
  }
}

void mousePressed() {
  // Handle button clicks
  switch (_header.getButtonAction(mouseX, mouseY)) {
    case Menu:
      toggleMenu();
      return;
    case PlayPause:
      playPause();
      return;
    case Step:
      step();
      return;
    case None:
      break;
  }
  // Handle menu clicks
  if (_menu.isOpen()) {
    switch (_menu.getAction(mouseX, mouseY)) {
      case Random:
        insertRandomPattern();
        break;
      case Clear:
        clearGrid();
        break;
      case File:
        insertPatternFromFile();
        break;
      case Quit:
        exit();
        break;
      case None:
        break;
    }
    _menu.setClosed();
    _forceDraw = true;
  } else if (edit()) {
    _forceDraw = true;
  }
}

void mouseMoved() {
  if (!_menu.isOpen() && _grid.mouseInGrid())
    cursor(CROSS);
  else
    cursor(ARROW);
}

void keyPressed() {
  if (key == CODED) {
    switch (keyCode) {
      case java.awt.event.KeyEvent.VK_UP:
        _grid.rotateGridUp();
        _forceDraw = true;
        break;
      case java.awt.event.KeyEvent.VK_DOWN:
        _grid.rotateGridDown();
        _forceDraw = true;
        break;
      case java.awt.event.KeyEvent.VK_LEFT:
        _grid.rotateGridLeft();
        _forceDraw = true;
        break;
      case java.awt.event.KeyEvent.VK_RIGHT:
        _grid.rotateGridRight();
        _forceDraw = true;
        break;
      case java.awt.event.KeyEvent.VK_F1:
        _grid.rotateGridClockwise();
        _forceDraw = true;
        break;
      case java.awt.event.KeyEvent.VK_F2:
        _grid.rotateGridCounterClockwise();
        _forceDraw = true;
        break;
      case java.awt.event.KeyEvent.VK_F3:
        _grid.flipGridHorizontal();
        _forceDraw = true;
        break;
      case java.awt.event.KeyEvent.VK_F4:
        _grid.flipGridVertical();
        _forceDraw = true;
        break;
    }
  } else {
    switch (key) {
      case '+':
        incDelay(DELAY_STEP);
        break;
      case '-':
        decDelay(DELAY_STEP);
        break;
      case ' ':
        playPause();
        break;
      case '.':
        step();
        break;
      case 'c':
      case 'C':
        clearGrid();
        _forceDraw = true;
        break;
      case 'r':
      case 'R':
        insertRandomPattern();
        _forceDraw = true;
        break;
      case ESC:
        key = 0; // Don't close on Escape
        break;
      case CONTROL_O:
        insertPatternFromFile();
        break;
      case CONTROL_Q:
        exit();
    }
  }
}

//---------------------------------------
void toggleMenu() {
  if (_menu.isOpen()) {
    _menu.setClosed();
    _forceDraw = true;
  } else {
    _menu.setOpen();
  }
}

void clearGrid() {
  _patternName = "";
  _running = false;
  _grid.reset();
}

void playPause() {
  _running = !_running;
  _forceDraw = _menu.isOpen();
  _menu.setClosed();
}

void step() {
  _menu.setClosed();
  _running = false;
  _grid.evolve();
  _header.draw(_running, _grid.getGenerations(), _delay);
  _grid.draw();
}

void insertPatternFromFile() {
  selectInput("Select a Pattern File (.cells or .rle)", "processFile");
}

void processFile(File selection) {
  if (selection != null) {
    var pattern = new Importer().importPattern(selection);
    var dimensions = pattern.getDimensions();
    pattern.setRow((CELL_COUNT - dimensions.getRow()) / 2);
    pattern.setCol((CELL_COUNT - dimensions.getCol()) / 2);
    clearGrid();
    insertPattern(pattern);
    _forceDraw = true;
  }
}

void insertRandomPattern() {
  clearGrid();
  _patternName = "Random";
  int lowerLimit = CELL_COUNT / 5;
  int upperLimit = lowerLimit * 4;
  for (int i = 0; i < 500; ++i) {
    float row = random(lowerLimit, upperLimit);
    float col = random(lowerLimit, upperLimit);
    _grid.setCellStatus(int(row), int(col), CellStatus.Populated);
  }
}

void insertPattern(Pattern pattern) {
  _patternName = pattern.getName();
  _grid.insertPattern(pattern);
}

void setTitle() {
  var title = "Conway's Game of Life";
  if (_patternName.length() > 0) {
    title += " - " + _patternName;
  }
  windowTitle(title);
}

private boolean edit() {
  if (!_grid.mouseInGrid()) return false;

  _patternName = "Custom";
  var cell = _grid.cellAt(pmouseX, pmouseY);
  _grid.toggleStatus(cell.getRow(), cell.getCol());
  return true;
}

private void incDelay(int step) {
  _delay = Utility.saturatingAdd(_delay, step);
}

private void decDelay(int step) {
  _delay = Utility.saturatingSub(_delay, step);
}
