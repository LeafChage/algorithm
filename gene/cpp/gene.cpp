#include <iostream>
#include <vector>
#include <random>

using namespace std;

const int GENE_COUNT = 18;
const int GENERATIONS = 20;
const int DESTROY = 5;
const char* ALPHABET = "abcdefghijklmnopqrstuvwxyz";
const char* CORRECT_GENE = "caramelfrappuchino";

//random関数
random_device r;
mt19937 mt(r());
uniform_int_distribution<int> rand_alphabet(0,25);
uniform_int_distribution<int> rand_gene_count(0, GENE_COUNT - 1);
uniform_int_distribution<int> rand_mutation(0, 15);

bool Flag = false;

class indivisual {
      private:
            char gene[GENE_COUNT];
            int point;
            void create_gene();
      public:
            indivisual(){
                  point = 0;
                  create_gene();
            };
            int get_point(){ return point; }
            char *get_gene(){ return gene; }
            void set_gene_with_index(int index, char g){ gene[index] = g; }
            char get_gene_with_index(int index){ return gene[index]; }
            void review();
            void mutation();
            static void make_child(indivisual &child, indivisual &mother, indivisual &father){
                  int rnd = rand_gene_count(mt);
                  int i = 0;
                  while( i < GENE_COUNT){
                        if( i < rnd){
                              child.set_gene_with_index(i, mother.get_gene_with_index(i));
                        }else{
                              child.set_gene_with_index(i, father.get_gene_with_index(i));
                        }
                        i++;
                  }
            }
            ~indivisual(){ }
};

void indivisual::create_gene(){
      int i = 0;
      while (i < GENE_COUNT) {
            gene[i] = ALPHABET[rand_alphabet(mt)];
            i++;
      }
}
void indivisual::review(){
      point = 0;
      int i = 0;
      while(i < sizeof(gene) / sizeof(gene[0])){
            if(gene[i] == CORRECT_GENE[i]){ point++; }
            i++;
      }
      if(point >= GENE_COUNT){
            Flag = true;
      }
}

void indivisual::mutation(){
      gene[rand_gene_count(mt)] = ALPHABET[rand_alphabet(mt)];
      gene[rand_gene_count(mt)] = ALPHABET[rand_alphabet(mt)];
}

class colony {
      private:
            vector<indivisual> genes;
      public:
            colony(){
                  int i = 0;
                  while(i < GENERATIONS){
                        indivisual ind;
                        genes.push_back(ind);
                        i++;
                  }
            }
            void write_gene();
            void reviews();
            void destroy();
            void make_children();
            void mutations();
            ~colony(){ };
};
void colony::reviews(){
      for(indivisual& i : genes){
            i.review();
      }
}

void colony::destroy(){
      int i = 0;
      while (i < DESTROY) {
            int s_key = 0;
            int s_point = 0;
            int j = 0;
            for(indivisual& ind : genes){
                  if(j == 0){
                        s_point = ind.get_point();
                  } else if( s_point > ind.get_point()) {
                        s_key = j;
                        s_point = ind.get_point();
                  }
                  j++;
            }
            genes.erase(genes.begin() + s_key);
            i++;
      }
}
void colony::make_children(){
      int i = 0;
      while(i < DESTROY) {
            int rnd1 = 1;
            int rnd2 = 2;
            indivisual child;
            indivisual::make_child(child, genes[rnd1], genes[rnd2]);
            genes.push_back(child);
            i++;
      }
}
void colony::mutations(){
      for(indivisual& i : genes){
            if(rand_mutation(mt) == 1){
                  i.mutation();
            }
      }
}
void colony::write_gene(){
      for(indivisual& i : genes){
            cout << i.get_gene() << " " << i.get_point() << "\n";
      }
      cout << "\n";
}

int main(){

      colony c;
      int i = 0;
      while (i < 50000){
            cout << "generation: " << i << "\n";
            c.reviews();
            c.write_gene();
            c.destroy();
            c.make_children();
            c.mutations();
            if(Flag){
                  cout << "finish" << "\n";
                  break;
            }
            i++;
      }
      return 0;
}


