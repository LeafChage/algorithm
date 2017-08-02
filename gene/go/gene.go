package main

import (
	"fmt"
	"math/rand"
	"time"
)

var Flag = false

const (
	FIRST_GENERATION_COUNT    = 10
	DESTROY_CHANGE_GENERATION = 2
	GENERATION_COUNT          = 50
)

type Individual struct {
	Gene  [5]int
	Point int
}

/* Individual */
//1世代目を一個体作る
func makeFirstGeneration() *Individual {
	rand.Seed(time.Now().UnixNano())
	a := rand.Intn(9)
	b := rand.Intn(9)
	c := rand.Intn(9)
	d := rand.Intn(9)
	e := rand.Intn(9)
	inidivisual := Individual{
		Gene:  [5]int{a, b, c, d, e},
		Point: 0,
	}
	return &inidivisual
}

//評価
func (indivisual *Individual) judgementGene() {
	correct_gene := []int{1, 2, 3, 4, 5}
	i := 0
	for key, value := range indivisual.Gene {
		if value == correct_gene[key] {
			i += 1
		}
	}
	indivisual.Point = i
	if indivisual.Point >= 5 {
		Flag = true
	}
}

//突然変異
func (inidivisual *Individual) mutation() {
	rand.Seed(time.Now().UnixNano())
	inidivisual.Gene[rand.Intn(5)] = rand.Intn(9)
	inidivisual.Gene[rand.Intn(5)] = rand.Intn(9)
}

//交配
func crossover(a *Individual, b *Individual) *Individual {
	rand.Seed(time.Now().UnixNano())
	num1 := rand.Intn(4)
	num2 := rand.Intn(4)

	a.Gene[num1] = b.Gene[num1]
	a.Gene[num2] = b.Gene[num2]
	return a
}

/* Colony */
type Colony []Individual

//1世代目をつくる
func makeFirstGenerations(count int) *Colony {
	var colony Colony
	i := 0
	for i < count {
		indivisual := makeFirstGeneration()
		colony = append(colony, *indivisual)
		i++
	}
	return &colony
}

//世代の評価
func (colony *Colony) judgementGenerations() *Colony {
	rand.Seed(time.Now().UnixNano())
	var result Colony
	for _, value := range *colony {
		value.judgementGene()
		if rand.Intn(30) == 1 {
			value.mutation() // 1%の確率で突然変異
		}
		result = append(result, value)
	}
	return &result
}

//選定
func (colony *Colony) nextGenerations() *Colony {
	i := 0
	for i < DESTROY_CHANGE_GENERATION {
		smallest_key := 0
		smallest_point := -1
		for key, value := range *colony {
			if key == 0 {
				smallest_point = value.Point
			} else {
				if smallest_point > value.Point {
					smallest_point = value.Point
					smallest_key = key
				}
			}
		}
		colony = remove(colony, smallest_key)
		i++
	}
	return colony
}

//交配
func (colony *Colony) crossovers() *Colony {
	rand.Seed(time.Now().UnixNano())
	//ranndomにふたつ選んで行うのを DESTROY_CHANGE_GENERATION 回数 行う
	i := 0
	for i < DESTROY_CHANGE_GENERATION {
		a := rand.Intn(FIRST_GENERATION_COUNT - DESTROY_CHANGE_GENERATION)
		b := rand.Intn(FIRST_GENERATION_COUNT - DESTROY_CHANGE_GENERATION)
		indivisuals := *colony
		//fmt.Println(indivisuals)

		indivisual := crossover(&indivisuals[a], &indivisuals[b])
		*colony = append(*colony, *indivisual)
		i++
	}
	return colony
}

func remove(colony *Colony, search int) *Colony {
	var result Colony
	for key, value := range *colony {
		if key != search {
			result = append(result, value)
		}
	}
	return &result
}

/* main 処理 */
func main() {
	generations := makeFirstGenerations(FIRST_GENERATION_COUNT)
	i := -0
	for {
		generations = generations.judgementGenerations().
			nextGenerations().
			crossovers()
		for _, gene := range *generations {
			fmt.Print(gene.Gene)
			fmt.Print(" ")
			fmt.Print(gene.Point)
			fmt.Print("\n")
		}
		fmt.Println(i)
		i++
		if Flag {
			break
		}
	}
}
