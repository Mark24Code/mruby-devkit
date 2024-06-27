def fib(n)
  if n < 2
    n
  else
    fib(n-2) + fib(n-1)
  end
end

puts fib(40)
