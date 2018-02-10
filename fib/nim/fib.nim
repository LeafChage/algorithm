proc fib(num: uint): uint =
  if num < 2:
    num
  else:
    fib(num-2) + fib(num-1)

echo fib(39)
