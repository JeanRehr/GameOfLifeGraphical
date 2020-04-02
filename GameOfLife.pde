/*
 * Aplicacao feita na linguagem Processing(Java) por Jean Rehr.
 * Simula Conway's Game of Life (https://en.wikipedia.org/wiki/Conway's_Game_of_Life).
 */

int col, lin;
int[][] matrix, matrix2;

int width = 700;
int height = 700;
int space;	// Para desenhar o array bidimensional.
int frameRate;	// Velocidade da Animacao.
boolean paused;
boolean bordas = false;

void drawArray(int[][] m) { // Desenha os quadrados na tela.
	for(int i = 0; i < m.length; i++) {
		for(int j = 0; j < m.length; j++) {
			if(m[i][j] == 1)
				fill(255, 255, 255); // quadrados
			else
				fill(0, 0, 0); // celulas

			stroke(125, 125, 125); // linhas
			rect(i * space, j * space, space, space);
		}
	}
}

void execCycle() { // Executa um ciclo.
	int state = 0;
	for(int i = 0; i < matrix.length; i++) {
		for(int j = 0; j < matrix.length; j++) {
			state = matrix[i][j];
			int viz = contaViz(matrix, i, j);
			if(state == 0 && viz == 3) {
				matrix2[i][j] = 1;
			} else if (viz < 2 || viz > 3 && state == 1) {
				matrix2[i][j] = 0;
			} else {
				matrix2[i][j] = state;
			}
		}
	}
	for(int i = 0; i < matrix.length; i++) {
		for(int j = 0; j < matrix.length; j++){
			if(bordas) { // Tecla 'B', nao deixa atravessar as bordas.
				if(i >= matrix.length - 1 || j >= matrix.length - 1)
					matrix2[i][j] = 0;
			}

			matrix[i][j] = matrix2[i][j];
		}
	}
}

int contaViz(int[][] m, int x, int y) { // Conta as celulas adjacentes,
	int viz = 0;                    // Atravessando as bordas.
	for(int i = -1; i < 2; i++) {
		for(int j = -1; j < 2; j++) {
			int col = (x + i + m.length) % m.length;
			int lin = (y + j + m.length) % m.length;
			viz += m[col][lin];
		}
	}

	viz -= m[x][y];
	return viz;
}

void pausedText() {
	fill(255, 0, 0);
	textAlign(CENTER);
	textSize(24);
	text("Paused!", width / 2, 25);
	text("Press Enter to continue, R to Restart.", width / 2, 50);
	text("Press B to not wrap around borders.", width / 2, 75);
	textSize(24);
	text("Seta pra cima: aumenta velocidade.", width / 2, 100);
	text("Seta pra baixo: diminui velocidade.", width / 2, 125);
	text("Z e X e C: presets.", width / 2, 150);
}

void settings() {
	size(width, height); // Tamanho da tela, preferencia que seja divisivel por lin e col.
}

// Events.
void setup() {
	background(0);
	col = 50; // Tamanho
	lin = 50; // do array.
	frameRate = 10;
	paused = true;

	matrix = new int[col][lin];
	matrix2 = new int[col][lin];

	space = min(height, width) / min(col, lin); // Array em todo o espaco da tela.
}

void draw() {
	frameRate(frameRate);
	background(0);
	drawArray(matrix);
	if(!paused) {
		execCycle();
	} else {
		pausedText();
	}
}

void mouseDragged() {
	int selectX = mouseX / space;
	int selectY = mouseY / space;
	if(mouseX < 0)
		mouseX = 0;
	else if(mouseY < 0)
		mouseY = 0;
	else if(mouseX > width)
		mouseX = width;
	else if(mouseY > height)
		mouseY = height;
	else if(matrix[selectX][selectY] == 0)
		matrix[selectX][selectY] = 1;
	else
		matrix[selectX][selectY] = 0;
}

void mouseClicked() {
	int selectX = mouseX / space;
	int selectY = mouseY / space;
	if(matrix[selectX][selectY] == 0)
		matrix[selectX][selectY] = 1;
	else
		matrix[selectX][selectY] = 0;
}

