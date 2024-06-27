package main

import (
	"fmt"
)

func fib(num int) int {
	if num < 2 {
		return num
	} else {
		return fib(num-1) + fib(num-2)
	}
}

func main() {
	fmt.Print(fib(40))
}
