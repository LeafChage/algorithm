#![allow(non_snake_case)]
extern crate rand;

use std::{thread, time};
use rand::Rng;

const COUNT: u32 = 20;
const PIONEER: u32 = 100;

#[derive(Copy, Clone, PartialEq)]
enum Status{
    Live,
    Death,
}

struct Field{
    cells: [[Status; COUNT as usize]; COUNT as usize]
}

impl Field {
    fn new() -> Field{
        Field{
            cells: [[Status::Live; COUNT as usize]; COUNT as usize]
        }
    }

    fn randomBirthday(&mut self){
        let mut rnd = rand::thread_rng();
        for _ in 0..PIONEER {
            self.cells[rnd.gen_range(0,COUNT) as usize][rnd.gen_range(0,COUNT) as usize] = Status::Live;
        }
    }

    fn decideLife(&mut self, x: isize, y: isize){
        let neighbor_count = self._getNeighborsCount(x, y);
        if self._isExist(x, y) {
            if self._isUnderPopulation(neighbor_count) || self._isOverPopulation(neighbor_count){
                self._deathCell(x as usize, y as usize);
            }
        }else{
            if self._isJustPopulation(neighbor_count){
                self._liveCell(x as usize, y as usize);
            }
        }
    }

    fn write(&self){
        for y in 0..COUNT {
            for x in 0..COUNT {
                if self.cells[y as usize][x as usize] == Status::Live {
                    print!("o  ");
                }else{
                    print!("_  ");
                }
            }
            println!("\n");
        }
        println!("\n");
    }

    fn _liveCell(&mut self, x: usize, y: usize){
        self.cells[y][x] = Status::Live;
    }
    fn _deathCell(&mut self, x: usize, y: usize){
        self.cells[y][x] = Status::Death;
    }
    fn _getNeighborsCount(&self, x: isize, y: isize) -> i32 {
        let mut result = 0;
        if self._isNotOutOfField(x-1) && self._isNotOutOfField(y-1) && self._isExist(x-1, y-1){ result += 1 }
        if self._isNotOutOfField(y-1) && self._isExist(x, y-1){ result += 1 }
        if self._isNotOutOfField(x+1) && self._isNotOutOfField(y-1) && self._isExist(x+1, y-1){ result += 1}
        if self._isNotOutOfField(x-1) && self._isExist(x-1, y){ result += 1}
        if self._isNotOutOfField(x+1) && self._isExist(x+1, y){ result += 1}
        if self._isNotOutOfField(x-1) && self._isNotOutOfField(y+1) && self._isExist(x-1, y+1){ result += 1}
        if self._isNotOutOfField(y+1) && self._isExist(x, y+1){ result += 1}
        if self._isNotOutOfField(x+1) && self._isNotOutOfField(y+1) && self._isExist(x+1, y+1){ result += 1}
        return result
    }
    fn _isUnderPopulation(&self, count: i32) -> bool {
        count == 0 || count == 1
    }
    fn _isOverPopulation(&self, count: i32) -> bool {
        count >= 4
    }
    fn _isJustPopulation(&self, count: i32) -> bool {
        count == 3
    }
    fn _isExist(&self, x: isize, y: isize) -> bool {
        self.cells[y as usize][x as usize] == Status::Live
    }
    fn _isNotOutOfField(&self, num: isize) -> bool {
        self._isOver0(num) && self._isUnderCount(num)
    }
    fn _isOver0(&self, num: isize) -> bool {
        num >= 0
    }
    fn _isUnderCount(&self, num: isize) -> bool {
        num < COUNT as isize
    }
}

fn main() {
    println!("Hello, world!");
    let mut field = Field::new();
    field.randomBirthday();
    field.write();

    loop {
        for y in 0..COUNT as usize{
            for x in 0..COUNT {
                field.decideLife(x as isize, y as isize);
            }
        }
        field.write();

        thread::sleep(time::Duration::from_millis(100));
    }
}