void keyPressed() {
	if(key == CODED && keyCode == UP) // Aumentar e diminuir a velocidade
		frameRate++;
	else if(key == CODED && keyCode == DOWN && frameRate > 1)
		frameRate--;

	if(key == ENTER || key == RETURN) { // Pause
		paused = !paused;
	} else if(key == ESC) { // Exit
		exit();
	} else if(key == CODED && keyCode == 'r' || keyCode == 'R') { // Restart
		for(int i = 0; i < matrix.length; i++) {
			for(int j = 0; j < matrix.length; j++) {
				matrix[i][j] = 0;
			}
		}
		paused = true;
	}

	if(key == CODED && keyCode == 'b' || keyCode == 'B') {
		bordas = !bordas;
	}

	// Presets
	if(key == CODED && keyCode == 'z' || keyCode == 'Z') {
		// Glider
		matrix[2][2] = 1;
		matrix[2][0] = 1;
		matrix[2][1] = 1;
		matrix[1][2] = 1;
		matrix[0][0] = 1;
	}
	if(key == CODED && keyCode == 'x' || keyCode == 'X') {
		// Galaxy
		if(col > 30 && lin > 30) {
			matrix[22][23] = 1; // left
			matrix[24][23] = 1; // right
			matrix[23][22] = 1; // up
			matrix[23][24] = 1; // down
			matrix[21][22] = 1; // up-left
			matrix[20][22] = 1;
			matrix[20][21] = 1;
			matrix[20][20] = 1;
			matrix[21][20] = 1;
			matrix[21][19] = 1;
			matrix[21][18] = 1;
			matrix[22][18] = 1;
			matrix[24][21] = 1; // up-right
			matrix[24][20] = 1;
			matrix[25][20] = 1;
			matrix[26][20] = 1;
			matrix[26][21] = 1;
			matrix[27][21] = 1;
			matrix[27][21] = 1;
			matrix[28][21] = 1;
			matrix[28][22] = 1;
			matrix[25][24] = 1; // down-right
			matrix[26][24] = 1;
			matrix[26][25] = 1;
			matrix[26][26] = 1;
			matrix[25][26] = 1;
			matrix[25][27] = 1;
			matrix[25][28] = 1;
			matrix[24][28] = 1;
			matrix[22][25] = 1; // down-left
			matrix[22][26] = 1;
			matrix[21][26] = 1;
			matrix[20][26] = 1;
			matrix[20][25] = 1;
			matrix[19][25] = 1;
			matrix[18][25] = 1;
			matrix[18][24] = 1;
		} else {
			matrix[7][8] = 1; // left
			matrix[9][8] = 1; // right
			matrix[8][7] = 1; // up
			matrix[8][9] = 1; // down
			matrix[6][7] = 1; // up-left
			matrix[5][7] = 1;
			matrix[5][6] = 1;
			matrix[5][5] = 1;
			matrix[6][5] = 1;
			matrix[6][4] = 1;
			matrix[6][3] = 1;
			matrix[7][3] = 1;
			matrix[9][6] = 1; // up-right
			matrix[9][5] = 1;
			matrix[10][5] = 1;
			matrix[11][5] = 1;
			matrix[11][6] = 1;
			matrix[12][6] = 1;
			matrix[12][6] = 1;
			matrix[13][6] = 1;
			matrix[13][7] = 1;
			matrix[10][9] = 1; // down-right
			matrix[11][9] = 1;
			matrix[11][10] = 1;
			matrix[11][11] = 1;
			matrix[10][11] = 1;
			matrix[10][12] = 1;
			matrix[10][13] = 1;
			matrix[9][13] = 1;
			matrix[7][10] = 1; // down-left
			matrix[7][11] = 1;
			matrix[6][11] = 1;
			matrix[5][11] = 1;
			matrix[5][10] = 1;
			matrix[4][10] = 1;
			matrix[3][10] = 1;
			matrix[3][9] = 1; // 18 - 3
		}
	}
	if(key == CODED && keyCode == 'c' || keyCode == 'C') {
		// Glider-gun
		if(col > 39 && lin > 12) {
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
