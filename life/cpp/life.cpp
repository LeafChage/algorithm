#include <iostream>
#include <random>
#include <unistd.h>

using namespace std;

const int COUNT = 20;
const char LIVE = 'o';
const char DEATH = '_';
const int pioneer = 100;

random_device rnd;     // 非決定的な乱数生成器を生成
mt19937 mt(rnd());     //  メルセンヌ・ツイスタの32ビット版、引数は初期シード値
uniform_int_distribution<> rand_0_to_count(0, COUNT);        // [0, 99] 範囲の一様乱数

class Field {
      private:
           char cells[COUNT][COUNT];
           void live_cell(int x, int y){
                 cells[x][y] = LIVE;
           }
           void death_cell(int x, int y){
                 cells[x][y] = DEATH;
           }
           bool is_exists(int x, int y){
                 bool result = false;
                 if(cells[x][y] == LIVE)
                       result = true;
                 return result;
           }
           int get_neighbors_count(int x, int y){
                 int result = 0;
                 if(over0(x-1) && over0(y-1) && is_exists(x-1, y-1)) result++;
                 if(over0(y-1) && is_exists(x, y-1)) result++;
                 if(underCount(x+1) && over0(y-1) && is_exists(x+1, y-1)) result++;
                 if(over0(x-1) && is_exists(x-1, y)) result++;
                 if(underCount(x+1) && is_exists(x+1, y)) result++;
                 if(over0(x-1) && underCount(y+1) && is_exists(x-1, y+1)) result++;
                 if(underCount(y+1) && is_exists(x, y+1)) result++;
                 if(underCount(x+1) && underCount(y+1) && is_exists(x+1, y+1)) result++;
                 return result;
           }
           bool over0(int num){
                 return ( num >= 0);
           }
           bool underCount(int num){
                 return (num < COUNT);
           }

      public:
           Field();
           void random_birthday();
           void decide_life(int, int);
           void write();
};

Field::Field(){
      for(int i = 0; i < COUNT; i++){
            for(int j = 0; j < COUNT; j++){
                  cells[i][j] = DEATH;
            }
      }
}

void Field::random_birthday(){
      for(int i = 0; i < pioneer; i++){
            cells[rand_0_to_count(mt)][rand_0_to_count(mt)] = LIVE;
      }
}

void Field::decide_life(int x, int y){
      int neighbor_count = get_neighbors_count(x, y);
      if(is_exists(x, y)){
            if(neighbor_count == 0 || neighbor_count == 1){
                  death_cell(x, y); //過疎死
            }else if(neighbor_count >= 4){
                  death_cell(x, y); //過密死
            }
      }else{
            if(neighbor_count == 3){
                  live_cell(x, y); //誕生
            }
      }
}

void Field::write(){
      for(int i = 0; i < COUNT; i++){
            for(int j = 0; j < COUNT; j++){
                  cout << cells[i][j] << ' ';
            }
            cout << "\n";
      }
      cout << "\n";
}

int main(){
      Field field;
      field.random_birthday();
      field.write();
      int i = 0;
      while(i < 500){
            for(int x = 0; x < COUNT - 1; x++){
                  for(int y = 0; y < COUNT - 1; y++){
                        field.decide_life(x, y);
                  }
            }
            field.write();
            usleep(500000);
            i++;
      }
      return 0;
}


