main:: IO ()
main = do
  print $ fib 10

fib :: Int -> Int
fib num
  | num <= 1 = num
  | otherwise = (fib (num-2)) + (fib (num-1))
