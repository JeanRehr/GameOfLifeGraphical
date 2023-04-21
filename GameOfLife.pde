/*
* Made by Jean Rehr with help from the coding train.
* Conway's Game of Life (https://en.wikipedia.org/wiki/Conway's_Game_of_Life).
*/

int col = 100; // 2d array
int lin = 100;
int[][] matrix, matrix2;
int width = 1000;
int height = 1000;
int space;  // to draw 2d array
int frameRate;
boolean paused;
boolean borders = false;

void settings() {
    size(width, height); // screen size, should be divisible by col and line.
}

void setup() {
    background(0);
    frameRate = 20;
    paused = true;
    
    matrix = new int[col][lin];
    matrix2 = new int[col][lin];
    
    space = min(height, width) / min(col, lin); // to draw array in all screen
}

void draw() {
    frameRate(frameRate);
    background(0);
    drawArray(matrix);
    if (borders) { // draws a line if borders is active
        stroke(0, 255, 0);
        line(space / 2, space / 2, width - space / 2, space / 2);
        line(width - space / 2, space / 2, width - space / 2, height - space / 2);
        line(width - space / 2, height - space / 2, space / 2, height - space / 2);
        line(space / 2, space / 2, space / 2, height - space / 2);
    } 
    if (!paused) {
        execCycle(matrix, matrix2);
    } else {
        pausedText();
    }
}

void drawArray(int[][] m) {
    for (int i = 0; i < m.length; i++) {
        for (int j = 0; j < m.length; j++) {
            if (m[i][j] == 1) {
                fill(255, 255, 255); // rects
            } else {
                fill(0, 0, 0); // cells
            }

            stroke(125, 125, 125); // lines
            rect(i * space, j * space, space, space);
        }
    }
}

int countNeigh(int[][]m, int x, int y) { // counts each adjacent cell
    int neighbours = 0;                         // through the borders
    for (int i = -1; i < 2; i++) {
        for (int j = -1; j < 2; j++) {
            int col = (x + i + m.length) % m.length;
            int lin = (y + j + m.length) % m.length;
            neighbours += m[col][lin];
        }
    }
    
    neighbours -= m[x][y];
    return neighbours;
}

void execCycle(int[][] m, int[][] m2) {
    //int state;
    for (int i = 0; i < m.length; i++) {
        for (int j = 0; j < m.length; j++) {
            //state = m[i][j]; // stores the state of each cell
            if (m[i][j] == 0 && countNeigh(m, i, j) == 3) { // reproduction
                m2[i][j] = 1;
            } else if (countNeigh(m, i, j) < 2 || countNeigh(m, i, j) > 3 && m[i][j] == 1) { // overpopulation
                m2[i][j] = 0;
            } else {
                m2[i][j] = m[i][j]; // stays as is
            }
            
            if (borders) { // 'b', doesn't let go through the borders
                if (i >= m.length - 1 || j >= m.length - 1) {
                     m2[i][j] = 0;
                }
            }
        }
    }
    for (int i = 0; i < m.length; i++) {
        for (int j = 0; j < m.length; j++) {
            m[i][j] = m2[i][j]; // transfer the state from a matrix to another
        }
    }
}

void pausedText() {
    fill(0 , 255, 0);
    textAlign(CENTER);
    textSize(24);
    text("Paused!", width / 2, 25);
    text("Press Enter to continue, R to Restart.", width / 2, 50);
    text("Press B to not wrap around borders.", width / 2, 75);
    textSize(24);
    text("Up arrow: faster.", width / 2, 100);
    text("Down arrow: slower.", width / 2, 125);
    text("Left mouse button create, right button destroy.", width / 2, 150);
    text("Z, X, C: presets.", width / 2, 175);
}

// user input
void mouseDragged() {
    int selectX = mouseX / space;
    int selectY = mouseY / space;
    try { // array out of bounds if dragging past window border
        if (mouseX < 0) {
            mouseX = 0;
        } else if (mouseY < 0) {
            mouseY = 0;
        } else if (mouseX > width) {
            mouseX = width;
        } else if (mouseY > height) {
            mouseY = height;
        } else if (matrix[selectX][selectY] == 0 && mouseButton == LEFT) {
            matrix[selectX][selectY] = 1;
        } else if (matrix[selectX][selectY] == 1 && mouseButton == RIGHT) {
            matrix[selectX][selectY] = 0;
        }
    } catch(ArrayIndexOutOfBoundsException e) {
        e.printStackTrace();
    }
}

void mousePressed() {
    int selectX = mouseX / space;
    int selectY = mouseY / space;
    if (matrix[selectX][selectY] == 0 && mouseButton == LEFT) {
        matrix[selectX][selectY] = 1;
    } else if (matrix[selectX][selectY] == 1 && mouseButton == RIGHT) {
        matrix[selectX][selectY] = 0;
    }
}

