public class Header {
    private final int BUTTON_TOP = 5;
    private final int BUTTON_WIDTH = 30;
    private final int BUTTON_HEIGHT = 30;

    private final static int MARGIN = 7;
    private final static int GAP = 2;

    private final int MENU_BUTTON_LEFT = MARGIN;
    private final int PLAY_BUTTON_LEFT = MENU_BUTTON_LEFT + BUTTON_WIDTH + MARGIN;
    private final int STEP_BUTTON_LEFT = PLAY_BUTTON_LEFT + BUTTON_WIDTH;

    private int _width;
    private int _height;
    private HeaderTheme _headerTheme;
    private HoverButtonTheme _buttonTheme;

    public Header(int width, int height, HeaderTheme headerTheme, HoverButtonTheme buttonTheme) {
        _width = width;
        _height = height;
        _headerTheme = headerTheme;
        _buttonTheme = buttonTheme;
    }

    public int getButtonBottom() { return BUTTON_TOP + BUTTON_HEIGHT; }
    public int getButtonLeft() { return MENU_BUTTON_LEFT; }

    public ButtonAction getButtonAction(int x, int y) {
        return mouseIsOverMenuButton() ? ButtonAction.Menu
            : mouseIsOverPlayButton() ? ButtonAction.PlayPause
            : mouseIsOverStepButton() ? ButtonAction.Step
            : ButtonAction.None;
            
    }

    private boolean mouseIsOverPlayButton() {
        return Utility.isPointInRect(pmouseX, pmouseY, PLAY_BUTTON_LEFT, BUTTON_TOP, BUTTON_WIDTH, BUTTON_HEIGHT);
    }

    private boolean mouseIsOverStepButton() {
        return Utility.isPointInRect(pmouseX, pmouseY, STEP_BUTTON_LEFT, BUTTON_TOP, BUTTON_WIDTH, BUTTON_HEIGHT);
    }

    private boolean mouseIsOverMenuButton() {
        return Utility.isPointInRect(pmouseX, pmouseY, MENU_BUTTON_LEFT, BUTTON_TOP, BUTTON_WIDTH, BUTTON_HEIGHT);
    }

    public void draw(boolean isRunning, int generations, int delay) {
        push();
        fill(_headerTheme.background);
        strokeWeight(0);
        rect(0, 0, _width, _height);
        drawMenuButton();
        drawPlayButton(isRunning);
        drawStepButton();
        drawGenerationsText(generations);
        drawDelayText(delay);
        pop();
    }

    private void drawMenuButton() {
        push();
        strokeWeight(0);
        
        var hover = mouseIsOverMenuButton();
        if (hover) {
            // hover
            stroke(_buttonTheme.hover.stroke);
            fill(_buttonTheme.hover.fill);
        } else { 
            stroke(_buttonTheme.normal.stroke);
            fill(_buttonTheme.normal.fill);
        }
        rect(MENU_BUTTON_LEFT, BUTTON_TOP, BUTTON_WIDTH, BUTTON_HEIGHT);
        
        if (hover) {
            fill(_buttonTheme.hover.icon);
        } else {
            fill(_buttonTheme.normal.icon);
        }
        
        var left = MENU_BUTTON_LEFT + MARGIN;
        var top = BUTTON_TOP + MARGIN;
        var width = BUTTON_WIDTH - MARGIN - MARGIN;
        var height = 4;
        
        rect(left, top, width, height);
        top += height + GAP;
        rect(left, top, width, height);
        top += height + GAP;
        rect(left, top, width, height);
        pop();
    }

    private void drawPlayButton(boolean isRunning) {
        push();
        strokeWeight(0);

        var hover = mouseIsOverPlayButton();
        if (hover) {
            // hover
            stroke(_buttonTheme.hover.stroke);
            fill(_buttonTheme.hover.fill);
        } else { 
            stroke(_buttonTheme.normal.stroke);
            fill(_buttonTheme.normal.fill);
        }
        rect(PLAY_BUTTON_LEFT, BUTTON_TOP, BUTTON_WIDTH, BUTTON_HEIGHT);
        
        if (hover) {
            fill(_buttonTheme.hover.icon);
        } else {
            fill(_buttonTheme.normal.icon);
        }
        
        if (isRunning) {
            // Pause icon
            final int bar_height = BUTTON_HEIGHT - MARGIN - MARGIN;
            final int bar_width = BUTTON_WIDTH / 6;
            final int bar_gap = (bar_width / 4) * 3;
            int l = PLAY_BUTTON_LEFT + MARGIN;
            int t = BUTTON_TOP + MARGIN;
            rect(l, t, bar_width, bar_height);
            rect(l + bar_width + bar_gap, t, bar_width, bar_height);
        } else {
            // Play icon
            triangle(
                PLAY_BUTTON_LEFT + MARGIN, 
                BUTTON_TOP + MARGIN, 
                PLAY_BUTTON_LEFT + MARGIN, 
                BUTTON_TOP + BUTTON_HEIGHT - MARGIN, 
                PLAY_BUTTON_LEFT + BUTTON_WIDTH - MARGIN, 
                BUTTON_TOP + (BUTTON_HEIGHT / 2)
            );
        } 
        
        pop();
    }

    private void drawStepButton() {
        push();
        strokeWeight(0);

        var hover = mouseIsOverStepButton();
        if (hover) {
            // hover
            stroke(_buttonTheme.hover.stroke);
            fill(_buttonTheme.hover.fill);
        } else { 
            stroke(_buttonTheme.normal.stroke);
            fill(_buttonTheme.normal.fill);
        }
        rect(STEP_BUTTON_LEFT, BUTTON_TOP, BUTTON_WIDTH, BUTTON_HEIGHT);
        
        if (hover) {
            fill(_buttonTheme.hover.icon);
        } else {
            fill(_buttonTheme.normal.icon);
        }
        
        int left, top, width, height;

        top = BUTTON_TOP + MARGIN;
        left = STEP_BUTTON_LEFT + MARGIN;
        height = BUTTON_HEIGHT - MARGIN - MARGIN;
        width = 4;

        rect(left, top, width, height);
        left += width + 2;
        triangle(
            left, top,
            left, top + height,
            STEP_BUTTON_LEFT + BUTTON_WIDTH - MARGIN, BUTTON_TOP + (BUTTON_HEIGHT / 2)
        );
        pop();
    }

    private void drawGenerationsText(int generations) {
        push();
        fill(_headerTheme.text);
        var s = String.format("%,d generations",  generations);
        textSize(18);
        textAlign(CENTER, CENTER);
        text(s, 0, 0, _width - MARGIN -  MARGIN, _height);
        pop();
    }

    private void drawDelayText(int delay) {
        push();
        fill(_headerTheme.text);
        String s = String.format("↑↓Delay: %s", delay);
        textSize(18);
        textAlign(RIGHT, CENTER);
        text(s, 0, 0, _width - MARGIN -  MARGIN, _height);
        pop();
    }
}