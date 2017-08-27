#include <stdio.h>

int main(){
      for(int i = 0; i < 10; i++){
            int tmp = fib(i);
            printf("%d\n", tmp);
      }
      return 0;
}

int fib(int num){
      if(num <= 1){
            return num;
      }else{
            return fib(num-2) + fib(num-1);
      }
}
