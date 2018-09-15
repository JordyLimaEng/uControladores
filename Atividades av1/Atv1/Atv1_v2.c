#include <stdio.h>
#include <stdlib.h>
#include <math.h>

int main(){

	int X1, Y1, Z1, W;

    while(1){

	printf("indique o lado A: ");
	scanf("%d", &X1);
	printf("indique o lado B: ");
	scanf("%d", &Y1);
	printf("indique o lado C: ");
	scanf("%d", &Z1);

	if( X1 > abs(Y1 - Z1) && X1 < Y1 + Z1 && Y1 > abs(X1 - Z1) && Y1 < X1 + Z1 && Z1 > abs(X1 - Y1) && Z1 < X1 + Y1){

      if( X1!=Y1 && X1!=Z1 && Y1!=X1 && Y1!=Z1 && Z1!=X1 && Z1!=Y1){
				W = 1;
				printf("\nW=%d - Escaleno\n", W);
				}

      else if( X1==Y1 && X1==Z1){
				W = 3;
				printf("\nW=%d - Equilatero\n", W);
				}

	  else if( X1==Y1 || Y1==Z1 || Z1==X1 ){
				W = 2;
				printf("\nW=%d - Isosceles\n", W);
				}

        }
	else {
                W=4;
                printf("\nW=%d - Nao existe\n", W);
        }
    }
	return 0;

}
