#include <stdio.h>
#include <stdlib.h>


#define WIDTH 100
#define HEIGHT 100
#define PIXEL_DEPTH 15
#define MAX_COMMANDS 100

#define DRAW_LINE 0
#define DRAW_SQUARE 1
#define DRAW_SQUAREFILLED 2
#define DRAW_CIRCLE 3
#define DRAW_ARROW 4
#define DRAW_TRIANGLE 5
#define DRAW_TRIANGLERECT 6
#define DRAW_Pack 7
#define CLEAR_BUFFER 8
#define END_CMD 100

int imagem[WIDTH * HEIGHT];
int comandos[MAX_COMMANDS];

void salvar_imagem(char* nome) {
    int i;
    int r;
    int g;
    int b;
    FILE* arquivo;

    arquivo = fopen(nome, "w");

    if (arquivo == NULL) {
        printf("Erro ao abrir o arquivo %s para escrita\n", nome);
        exit(0);
    }

    /* Cabecalho... */
    fprintf(arquivo, "P3\n%i %i\n%i\n", WIDTH, HEIGHT, PIXEL_DEPTH);

    /* Pixels... */
    for (i = 0; i < WIDTH * HEIGHT; ++i) {
        r = (imagem[i] & 0x0f00) >> 8;
        g = (imagem[i] & 0x00f0) >> 4;
        b = (imagem[i] & 0x000f);
        fprintf(arquivo, "%i %i %i\n", r, g, b);
    }

    fclose(arquivo);
}

void set_pixel(int col, int row, int pixel) {
    imagem[row * WIDTH + col] = pixel;
}

int abs(int n) {
    if (n < 0) {
        return -n;
    }

    return n;
}

void line(int x0, int y0, int x1, int y1, int pixel) {
    int dx;
    int dy;
    int sx;
    int sy;
    int err;
    int e2;

    dx = abs(x1-x0);
    dy = abs(y1-y0);

    sx = x0<x1 ? 1 : -1;
    sy = y0<y1 ? 1 : -1;
    err = (dx > dy ? dx : -dy) / 2;

    while (1) {
        set_pixel(x0, y0, pixel);

        if (x0==x1 && y0==y1) break;
        e2 = err;

        if (e2 >-dx) {
            err -= dy; x0 += sx;
        }

        if (e2 < dy) {
            err += dx; y0 += sy;
        }
    }
}
void Triangle(int x,int y,int h, int pixel)
{
    line(x-h, y, x, y-h, pixel);
    line(x+h, y, x, y-h, pixel);
    line(x-h, y, x+h, y, pixel);
}

void TriangleRect(int x,int y,int h, int pixel)
{
    line(x+h, y-h, x, y, pixel);
    line(x+h, y, x+h, y-h, pixel);
    line(x, y, x+h, y, pixel);
}

void circle(int x,int y,int raio, int pixel)
{
    float n=0,invraio=1/(float)raio;
    int dx=0,dy=raio-1;

    while (dx<=dy)
    {
        line(x+dy, y-dx, x+dy, y-dx, pixel); // 1o
        line(x+dx,y-dy,x+dx,y-dy,pixel);  // 2o
        line(x-dx,y-dy,x-dx,y-dy,pixel);  // 3o
        line(x-dy,y-dx,x-dy,y-dx,pixel);  // 4o
        line(x-dy,y+dx,x-dy,y+dx,pixel);  // 5o
        line(x-dx,y+dy,x-dx,y+dy,pixel);  // 6o
        line(x+dx,y+dy,x+dx,y+dy,pixel);  // 7o
        line(x+dy,y+dx,x+dy,y+dx,pixel);  // 8o
        dx++;
        n+=invraio;
        dy=raio * sin(acos(n));
    }
}

void circlePAck(int x,int y,int raio, int pixel)
{
    float n=0,invraio=1/(float)raio;
    int dx=0,dy=raio-1;

    while (dx<=dy)
    {
        line(x+dy, y-dx, x+dy, y-dx, pixel);

        line(x+dx,y-dy,x+dx,y-dy,pixel);  // 2o
        line(x-dx,y-dy,x-dx,y-dy,pixel);  // 3o
        line(x-dy,y-dx,x-dy,y-dx,pixel);  // 4o
        line(x-dy,y+dx,x-dy,y+dx,pixel);  // 5o
        line(x-dx,y+dy,x-dx,y+dy,pixel);  // 6o
        line(x+dx,y+dy,x+dx,y+dy,pixel);  // 7o
        dx++;
        n+=invraio;
        dy=raio * sin(acos(n));
    }
}

