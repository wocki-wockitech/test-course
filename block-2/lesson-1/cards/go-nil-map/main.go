package main

import "fmt"

func main() {
	var counts map[string]int // nil map, не инициализирована через make

	// Чтение из nil map безопасно
	fmt.Println(counts["a"])

	// А вот запись...
	counts["a"] = 1

	fmt.Println(counts["a"])
}
