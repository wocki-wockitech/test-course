package main

import "fmt"

func main() {
	i := 0

	defer fmt.Println("defer A:", i)

	i++
	defer fmt.Println("defer B:", i)

	i++
	fmt.Println("body:", i)
}