void square(int col, int row, int size, int pixel) {
    line(col, row, col + size, row, pixel);
    line(col + size, row, col + size, row + size, pixel);
    line(col + size, row + size, col, row + size, pixel);
    line(col, row + size, col, row, pixel);
}

void squareFilled(int col,int row,int size, int pixel)
{
    int a = 0;
    for(;a<=size;a++)
        line(col, row+a, col + size, row+a, pixel);

}

void arrow(int x0, int y0, int x1, int y1, int pixel) // 15 15 70 70  cor
{
    line(x0, y0, x1, y1, pixel);
    line(x0,y0,x0,y0-10,0x00F);
    line(x0,y0,x0-10,y0,0x00F);
    line(x0+5, y0+5, x0+5,y0-5,0x00F);
    line(x0+5, y0+5, x0-5, y0+5, 0x00F);
    line(x0+10, y0+10, x0+10, y0, 0x00F);
    line(x0+10, y0+10, x0, y0+10, 0x00F);
    line(x0+15,y0+15, x0+15,y0+5, 0x00F);
    line(x0+15,y0+15,x0+5,y0+15,0x00F);
    TriangleRect(x1-7,x1+8,15,0xF00);
    circle(x1+3,y1+3,15, 0x0F0);

}
void Pack(int x,int y,int raio, int pixel)
{
    int aux;
    for(aux = 0;aux<=raio;aux ++)
    {
        circlePAck(x, y, aux, 0xFF0);
    }
    for(aux = 7;aux>=0;aux--)
    {
        circle(60,30,aux,0xFFF);
        circle(80,64, aux,0x00F);
    }


}
void clear_buffer(int pixel) {
    int i;

    for (i = 0; i < WIDTH * HEIGHT; ++i) {
        imagem[i] = pixel;
    }
}

void processar_comandos() {
    int i;
    int cmd;
    int op1;
    int op2;
    int op3;
    int op4;
    int op5;
    int op6;
    int op7;

    i = 0;

    while (i < MAX_COMMANDS) {
        cmd = comandos[i];

        switch (cmd) {
        case DRAW_LINE:
            op1 = comandos[i + 1]; // x0
            op2 = comandos[i + 2]; // y0
            op3 = comandos[i + 3]; // x1
            op4 = comandos[i + 4]; // y1
            op5 = comandos[i + 5]; // cor
            line(op1, op2, op3, op4, op5);
            i = i + 6; // ir para proximo comando
            break;


       case DRAW_ARROW:
            op1 = comandos[i + 1]; // x0
            op2 = comandos[i + 2]; // y0
            op3 = comandos[i + 3]; // x1
            op4 = comandos[i + 4]; // y1
            op5 = comandos[i + 5]; // cor
            arrow(op1, op2, op3, op4, op5);
            i = i + 6; // ir para proximo comando
            break;

        case DRAW_SQUARE:
            op1 = comandos[i + 1]; // x
            op2 = comandos[i + 2]; // y
            op3 = comandos[i + 3]; // tamanho
            op4 = comandos[i + 4]; // cor
            square(op1, op2, 5, op4);
            i = i + 5; // ir para proximo comando
            break;


       case DRAW_CIRCLE:
            op1 = comandos[i + 1]; // x
            op2 = comandos[i + 2]; // y
            op3 = comandos[i + 3]; // raio
            op4 = comandos[i + 4]; // cor
            circle(op1, op2, op3, op4);
            i = i + 5; // ir para proximo comando
            break;

         case DRAW_Pack:
            op1 = comandos[i + 1]; // x
            op2 = comandos[i + 2]; // y
            op3 = comandos[i + 3]; // raio
            op4 = comandos[i + 4]; // cor
            Pack(op1, op2, op3, op4);
            i = i + 5; // ir para proximo comando
            break;

        case DRAW_TRIANGLE:
            op1 = comandos[i + 1]; // x
            op2 = comandos[i + 2]; // y
            op3 = comandos[i + 3]; //
            op4 = comandos[i + 4]; // cor
            Triangle(op1, op2, op3, op4);
            i = i + 5; // ir para proximo comando
            break;

        case DRAW_TRIANGLERECT:
            op1 = comandos[i + 1]; // x
            op2 = comandos[i + 2]; // y
            op3 = comandos[i + 3]; //
            op4 = comandos[i + 4]; // cor
            TriangleRect(op1, op2, op3, op4);
            i = i + 5; // ir para proximo comando
            break;

        case DRAW_SQUAREFILLED:
            op1 = comandos[i + 1]; // x
            op2 = comandos[i + 2]; // y
            op3 = comandos[i + 3]; // tamanho
            op4 = comandos[i + 4]; // cor
            squareFilled(op1, op2, op3, op4);
            i = i + 5; // ir para proximo comando
            break;

        case CLEAR_BUFFER:
            op1 = comandos[i + 1]; // pixel
            clear_buffer(op1);
            i = i + 2;
            break;

        case END_CMD:
            i = MAX_COMMANDS; // n ha mais comandos a ser executado, sai do loop
        }
    }
}

