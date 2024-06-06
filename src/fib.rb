def fib(n)
  return n if n <= 1

  # 创建一个数组来存储斐波那契数
  fib_sequence = [0, 1] + Array.new(n - 1)

  # 填充数组
  (2..n).each do |i|
    fib_sequence[i] = fib_sequence[i - 1] + fib_sequence[i - 2]
  end

  # 返回所需的斐波那契数
  fib_sequence[n]
end

# 测试函数
puts fib(40) # 应该输出55



# def fib(n)
#   if n < 2
#     n
#   else
#     fib(n-2) + fib(n-1)
#   end
# end

# puts fib(40)
