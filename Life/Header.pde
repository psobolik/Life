public class Header {
    private final int BUTTON_TOP = 5;
    private final int BUTTON_WIDTH = 30;
    private final int BUTTON_HEIGHT = 30;

    private final static int MARGIN = 7;
    private final static int GAP = 2;

    private final int MENU_BUTTON_LEFT = MARGIN;
    private final int PLAY_BUTTON_LEFT = MENU_BUTTON_LEFT + BUTTON_WIDTH + MARGIN;
    private final int STEP_BUTTON_LEFT = PLAY_BUTTON_LEFT + BUTTON_WIDTH;

    private final color BACKGROUND_COLOR = #404040;
    private final color TEXT_COLOR = #ffffff;

    private final color BUTTON_ICON_COLOR = #cccccc;
    private final color BUTTON_FILL_COLOR = BACKGROUND_COLOR;
    private final color BUTTON_STROKE_COLOR = #efefef;

    private final color BUTTON_HOVER_ICON_COLOR = #c0c070;
    private final color BUTTON_HOVER_FILL_COLOR = #666640;
    private final color BUTTON_HOVER_STROKE_COLOR = #000000;
    
    private int _width;
    private int _height;

    public Header(int width, int height) {
        _width = width;
        _height = height;
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
        fill(BACKGROUND_COLOR);
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
            stroke(BUTTON_HOVER_STROKE_COLOR);
            fill(BUTTON_HOVER_FILL_COLOR);
        } else { 
            stroke(BUTTON_STROKE_COLOR);
            fill(BUTTON_FILL_COLOR);
        }
        rect(MENU_BUTTON_LEFT, BUTTON_TOP, BUTTON_WIDTH, BUTTON_HEIGHT);
        
        if (hover) {
            fill(BUTTON_HOVER_ICON_COLOR);
        } else {
            fill(BUTTON_ICON_COLOR);
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
            stroke(BUTTON_HOVER_STROKE_COLOR);
            fill(BUTTON_HOVER_FILL_COLOR);
        } else { 
            stroke(BUTTON_STROKE_COLOR);
            fill(BUTTON_FILL_COLOR);
        }
        rect(PLAY_BUTTON_LEFT, BUTTON_TOP, BUTTON_WIDTH, BUTTON_HEIGHT);
        
        if (hover) {
            fill(BUTTON_HOVER_ICON_COLOR);
        } else {
            fill(BUTTON_ICON_COLOR);
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
            stroke(BUTTON_HOVER_STROKE_COLOR);
            fill(BUTTON_HOVER_FILL_COLOR);
        } else { 
            stroke(BUTTON_STROKE_COLOR);
            fill(BUTTON_FILL_COLOR);
        }
        rect(STEP_BUTTON_LEFT, BUTTON_TOP, BUTTON_WIDTH, BUTTON_HEIGHT);
        
        if (hover) {
            fill(BUTTON_HOVER_ICON_COLOR);
        } else {
            fill(BUTTON_ICON_COLOR);
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
        fill(TEXT_COLOR);
        var s = String.format("%,d generations",  generations);
        textSize(18);
        textAlign(CENTER, CENTER);
        text(s, 0, 0, _width - MARGIN -  MARGIN, _height);
        pop();
    }
    private void drawDelayText(int delay) {
        push();
        fill(TEXT_COLOR);
        String s = String.format("↑↓Delay: %s", delay);
        textSize(18);
        textAlign(RIGHT, CENTER);
        text(s, 0, 0, _width - MARGIN -  MARGIN, _height);
        pop();
    }
}