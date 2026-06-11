package main

import "fmt"

func main() {
	s := make([]int, 3, 5) // len=3, cap=5: [0 0 0]
	s[0], s[1], s[2] = 1, 2, 3

	a := s[:2]        // len=2, cap=5, делит массив с s
	a = append(a, 99) // ёмкости хватает: пишем в общий массив, перетираем s[2]

	fmt.Println(s)
	fmt.Println(a)
}
