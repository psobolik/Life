class Grid {
  private final color CELL_EDGE_COLOR = #444444;
  private final color POPULATED_CELL_COLOR = #c0c070;
  private final color VACANT_CELL_COLOR = #000000;

  private final color BORDER_COLOR = #444444;
  private final color BORDER_LIGHT = #c0c070;

  private CellStatus[][] _cellStatusGrid;
  private int _left;
  private int _top;
  private int _size;
  private int _margin;
  private int _cellCount;
  private int _generations;
  
  public Grid(int cellCount, int left, int top, int size, int margin) {
    _left = left;
    _top = top;
    _size = size;
    _margin = margin;
    _cellCount = cellCount;
    _cellStatusGrid = new CellStatus[cellCount][cellCount];
    clearGrid();
  }
  public boolean mouseInGrid() {
    return Utility.isPointInRect(pmouseX, pmouseY, _margin, _top + _margin, _size, _size);
  }
  public Cell cellAt(int x, int y) {
    int cellSize = _size / _cellCount;
    var row = (y - _top - _margin) / cellSize;
    var col = (x - _margin) / cellSize;
    return new Cell(row, col);
  }
  private boolean inGrid(int row, int col) {
    return inBounds(row) && inBounds(col);
  }
  private boolean inBounds(int value) {
    return value >= 0 && value < _cellCount;
  }
  public boolean isPopulated(int row, int col) {
    return inGrid(row, col) && getCellStatus(row, col) == CellStatus.Populated;
  }
  public int getGenerations() {
    return _generations; 
  }
  public CellStatus getCellStatus(int row, int col) {
    return inGrid(row, col) ? _cellStatusGrid[row][col] : CellStatus.Invalid;
  }
  public void setCellStatus(int row, int col, CellStatus cellStatus) {
    if (inGrid(row, col)) {
      _cellStatusGrid[row][col] = cellStatus;
    }
  }
  public void clearGrid() {
    for (int row = 0; row < _cellCount; ++row) {
      for (int col = 0; col < _cellCount; ++col) {
        setCellStatus(row, col, CellStatus.Vacant);
      }
    }
  }
  public void reset() {
    clearGrid();
    _generations = 0;
  }
  private int countNeighbors(int row, int col) {
    int result = 0;
    for (int test_row = row - 1; test_row <= row + 1; ++test_row) {
      for (int test_col = col - 1; test_col <= col + 1; ++test_col) {
        if (test_col == col && test_row == row) continue; // Don't include the target cell
        if (isPopulated(test_row, test_col)) {
          ++result;
        }
      }
    }
    return result;
  }
  public void evolve() {
    ArrayList<Cell> populated = new ArrayList<Cell>();
  
    // Determine which cells will be populated after this generation
    for (int row = 0; row < _cellCount; ++row) {
      for (int col = 0; col < _cellCount; ++col) {
        CellStatus status = getCellStatus(row, col);
        int neighbors = countNeighbors(row, col);
        if (status == CellStatus.Populated && (neighbors == 2 || neighbors == 3)) {
          populated.add(new Cell(row, col));
        } else if (status == CellStatus.Vacant && neighbors == 3) {
          populated.add(new Cell(row,col));
        }
      }  
    }
    // Clear all cells
    clearGrid();
  
    // Mark the grid with the new generation's populated cells
    for (int i = 0; i < populated.size(); ++i) {
      Cell cell = populated.get(i);
      setCellStatus(cell.getRow(), cell.getCol(), CellStatus.Populated);
    }
    ++_generations;
  }
  void insertPattern(Pattern pattern) {
    var cells = pattern.getCells();
    for (int i = 0; i < cells.length; ++i) {
      var cell = cells[i];
      setCellStatus(pattern.getRow() + cell.getRow(), pattern.getCol() + cell.getCol(), CellStatus.Populated);
    }
  }
  void toggleStatus(int row, int col) {
    switch (getCellStatus(row, col)) {
      case Populated:
        setCellStatus(row, col, CellStatus.Vacant);
        break;
      case Vacant:
        setCellStatus(row, col, CellStatus.Populated);
        break;
      default:
        break;
      // Ignore Invalid; no cell should be invalid. The status exists only for something 
      // for getCellStatus() to return if it's called with invalid coordinates.
    }
  }
  public void draw() {
    if (_menu.isOpen()) return;
    
    drawBorder();
    drawCells();
  }
  private void drawBorder() {    
    push();

    int left, top, size;
    left = 0;
    top = _top;
    size = _size + _margin + _margin;

    strokeWeight(0);

    fill(BORDER_COLOR);
    square(left, top, size);    
    
    final int margin = (_margin / 5) * 4;
    left += margin;
    top += margin;
    size -= margin + margin;

    fill(BORDER_LIGHT);
    square(left, top, size);
    
    pop();
  }
  private void drawCells() {
    push();
    stroke(CELL_EDGE_COLOR);
    strokeWeight(1);
    int cellSize = _size / _cellCount;
    for (int row = 0; row < _cellCount; ++row) {
      for (int col = 0; col < _cellCount; ++col) {
        fill(_grid.getCellStatus(row, col) == 
          CellStatus.Populated ? POPULATED_CELL_COLOR : VACANT_CELL_COLOR);
        square(MARGIN + col * cellSize, _top + _margin + row * cellSize, cellSize);
      }
    }
    pop();
  }
}
