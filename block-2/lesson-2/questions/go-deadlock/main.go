package main

import "fmt"

func main() {
	ch := make(chan int) // небуферизованный канал

	// Отправляем в канал, но нет другой горутины, которая бы читала
	ch <- 42

	fmt.Println(<-ch)
}
