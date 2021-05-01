// //check 1
// int main(){
//     int b;
//     b=a+c;
//     return 0;
// }


// //check 2
// int main(){
//     int a;
//     a=10;
//     int a;
//     a=20;
// }


// //check 3
// int main(){
//     int a;
//     a=10;
//     if(a+2){
//         a-=2;
//     }
//     return 0;
// }

// //check 4
// int main(){
//     int a;
//     scanf("%d",&a);
//     a=10+'0';
//     a=10+"0";
//     return 0;
// }

// //check 5
// int main(){
// 	b=10;
// 	int a=4,b=5;
// 	a = a + 1;
// 	return 0;
// }

// //check 6
// void main(){
// 	return 0;
// }


int func() {
  int i = 8;
  if (i==8)
    return 1;
  else
    return 2;
}

int main() {
    int i ;
    scanf("%d",&i);
    int result = 1;
    int j = 1;
    for (j; j <= i; j=j+1) {
        result = result * j;
    }

    int funRet = func();
    printf("%d\n%d",result,funRet);
    return 0;
}