package main

import "fmt"

// fibonacci 函数使用迭代方法计算第 n 项斐波那契数
func fib(n int) int {
	if n <= 1 {
		return n
	}

	fibMinus2 := 0 // F(0)
	fibMinus1 := 1 // F(1)
	fibN := 0

	for i := 2; i <= n; i++ {
		fibN = fibMinus1 + fibMinus2
		fibMinus2, fibMinus1 = fibMinus1, fibN
	}

	return fibN
}

func main() {
	fmt.Printf("%d", fib(80))
}
