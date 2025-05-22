**An implementation of Conway's Game of Life in Processing.**

May 2025

There are some actions that can only be performed by pressing keys.

| Action                        | Key         | Menu | Button |
|-------------------------------|-------------|------|--------|
| Play/pause                    | Spacebar    |      | yes    |
| Single step                   | .           |      | yes    |
| Insert pattern from file      | Ctrl+O      | yes  |        |
| Insert random pattern         | R           | yes  |        |
| Clear grid                    | C           | yes  |        |
| Quit                          | Ctrl+Q      | yes  |        |
| Shift grid up                 | Up arrow    |      |        |
| Shift grid down               | Down arrow  |      |        |
| Shift grid left               | Left arrow  |      |        |
| Shift grid right              | Right arrow |      |        |
| Rotate grid clockwise         | F1          |      |        |
| Rotate grid counter-clockwise | F2          |      |        |
| Flip grid horizontal          | F3          |      |        |
| Flip grid vertical            | F4          |      |        |
| Increment delay               | +           |      |        |
| Decrement delay               | -           |      |        |


**TODO:**

I've already worked on this more than it deserves, but here are some  enhancements it could use:

- Add buttons for hidden actions. 
    - Shift grid up
    - Shift grid down
    - Shift grid left
    - Shift grid right
    - Rotate grid clockwise
    - Rotate grid counter-clockwise
    - Flip grid horizontal
    - Flip grid vertical
    - Increment delay
    - Decrement delay

In order to make room for all these buttons, I'd probably add a footer to the screen and move the Play/Pause and Step buttons to it as well.

- Reach goals
    - Add hovertext to the buttons
    - Enable navigating the menu with keys