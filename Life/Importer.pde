public class Importer {
    public Pattern importPattern(File file) {
        if (file.getName().endsWith(".cells")) {
            return importCellsFile(file);
        } else {
            return importRleFile(file);
        }
    }
    private Pattern importCellsFile(File file) {
        var cells = new ArrayList<Cell>();
        var metadata = new ArrayList<String>();

        String line = null;
        int row = -1;

        var reader = createReader(file);
        try {
            while ((line = reader.readLine()) != null) {
                if (line.startsWith("!")) {
                    metadata.add(line);
                } else {
                    cells.addAll(parseLine(line, row));
                    ++row;
                }
            }
            reader.close();
        } catch (IOException e) {
            e.printStackTrace();
        }
        return createPattern(metadata, cells);
    }
    private ArrayList<Cell> parseLine(String line, int row) {
        var activeCells = new ArrayList<Cell>();
        for(int col = 0; col < line.length(); ++col) {
            if (line.charAt(col) != '.') {
                activeCells.add(new Cell(row, col));
            }
        };
        return activeCells;
    }
    private Pattern importRleFile(File file) {
        var cells = new ArrayList<Cell>();
        var metadata = new ArrayList<String>();

        String line = null;
        int row = -1;
        int col = 0;
        int count = 0;

        var reader = createReader(file);
        try {
            while ((line = reader.readLine()) != null) {
                if (line.startsWith("#")) {
                    metadata.add(line);
                } else if (row < 0) {
                    // The first line that doesn't start with "#" is the header, 
                    // which we will also add to the metadata
                    metadata.add(line);
                    row = 0;
                } else for (char c: line.toLowerCase().toCharArray()) {
                    if (c == '!') break;
                    else if (Character.isDigit(c)) {
                        count = (count * 10) + Character.getNumericValue(c);
                    } else if (c == 'o' || c == 'x' || c == 'y' || c == 'z') {
                        if (count == 0) {
                            cells.add(new Cell(row, col));
                            ++col;
                        } else while (count > 0) {
                            cells.add(new Cell(row, col));
                            ++col;
                            --count;
                        }
                    } else if (c == 'b') {
                        if (count == 0) {
                        ++col;
                        } else  {
                        col += count;
                        count = 0;
                        }
                    } else if (c == '$') { // End of row
                        if (count == 0) {
                            ++row;
                        } else  {
                            row += count;
                            count = 0;
                        }
                        col = 0;
                    }
                }
            }
            reader.close();
        } catch (IOException e) {
            e.printStackTrace();
        }
        return createPattern(metadata, cells);
    }
    private Pattern createPattern(ArrayList<String> metadata, ArrayList<Cell> cells) {
        var cellArray = new Cell[cells.size()];
        var metadataArray = new String[metadata.size()];
        return new Pattern(metadata.toArray(metadataArray), cells.toArray(cellArray), 0, 0);
    }
}
