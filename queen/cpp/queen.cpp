#include <iostream>
using namespace std;

class queen{
      private:
            int n;
            int count;
            int result[];
            void init_array(int y);
            bool can_put(int x, int y);
            bool slant_check(int x, int y);
            bool is_include(int x);
            void write();
            void put(int x, int y);

      public:
            queen();
            queen(int n);
            void run(int y = 0);
            ~queen(){ };
};

queen::queen(){
      n = 8;
      count = 0;
      for(int i = 0; i < n; i++){
            result[i] = -1;
      }
}
queen::queen(int _n){
      n = _n;
      count = 0;
      for(int i = 0; i < n; i++){
            result[i] = -1;
      }
}

void queen::run(int y){
      for(int x = 0; x < n; x++){
            init_array(y);
            if(!can_put(x, y)){ continue; }
            put(x, y);
            if(y == n - 1){
                  count++;
                  write();
            }else{
                 run(y + 1);
            }
      }
}

void queen::init_array(int y){
      int i = 0;
      for(int i = 0; i < n; i++){
            if(i >= y){ result[i] = -1; }
      }
}

bool queen::can_put(int x, int y){
      return result[y] == -1 && !is_include(x) && slant_check(x, y);
}

bool queen::slant_check(int x, int y){
      int tmp1 = y - x;
      int tmp2 = y + x;
      for(int i = 0; i < n; i++){
            if (result[i] == -1){
                  continue;
            }else if(i == result[i] + tmp1 || i == -(result[i]) + tmp2) {
                  return false;
            }
      }
      return true;
}

bool queen::is_include(int x){
      for(int i = 0; i < n; i++){
            if(result[i] == x){
                  return true;
            }
      }
      return false;
}

void queen::write(){
      for(int y = 0; y < n; y++){
            for(int x = 0; x < n; x++){
                  if(result[y] == x){
                        cout << "Q ";
                  }else{
                        cout << "_ ";
                  }
            }
            cout <<  "\n";
      }
      cout << count << "\n";
}

void queen::put(int x, int y){
      result[y] = x;
}

int main(){
      queen q(8);
      q.run();
      cout << "hi\n";
      return 0;
}
