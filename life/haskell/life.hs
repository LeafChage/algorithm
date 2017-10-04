import System.Random
import Debug.Trace

count :: Int
count = 20

pioneer :: Int
pioneer = 100

-- enum
data Status = Live | Death deriving (Show, Enum, Eq)

type Line = [Status]
type Field = [Line]

newLine :: Line
newLine = replicate count Death

newField :: Field
newField = replicate count newLine

-- fieldの描画
writeField :: Field -> IO ()
writeField [] = putStrLn ""
writeField f = do
  writeLine $ head f
  putStrLn ""
  writeField $ tail f

-- lineの描画
writeLine :: Line -> IO ()
writeLine [] = putStr ""
writeLine (Live:x) = do
  putStr "o "
  writeLine x
writeLine (Death:x) = do
  putStr "_ "
  writeLine x

--セルの振る舞いを決める
decideLifes :: Field -> Field -> [[Int]]  -> Field
decideLifes _ t [] = t
decideLifes f t ([x, y]:xs) = decideLifes f (decideLife f t x y) xs

decideLife :: Field -> Field -> Int -> Int -> Field
decideLife f t x y
  | is_exists && ( isUnderPopulation neighbor_count || isOverPopulation neighbor_count ) = deadCells t x y
  | (not is_exists) && isJustPopulation neighbor_count = liveCells t x y
  | otherwise = t
    where
      neighbor_count = getNeighborsCount f x y
      is_exists = isExist f x y

-- 指定されたセルを生き返らせる
liveCells :: Field -> Int -> Int -> Field
liveCells f x y = do
  front ++ [(liveCell line x)] ++ back
    where
      front = take y f
      line = drop y $ take (y+1) f
      back = drop (y+1) f

liveCell :: Field -> Int -> Line
liveCell [l] x = do
  front ++ [Live] ++ back
    where
      front = take x l
      back = drop (x+1) l


-- 指定されたcellの削除
deadCells :: Field -> Int -> Int -> Field
deadCells f x y = do
  front ++ [(deadCell line x)] ++ back
    where
      front = take y f
      line = drop y $ take (y+1) f
      back = drop (y+1) f

deadCell :: Field -> Int -> Line
deadCell [l] x = do
  front ++ [Death] ++ back
    where
      front = take x l
      back = drop (x+1) l

-- 周囲の数を調べる
getNeighborsCount :: Field -> Int -> Int -> Int
getNeighborsCount f x y = do
  foldr (+) 0 $ map trueToOne [leftup, up, rightup, left, right, leftbottom, bottom, rightbottom]
    where
      leftup = (isNotOutOfField (x-1)) && (isNotOutOfField(y-1)) && (isExist f (x-1) (y-1))
      up = (isNotOutOfField (y-1)) && (isExist f x (y-1))
      rightup = (isNotOutOfField (x+1)) && (isNotOutOfField(y-1)) && (isExist f (x+1) (y-1))
      left = (isNotOutOfField (x-1)) && (isExist f (x-1) y)
      right = (isNotOutOfField (x+1)) && (isExist f (x+1) y)
      leftbottom = (isNotOutOfField (x-1)) && (isNotOutOfField (y+1)) && (isExist f (x-1) (y+1))
      bottom = (isNotOutOfField (y+1)) && (isExist f x (y+1))
      rightbottom = (isNotOutOfField (x+1)) && (isNotOutOfField (y+1)) && (isExist f (x+1) (y+1))
      trueToOne q = if q == True then 1 else 0

-- 過疎
isUnderPopulation :: Int -> Bool
isUnderPopulation count = count == 0 || count == 1

-- 過密
isOverPopulation :: Int -> Bool
isOverPopulation count = count >= 4

-- 子作り最適
isJustPopulation :: Int -> Bool
isJustPopulation count = count == 3

--存在している
isExist :: Field -> Int -> Int -> Bool
isExist f x y = getCell f x y  == Live

-- outofrangeが起きないよう
isNotOutOfField :: Int -> Bool
isNotOutOfField num = (isOverZero num) && (isUnderCount num)

isOverZero :: Int -> Bool
isOverZero num =  num >= 0

isUnderCount :: Int -> Bool
isUnderCount num = num < count

-- セル取得
getCell :: Field -> Int -> Int -> Status
getCell f x y = f !! y !! x


-- 初期段階の生存セルの決定
randomBirthday :: Field -> [[Int]]-> Field
randomBirthday f [] = f
randomBirthday f (a:b) = do
  randomBirthday (liveCells f x y) b
    where
      x = head a
      y = head $ tail a


-- リストを前から二つずつペアにする
makePair :: [Int] -> [[Int]]
makePair [] = []
makePair (a:b:c) = [a,b] : makePair c

main = do
  gen <- getStdGen
  let field = newField
      list = take pioneer [1,2..]
      new_field = randomBirthday field $ makePair $ take (pioneer*2) $ (randomRs (0,(count-1)) gen :: [Int])
  writeField new_field
  run new_field $ take 500 [1, 2..]

run :: Field -> [Int] -> IO ()
run f [] = writeField f
run f (x:xs) = do
  writeField field
  run field xs
  where
      _y = take count [0,1 ..]
      _x = take count [0,1 ..]
      pair = [[x, y]| x <- _x, y <- _y]
      tmp = f
      field = decideLifes f tmp pair