void keyPressed() {
    if (key == CODED && keyCode == UP) {
        frameRate++;
    } else if (key == CODED && keyCode == DOWN && frameRate > 1) {
        frameRate--;
    }
    
    if (key == ENTER || key == RETURN) { // Pause
        paused = !paused;
    }
    
    if (key == ESC) { // Exit
        exit();
    }
    
    if (key == CODED && keyCode == 'r' || keyCode == 'R') { // Restart
        for (int i = 0; i < matrix.length; i++) {
            for (int j = 0; j < matrix.length; j++) {
                matrix[i][j] = 0;
            }
        }
        paused = true;
    }
    
    if (key == CODED && keyCode == 'b' || keyCode == 'B') {
        borders = !borders;
    }
    
    //Presets
    if (key == CODED && keyCode == 'z' || keyCode == 'Z') {
        // Glider
        matrix[2][2] = 1;
        matrix[2][0] = 1;
        matrix[2][1] = 1;
        matrix[1][2] = 1;
        matrix[0][0] = 1;
    }
    
    if (key == CODED && keyCode == 'x' || keyCode == 'X') {
        // Galaxy
        if (col > 30 && lin > 30) {
            matrix[col / 2][lin / 2 - 1] = 1;
            matrix[col / 2 + 1][lin / 2] = 1;
            matrix[col / 2][lin / 2 + 1] = 1;
            matrix[col / 2 - 1][lin / 2] = 1;
            matrix[col / 2 + 1][lin / 2 - 2] = 1; // top right
            matrix[col / 2 + 1][lin / 2 - 3] = 1;
            matrix[col / 2 + 2][lin / 2 - 3] = 1;
            matrix[col / 2 + 3][lin / 2 - 3] = 1;
            matrix[col / 2 + 3][lin / 2 - 2] = 1;
            matrix[col / 2 + 4][lin / 2 - 2] = 1;
            matrix[col / 2 + 5][lin / 2 - 2] = 1;
            matrix[col / 2 + 5][lin / 2 - 1] = 1;
            matrix[col / 2 + 2][lin / 2 + 1] = 1; // bottom right
            matrix[col / 2 + 3][lin / 2 + 1] = 1;
            matrix[col / 2 + 3][lin / 2 + 2] = 1;
            matrix[col / 2 + 3][lin / 2 + 3] = 1;
            matrix[col / 2 + 2][lin / 2 + 3] = 1;
            matrix[col / 2 + 2][lin / 2 + 4] = 1;
            matrix[col / 2 + 2][lin / 2 + 5] = 1;
            matrix[col / 2 + 1][lin / 2 + 5] = 1;
            matrix[col / 2 - 1][lin / 2 + 2] = 1; // bottom left
            matrix[col / 2 - 1][lin / 2 + 3] = 1;
            matrix[col / 2 - 2][lin / 2 + 3] = 1;
            matrix[col / 2 - 3][lin / 2 + 3] = 1;
            matrix[col / 2 - 3][lin / 2 + 2] = 1;
            matrix[col / 2 - 4][lin / 2 + 2] = 1;
            matrix[col / 2 - 5][lin / 2 + 2] = 1;
            matrix[col / 2 - 5][lin / 2 + 1] = 1;
            matrix[col / 2 - 2][lin / 2 - 1] = 1; // top left
            matrix[col / 2 - 3][lin / 2 - 1] = 1;
            matrix[col / 2 - 3][lin / 2 - 2] = 1;
            matrix[col / 2 - 3][lin / 2 - 3] = 1;
            matrix[col / 2 - 2][lin / 2 - 3] = 1;
            matrix[col / 2 - 2][lin / 2 - 4] = 1;
            matrix[col / 2 - 2][lin / 2 - 5] = 1;
            matrix[col / 2 - 1][lin / 2 - 5] = 1;
        }
    }
    
    if (key == CODED && keyCode == 'c' || keyCode == 'C') {
        // Glider-gun
        if (col > 39 && lin > 12) {
            matrix[3][6] = 1; // quadrado inicial
            matrix[3][7] = 1;
            matrix[2][6] = 1;
            matrix[2][7] = 1; // segundo obj
            matrix[12][6] = 1;
            matrix[12][7] = 1;
            matrix[12][8] = 1;
            matrix[13][9] = 1;
            matrix[14][10] = 1;
            matrix[15][10] = 1;
            matrix[13][5] = 1;
            matrix[14][4] = 1;
            matrix[15][4] = 1;
            matrix[17][5] = 1;
            matrix[18][6] = 1;
            matrix[19][7] = 1;
            matrix[18][7] = 1;
            matrix[18][8] = 1;
            matrix[16][7] = 1;
            matrix[17][9] = 1;
            matrix[22][6] = 1; // terceiro obj
            matrix[22][5] = 1;
            matrix[22][4] = 1;
            matrix[23][4] = 1;
            matrix[23][5] = 1;
            matrix[23][6] = 1;
            matrix[24][7] = 1;
            matrix[24][3] = 1;
            matrix[26][3] = 1;
            matrix[26][2] = 1;
            matrix[26][7] = 1;
            matrix[26][8] = 1;
            matrix[36][4] = 1; // segundo quadrado
            matrix[36][5] = 1;
            matrix[37][5] = 1;
            matrix[37][4] = 1;
        }
    }
}
