package main

import "fmt"

type Queen struct {
	num    int
	count  int
	result []int
}

func new(_num int) *Queen {
	_result := make([]int, _num)
	i := 0
	for i < _num {
		_result[i] = -1
		i++
	}
	return &Queen{
		num:    _num,
		count:  0,
		result: _result,
	}
}

func (queen *Queen) queen(y int) {
	for x := 0; x < queen.num; x++ {
		queen.init_array(y)
		if !queen.can_putp(x, y) {
			continue
		}
		queen.put(x, y)
		if y == queen.num-1 {
			queen.count++
			queen.write()
		} else {
			queen.queen(y + 1)
		}
	}
}

func (queen *Queen) init_array(y int) {
	for i := 0; i < queen.num; i++ {
		if i >= y {
			queen.result[i] = -1
		}
	}
}

func (queen Queen) can_putp(x int, y int) bool {
	return queen.result[y] == -1 && !queen.is_includep(x) && queen.slant_checkp(x, y)
}

func (queen Queen) is_includep(x int) bool {
	b := false
	for _, value := range queen.result {
		if value == x {
			b = true
		}
	}
	return b
}

func (queen Queen) slant_checkp(x int, y int) bool {
	tmp1 := y - x
	tmp2 := y + x
	b := true
	for _y, _x := range queen.result {
		if _x == -1 {
			continue
		}
		if _y == _x+tmp1 || _y == (-_x)+tmp2 {
			b = false
		}
	}
	return b
}

func (queen Queen) write() {
	for y := 0; y < queen.num; y++ {
		for x := 0; x < queen.num; x++ {
			if queen.result[y] == x {
				fmt.Print("Q ")
			} else {
				fmt.Print(". ")
			}
		}
		fmt.Print("\n")
	}
	fmt.Println(queen.count)
	fmt.Print("\n")
}

func (queen *Queen) put(x int, y int) {
	queen.result[y] = x
}

func main() {
	q := new(12)
	q.queen(0)
}
