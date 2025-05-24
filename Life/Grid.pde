import java.util.List;
import java.util.Arrays;

class Grid {
  private int _cellCount;
  private int _left;
  private int _top;
  private int _size;
  private int _margin;
  private GridTheme _theme;

  private CellStatus[][] _cellStatusGrid;
  private int _generations;

  public Grid(int cellCount, int left, int top, int size, int margin, GridTheme theme) {
    _cellCount = cellCount;
    _left = left;
    _top = top;
    _size = size;
    _margin = margin;
    _theme = theme;

    _cellStatusGrid = new CellStatus[cellCount][cellCount];
    clearGrid();
  }

  public boolean mouseInGrid() {
    return Utility.isPointInRect(pmouseX, pmouseY, _margin, _top + _margin, _size, _size);
  }

  public Cell cellAt(int x, int y) {
    int cellSize = _size / _cellCount;
    var row = (y - _top - _margin) / cellSize;
    var col = (x - _left - _margin) / cellSize;
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
          populated.add(new Cell(row, col));
        }
      }
    }
    setCells(populated);
    ++_generations;
  }

  void insertPattern(Pattern pattern) {
    var cells = pattern.getCells();
    for (int i = 0; i < cells.length; ++i) {
      var cell = cells[i];
      setCellStatus(pattern.getRow() + cell.getRow(), pattern.getCol() + cell.getCol(), CellStatus.Populated);
    }
  }

  void setCells(ArrayList<Cell> cells) {
    // Clear all cells
    clearGrid();

    // Mark the grid with the new populated cells
    for (int i = 0; i < cells.size(); ++i) {
      Cell cell = cells.get(i);
      setCellStatus(cell.getRow(), cell.getCol(), CellStatus.Populated);
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

    fill(_theme.borderTheme.main);
    square(left, top, size);

    final int margin = (_margin / 5) * 4;
    left += margin;
    top += margin;
    size -= margin + margin;

    fill(_theme.borderTheme.highlight);
    square(left, top, size);

    pop();
  }

  private void drawCells() {
    push();
    stroke(_theme.cellTheme.edge);
    strokeWeight(1);
    int cellSize = _size / _cellCount;
    for (int row = 0; row < _cellCount; ++row) {
      for (int col = 0; col < _cellCount; ++col) {
        fill(_grid.getCellStatus(row, col) ==
            CellStatus.Populated ? _theme.cellTheme.populated : _theme.cellTheme.vacant);
        square(MARGIN + col * cellSize, _top + _margin + row * cellSize, cellSize);
      }
    }
    pop();
  }

  public Cell lowerBounds() {
    int lowRow = Integer.MAX_VALUE;
    int lowCol = Integer.MAX_VALUE;
    for (int row = 0; row < _cellCount; ++row) {
      for (int col = 0; col < _cellCount; ++col) {
        if (getCellStatus(row, col) == CellStatus.Populated) {
          if (row < lowRow) lowRow = row;
          if (col < lowCol) lowCol = col;
        }
      }
    }
    return new Cell(lowRow, lowCol);
  }

  public Cell upperBounds() {
    int highRow = 0;
    int highCol = 0;
    for (int row = 0; row < _cellCount; ++row) {
      for (int col = 0; col < _cellCount; ++col) {
        if (getCellStatus(row, col) == CellStatus.Populated) {
          if (row > highRow) highRow = row;
          if (col > highCol) highCol = col;
        }
      }
    }
    return new Cell(highRow, highCol);
  }

  int makeOdd(int n) {
    return (n % 2 == 0) ? n + 1 : n;
  }

  private void rotateGridClockwise() {
    ArrayList<Cell> rotated = new ArrayList<Cell>();

    var upperBounds = upperBounds();

    var lowerBounds = lowerBounds();
    var minRow = lowerBounds.getRow();
    var minCol = lowerBounds.getCol();

    var height = upperBounds.getRow() - minRow + 1;
    var width = upperBounds.getCol() - minCol + 1;

    int size = width > height
        ? makeOdd(width)
        : makeOdd(height);
    minRow -= (size - height) / 2;
    minCol -= (size - width) / 2;

    for (var row = 0; row < size; ++row) {
      for (var col = 0; col < size; ++col) {
        if (getCellStatus(minRow + row, minCol + col) == CellStatus.Populated) {
          rotated.add(new Cell(minRow + col, minCol + (size - 1 - row)));
        }
      }
    }
    setCells(rotated);
  }

  private void rotateGridCounterClockwise() {
    ArrayList<Cell> rotated = new ArrayList<Cell>();

    var upperBounds = upperBounds();

    var lowerBounds = lowerBounds();
    var minRow = lowerBounds.getRow();
    var minCol = lowerBounds.getCol();

    var height = upperBounds.getRow() - minRow + 1;
    var width = upperBounds.getCol() - minCol + 1;

    int size = width > height
        ? makeOdd(width)
        : makeOdd(height);
    minRow -= (size - height) / 2;
    minCol -= (size - width) / 2;

    for (var row = 0; row < size; ++row) {
      for (var col = 0; col < size; ++col) {
        if (getCellStatus(minRow + row, minCol + col) == CellStatus.Populated) {
          rotated.add(new Cell(minRow + (size - 1 - col), minCol + row));
        }
      }
    }
    setCells(rotated);
  }

  private void flipGridHorizontal() {
    ArrayList<Cell> flipped = new ArrayList<Cell>();

    var upperBounds = upperBounds();
    var maxCol = upperBounds.getCol();

    var lowerBounds = lowerBounds();
    var minRow = lowerBounds.getRow();
    var minCol = lowerBounds.getCol();

    var maxRowIndex = upperBounds.getRow() - minRow;

    for (var row = 0; row <= maxRowIndex; ++row) {
      for (var col = minCol; col <= maxCol; ++col) {
        if (getCellStatus(minRow + row, col) == CellStatus.Populated) {
          flipped.add(new Cell(minRow + maxRowIndex - row, col));
        }
      }
    }
    setCells(flipped);
  }

  private void flipGridVertical() {
    ArrayList<Cell> flipped = new ArrayList<Cell>();

    var upperBounds = upperBounds();
    var maxRow = upperBounds.getRow();

    var lowerBounds = lowerBounds();
    var minRow = lowerBounds.getRow();
    var minCol = lowerBounds.getCol();

    var maxColIndex = upperBounds.getCol() - minCol;

    for (var row = minRow; row <= maxRow; ++row) {
      for (var col = 0; col <= maxColIndex; ++col) {
        if (getCellStatus(row, minCol + col) == CellStatus.Populated) {
          flipped.add(new Cell(row, minCol + maxColIndex - col));
        }
      }
    }
    setCells(flipped);
  }

  private void rotateGridUp() {
    var maxRowIndex = _cellCount - 1;

    // Remember the top row statuses
    var topRowStatuses = new CellStatus[_cellCount];
    for (var col = 0; col < _cellCount; ++col) {
      topRowStatuses[col] = getCellStatus(0, col);
    }
    // Shift statuses up
    for (var row = 0; row < maxRowIndex; ++row) {
      for (var col = 0; col < _cellCount; ++col) {
        setCellStatus(row, col, getCellStatus(row + 1, col));
      }
    }
    // Put the top row cells statuses into the bottom row
    for (var col = 0; col < topRowStatuses.length; ++col) {
      setCellStatus(maxRowIndex, col, topRowStatuses[col]);
    }
  }

  private void rotateGridDown() {
    var maxRowIndex = _cellCount - 1;

    // Remember the bottom row statuses
    var bottomRowStatuses = new CellStatus[_cellCount];
    for (var col = 0; col < _cellCount; ++col) {
      bottomRowStatuses[col] = getCellStatus(maxRowIndex, col);
    }
    // Shift statuses down
    for (var row = maxRowIndex - 1; row >= 0; --row) {
      for (var col = 0; col < _cellCount; ++col) {
        setCellStatus(row + 1, col, getCellStatus(row, col));
      }
    }
    // Put the bottom row cells statuses into the top row
    for (var col = 0; col < bottomRowStatuses.length; ++col) {
      setCellStatus(0, col, bottomRowStatuses[col]);
    }
  }

  private void rotateGridLeft() {
    var maxColIndex = _cellCount - 1;

    // Remember the left column statuses
    var leftColumnStatuses = new CellStatus[_cellCount];
    for (var row = 0; row < _cellCount; ++row) {
      leftColumnStatuses[row] = getCellStatus(row, 0);
    }
    // Shift statuses left
    for (var col = 0; col < maxColIndex; ++col) {
      for (var row = 0; row < _cellCount; ++row) {
        setCellStatus(row, col, getCellStatus(row, col + 1));
      }
    }
    // Put the former leftmost row cells statuses into the rightmost row
    for (var row = 0; row < leftColumnStatuses.length; ++row) {
      setCellStatus(row, maxColIndex, leftColumnStatuses[row]);
    }
  }

  private void rotateGridRight() {
    var maxColIndex = _cellCount - 1;

    // Remember the right column statuses
    var rightColumnStatuses = new CellStatus[_cellCount];
    for (var row = 0; row < _cellCount; ++row) {
      rightColumnStatuses[row] = getCellStatus(row, maxColIndex);
    }
    // Shift statuses right
    for (var col = maxColIndex - 1; col >= 0; --col) {
      for (var row = 0; row < _cellCount; ++row) {
        setCellStatus(row, col + 1, getCellStatus(row, col));
      }
    }
    // Put the former rightmost row cells statuses into the leftmost row
    for (var row = 0; row < rightColumnStatuses.length; ++row) {
      setCellStatus(row, 0, rightColumnStatuses[row]);
    }
  }
}
