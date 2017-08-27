//なんか間違っている

/*
誕生 死んでいるセルに隣接する生きたセルがちょうど3つあれば、次の世代が誕生する。
生存 生きているセルに隣接する生きたセルが2つか3つならば、次の世代でも生存する。
過疎 生きているセルに隣接する生きたセルが1つ以下ならば、過疎により死滅する。
過密 生きているセルに隣接する生きたセルが4つ以上ならば、過密により死滅する
*/

package main

import (
	"fmt"
	"math/rand"
	"time"
)

const (
	COUNT   int = 20
	LIVE    int = 1
	DEATH   int = 0
	PIONEER int = 200
)

type Field struct {
	cells [][]int
}

func New() *Field {
	_cells := make([][]int, COUNT)
	for i := 0; i < COUNT; i++ {
		_cells[i] = make([]int, COUNT)
	}
	return &Field{
		cells: _cells,
	}
}

func (f *Field) RandomBirthday() {
	for i := 0; i < PIONEER; i++ {
		f.cells[random()][random()] = LIVE
	}
}

func random() int {
	rand.Seed(time.Now().UnixNano())
	return rand.Intn(COUNT)
}

func (f Field) DecideLife(x int, y int) int {
	neighborCount := f.getNeighborsCount(x, y)
	if f.isUnderPopulation(neighborCount) || f.isOverPopulation(neighborCount) {
		return DEATH
	} else if f.isJustPopulation(neighborCount) {
		return LIVE
	} else {
		return f.cells[x][y]
	}
}

func (f Field) Write() {
	for _, line := range f.cells {
		for _, l := range line {
			if l == DEATH {
				fmt.Print(". ")
			} else {
				fmt.Print("o ")
			}
		}
		fmt.Print("\n")
	}
	fmt.Print("\n")
}

func (f Field) getNeighborsCount(x int, y int) int {
	result := 0
	if f.isOver0(x-1) && f.isOver0(y-1) && f.isExists(x-1, y-1) {
		result += 1
	}
	if f.isOver0(y-1) && f.isExists(x, y-1) {
		result += 1
	}
	if f.isUnderCount(x+1) && f.isOver0(y-1) && f.isExists(x+1, y-1) {
		result += 1
	}
	if f.isOver0(x-1) && f.isExists(x-1, y) {
		result += 1
	}
	if f.isUnderCount(x+1) && f.isExists(x+1, y) {
		result += 1
	}
	if f.isOver0(x-1) && f.isUnderCount(y+1) && f.isExists(x-1, y+1) {
		result += 1
	}
	if f.isUnderCount(y+1) && f.isExists(x, y+1) {
		result += 1
	}
	if f.isUnderCount(x+1) && f.isUnderCount(y+1) && f.isExists(x+1, y+1) {
		result += 1
	}
	return result
}

func (f *Field) SetCell(_cells [][]int)          { f.cells = _cells }
func (f Field) isExists(x int, y int) bool       { return f.cells[x][y] == LIVE }
func (f Field) isUnderPopulation(count int) bool { return count == 0 || count == 1 }
func (f Field) isOverPopulation(count int) bool  { return count >= 4 }
func (f Field) isJustPopulation(count int) bool  { return count == 3 }
func (f Field) isOver0(num int) bool             { return num >= 0 }
func (f Field) isUnderCount(num int) bool        { return num < COUNT }

func main() {
	field := New()
	field.RandomBirthday()
	field.Write()
	for i := 0; i < 500; i++ {
		cells := make([][]int, COUNT)
		for i := 0; i < COUNT; i++ {
			cells[i] = make([]int, COUNT)
		}

		for x := 0; x < COUNT; x++ {
			for y := 0; y < COUNT; y++ {
				cells[x][y] = field.DecideLife(x, y)
			}
		}
		field.SetCell(cells)
		field.Write()
		time.Sleep(100 * time.Millisecond)
	}
}