/* imagem com as cores primarias */
int main() {
    int i;
    int j;

    comandos[0] = CLEAR_BUFFER;
    comandos[1] = 0x0FFF;

    comandos[2] = DRAW_ARROW;
    comandos[3] = 15;
    comandos[4] = 15;
    comandos[5] = 70;
    comandos[6] = 70;
    comandos[7] = 0x000;

   /* comandos[8] = DRAW_SQUARE;
    comandos[9] = 40;
    comandos[10] = 50;
    comandos[11] = 15;
    comandos[12] = 0xFFF;*/

   /* comandos[2] = DRAW_Pack;
    comandos[3] = 50;
    comandos[4] = 50;
    comandos[5] = 40;
    comandos[6] = 0x0F0;*/

   /* comandos[13] = DRAW_TRIANGLE;
    comandos[14] = 15;
    comandos[15] = 60;
    comandos[16] = 15;
    comandos[17] = 0xFFF;

    comandos[18] = DRAW_TRIANGLERECT;
    comandos[19] = 63;
    comandos[20] = 78;
    comandos[21] = 15;
    comandos[22] = 0xF00;

    comandos[23] = DRAW_SQUAREFILLED;
    comandos[24] = 60;
    comandos[25] = 0;
    comandos[26] = 30;
    comandos[27] = 0xFFF;

    comandos[28] = DRAW_LINE;
    comandos[29] = 20;
    comandos[30] = 20;
    comandos[31] = 20;
    comandos[32] = 10;
    comandos[33] = 0x000F;

    comandos[34] = DRAW_LINE;
    comandos[35] = 20;
    comandos[36] = 20;
    comandos[37] = 10;
    comandos[38] = 20;
    comandos[39] = 0x000F;

    comandos[40] = DRAW_LINE;
    comandos[41] = 25;
    comandos[42] = 24;
    comandos[43] = 25;
    comandos[44] = 14;
    comandos[45] = 0x000F;

    comandos[46] = DRAW_LINE;
    comandos[47] = 24;
    comandos[48] = 25;
    comandos[49] = 14;
    comandos[50] = 25;
    comandos[51] = 0x000F;

    comandos[52] = DRAW_LINE;
    comandos[53] = 30;
    comandos[54] = 29;
    comandos[55] = 30;
    comandos[56] = 19;
    comandos[57] = 0x000F;

    comandos[58] = DRAW_LINE;
    comandos[59] = 29;
    comandos[60] = 30;
    comandos[61] = 19;
    comandos[62] = 30;
    comandos[63] = 0x000F;

    comandos[64] = DRAW_LINE;
    comandos[65] = 15;
    comandos[66] = 15;
    comandos[67] = 15;
    comandos[68] = 5;
    comandos[69] = 0x000F;

    comandos[70] = DRAW_LINE;
    comandos[71] = 15;
    comandos[72] = 15;
    comandos[73] = 5;
    comandos[74] = 15;
    comandos[75] = 0x000F;*/

    /*comandos[2] = DRAW_LINE;
    comandos[3] = 78;
    comandos[4] = 63;
    comandos[5] = 63;
    comandos[6] = 78;
    comandos[7] = 0x000F;

    comandos[8] = DRAW_LINE;
    comandos[9] = 78;
    comandos[10] = 78;
    comandos[11] = 78;
    comandos[12] = 63;
    comandos[13] = 0x000F;

    comandos[14] = DRAW_LINE;
    comandos[15] = 63;
    comandos[16] = 78;
    comandos[17] = 78;
    comandos[18] = 78;
    comandos[19] = 0x000F;

    comandos[20] = DRAW_LINE;
    comandos[21] = 15;
    comandos[22] = 15;
    comandos[23] = 70;
    comandos[24] = 70;
    comandos[25] = 0x000F;*/

    comandos[8] = END_CMD;



    processar_comandos();

    salvar_imagem("imagem2.ppm");
    return 0;
}
