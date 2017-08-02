extern crate rand;

use rand::Rng;

const FIRST_GENERATION_COUNT: i32 = 20;
const DESTROY_CHANGE_GENERATION: i32 = 5;
const GENE_COUNT: usize = 10;
const CORRECT_GENE: [u8; GENE_COUNT] = [1,2,3,4,5,6,7,8,9,1];
const MUTATION_RATIO: usize = 10;
static mut FLAG: bool = false;

#[derive(Clone)]
struct Indivisual {
    gene: [u8; GENE_COUNT],
    point: u8
}

impl Indivisual {
    fn get_point(&self) -> u8 { self.point }

    //1世代目を一個体作る
    fn make_first_generation() -> Indivisual {
        Indivisual {
            gene: [
                rand::thread_rng().gen_range(1, 10),
                rand::thread_rng().gen_range(1, 10),
                rand::thread_rng().gen_range(1, 10),
                rand::thread_rng().gen_range(1, 10),
                rand::thread_rng().gen_range(1, 10),
                rand::thread_rng().gen_range(1, 10),
                rand::thread_rng().gen_range(1, 10),
                rand::thread_rng().gen_range(1, 10),
                rand::thread_rng().gen_range(1, 10),
                rand::thread_rng().gen_range(1, 10),
            ],
            point: 0,
        }
    }

    //評価
    fn judgment_gene(&self) -> Indivisual {
        let mut i = 0;
        let mut _point = 0;
        while i < GENE_COUNT {
            if self.gene[i] == CORRECT_GENE[i] {
                _point += 1;
            }
            i += 1;
        }
        if _point >= 10 {
            unsafe { FLAG = true; }
        }
        Indivisual { gene: self.gene, point: _point }
    }

    //交配
    fn crossover(a: Indivisual, b: Indivisual) -> Indivisual {
        let mut num1 = rand::thread_rng().gen_range(1, 10);
        let mut g: [u8; GENE_COUNT] = a.gene;

        while num1 < GENE_COUNT {
            g[num1] = b.gene[num1];
            num1 += 1;
        }

        Indivisual {
            gene: g,
            point: 0
        }
    }

    //突然変異
    fn mutation(&self) -> Indivisual {
        let mut g: [u8; GENE_COUNT] = self.gene;
        g[rand::thread_rng().gen_range(0, 10)] = rand::thread_rng().gen_range(1, 10);
        g[rand::thread_rng().gen_range(0, 10)] = rand::thread_rng().gen_range(1, 10);
        Indivisual {
            gene: g,
            point: self.point
        }
    }
}

struct Colony {
    generation: Vec<Indivisual>,
}


impl Colony {
    //1世代目をつくる
    fn make_first_generations(count: i32) -> Colony {
        let mut colony: Colony = Colony{ generation: Vec::new() };
        let mut i = 0;
        while i < count {
            colony.generation.push(Indivisual::make_first_generation());
            i += 1;
        }
        colony
    }

    //世代の評価
    fn judgment_generations(&self) -> Colony {
        let mut colony: Colony = Colony{ generation: Vec::new() };
        for indivisual in &(self.generation) {
            if rand::thread_rng().gen_range(1, MUTATION_RATIO ) == 1 {
                colony.generation.push(indivisual.mutation())
            } else {
                colony.generation.push(indivisual.judgment_gene());
            }
        }
        colony
    }

    //選定
    fn next_generations(&mut self){
        let mut i = 0;
        while i < DESTROY_CHANGE_GENERATION {
            let mut s_key = 0;
            let mut s_point = 0;
            let mut j = 0;
            for indivisual in &(self.generation) {
                if j == 0 {
                    s_point = indivisual.get_point();
                } else if s_point > indivisual.get_point(){
                    s_key = j;
                    s_point = indivisual.get_point();
                }
                j += 1;
            }
            self.generation.remove(s_key);
            i += 1;
        }
    }

    //交配
    fn crossovers(&mut self) {
        let mut i = 0;
        while i < DESTROY_CHANGE_GENERATION {
            let max: usize = (FIRST_GENERATION_COUNT - DESTROY_CHANGE_GENERATION) as usize;
            let rnd_a: usize = rand::thread_rng().gen_range(1, max);
            let rnd_b: usize = rand::thread_rng().gen_range(1, max);
            let gene_a = self.generation[rnd_a].clone();
            let gene_b = self.generation[rnd_b].clone();

            self.generation.push( Indivisual::crossover(gene_a, gene_b) );

            i += 1;
        }
    }
}

fn main(){
    println!("main");
    let mut generations: Colony = Colony::make_first_generations(FIRST_GENERATION_COUNT);
    let mut i = 0;
    while true {
        generations = generations.judgment_generations();
        generations.next_generations();
        generations.crossovers();
        for g in &generations.generation {
            println!("{:?}: {}", g.gene, g.point);
        }
        println!("generations: {}", i);
        unsafe { if FLAG { break; } }
        i += 1;
    }
}
