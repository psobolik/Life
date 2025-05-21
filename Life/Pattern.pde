public class Pattern {
    private int _row;
    private int _col;
    private String[] _metadata;
    private Cell[] _cells;

    public Pattern(String[] metadata, Cell[] cells, int row, int col) {
        _metadata = metadata;
        _cells = cells;
        _row = row;
        _col = col;
    }

    public String[] getMetadata() { return _metadata; }
    public Cell[] getCells() { return _cells; }
    public int getRow() { return _row; }
    public void setRow(int row) { _row = row; }
    public int getCol() { return _col; }
    public void setCol(int col) { _col = col; }

    public String getName() { 
        // Fallback name if there's no metadata
        var name = "???";
        if (_metadata.length > 0) {
            // Fallback to first metadata line if no proper name metadata line
            var firstLine = _metadata[0];
            if (firstLine.startsWith("!") || firstLine.startsWith("#")) {
                name = firstLine.substring(1).trim();
            }
            // Search for name metadata line
            for (String line: _metadata) {
                if (line.startsWith("!Name:")) {
                    name = line.substring(6).trim();
                    break;
                }
                if (line.startsWith("#N")) {
                    name = line.substring(2).trim();
                    break;
                }
            }
        }
        return name;
    }

    // The coordinates of the "Cell" returned are actually 
    // the height and width of the Pattern
    public Cell getDimensions() {
        int row = 0;
        int col = 0;
        for (Cell cell: _cells) {
            if (cell.getRow() > row) row = cell.getRow();
            if (cell.getCol() > col) col = cell.getCol();
        }
        return new Cell(row, col);
    }
}
