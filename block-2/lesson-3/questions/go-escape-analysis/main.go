package main

import "fmt"

type User struct {
	Name string
	Age  int
}

// Возвращаем указатель на локальную переменную
func newUser(name string) *User {
	u := User{Name: name, Age: 30} // куда попадёт u?
	return &u
}

func main() {
	user := newUser("Bob")
	fmt.Println(user.Name)
}
