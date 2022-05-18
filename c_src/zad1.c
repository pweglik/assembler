#include <stdio.h>

int main()
{
    short a = 0;
    short b = 0;
    short sol = 0;
    int i = 0;
    int j = 0;


    if(scanf("%hd", &a) < 0)
    {
        printf("ERROR LOADING A");
    }
    if(a < -10 || a > 10)
    {
        printf("A OUT OF RANGE");
    }

    if(scanf("%hd", &b) < 0)
    {
        printf("ERROR LOADING B");
    }
    if(b < -10 || b > 10)
    {
        printf("B OUT OF RANGE");
    }

    
    sol = -1 * b/a;
    printf("root: %d, y axis intersec: %d\n", sol, b);


    
    while(i < 20)
    {
        while(j < 20)
        {
            char disp = ' ';
            if(i == 10)
            {
                disp = '#';
            }
            if(j == 10)
            {
                disp = '#';
            }
            if((j-10) * a + b == 10 - i) // if it lies on a function's graph
            {
                disp = '*';
            }
            printf("%c", disp);
            j++;
        }
        printf("\n");
        i++;
        j = 0;
    }
    return 1;
}