#include <stdio.h>
#include <stdlib.h>
#include <math.h>

int main(){
	
	int X1, Y1, Z1, W;
	int menu;
	
	do{	
	printf("\n\tMENU\n");
	printf(" 1 - verifique se eh escaleno\n");
	printf(" 2 - verifique se eh isosceles\n");
	printf(" 3 - verifique se eh equilatero\n");
	printf(" 4 - verifique se existe\n");
	printf(" 0 - SAIR\n->");
	scanf("%d", &menu);

	switch (menu){
		
		case 1:	
		system("cls");	
	printf("indique o lado A: ");
	scanf("%d", &X1);
	printf("indique o lado B: ");
	scanf("%d", &Y1);
	printf("indique o lado C: ");
	scanf("%d", &Z1);
	
			if( X1 > abs(Y1 - Z1) && X1 < Y1 + Z1){ printf("Existe\n");}
			else if( Y1 > abs(X1 - Z1) && Y1 < X1 + Z1){ printf("Existe\n");}
			else if( Z1 > abs(X1 - Y1) && Z1 < X1 + Y1){ printf("Existe\n");}
			else {W=4; printf("\nW=%d - Nao existe\n", W); break;} 
			
			if( X1!=Y1 && X1!=Z1 && Y1!=X1 && Y1!=Z1 && Z1!=X1 && Z1!=Y1){ W = 1;printf("W=%d - Escaleno", W);} 
			else{printf("Nao eh Escaleno\n");}
		break;
		
		case 2:
		system("cls");	
	printf("indique o lado A: ");
	scanf("%d", &X1);
	printf("indique o lado B: ");
	scanf("%d", &Y1);
	printf("indique o lado C: ");
	scanf("%d", &Z1);
			
			if( X1 > abs(Y1 - Z1) && X1 < Y1 + Z1){ printf("Existe\n");}
			else if( Y1 > abs(X1 - Z1) && Y1 < X1 + Z1){ printf("Existe\n");}
			else if( Z1 > abs(X1 - Y1) && Z1 < X1 + Y1){ printf("Existe\n");}
			else {W=4; printf("\nW=%d - Nao existe\n", W); break;} 
			
			if( X1==Y1 || Y1==Z1 || Z1==X1 ){ W = 2;printf("W=%d - Isosceles", W);}
			else{printf("Nao eh Isosceles\n");}
		break;
		
		case 3:
		system("cls");	
	printf("indique o lado A: ");
	scanf("%d", &X1);
	printf("indique o lado B: ");
	scanf("%d", &Y1);
	printf("indique o lado C: ");
	scanf("%d", &Z1);
		
			if( X1 > abs(Y1 - Z1) && X1 < Y1 + Z1){ printf("Existe\n");}
			else if( Y1 > abs(X1 - Z1) && Y1 < X1 + Z1){ printf("Existe\n");}
			else if( Z1 > abs(X1 - Y1) && Z1 < X1 + Y1){ printf("Existe\n");}
			else {W=4; printf("\nW=%d - Nao existe\n", W); break;}
		
			if( X1==Y1 && X1==Z1){
				W = 3;
				printf("W=%d - Equilatero", W);
				}
			else{
				printf("Nao eh Equilatero\n");
				}
		break;
		
		case 4:
		system("cls");	
	printf("indique o lado A: ");
	scanf("%d", &X1);
	printf("indique o lado B: ");
	scanf("%d", &Y1);
	printf("indique o lado C: ");
	scanf("%d", &Z1);
	
			if( X1 > abs(Y1 - Z1) && X1 < Y1 + Z1){ printf("Existe\n");}
			else if( Y1 > abs(X1 - Z1) && Y1 < X1 + Z1){ printf("Existe\n");}
			else if( Z1 > abs(X1 - Y1) && Z1 < X1 + Y1){ printf("Existe\n");}
			else {W=4; printf("\nW=%d - Nao existe\n", W);} 
		
		break;
		
		default:
		system("cls");
		printf("encerrando\n");
	}
		
	}while(menu!=0);
	
	return 0;
}