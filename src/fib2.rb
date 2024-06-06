def fib(n)
  return n if n <= 1

  fib_minus_2 = 0  # F(0)
  fib_minus_1 = 1  # F(1)
  fib_n = nil

  (2..n).each do |i|
    fib_n = fib_minus_1 + fib_minus_2
    fib_minus_2 = fib_minus_1
    fib_minus_1 = fib_n
  end

  fib_n
end

puts fib(800)
