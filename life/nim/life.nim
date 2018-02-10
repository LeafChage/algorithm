import random

const
  COUNT: int = 100
  PIONEER: int = 200

type
  # enumの宣言 pureをつけると
  # Live -> errorになる
  # Status.Live -> okになるらしい
  Status {.pure.} = enum
      Live
      Death

  #多次元配列はこんな感じ？
  Cells = array[Count, array[COUNT, Status]]
  Point = tuple[x: int, y: int]
  Field = ref object of RootObj
    cells: Cells
    next_cells: Cells


# 関数宣言
# ここで宣言しておくと順番が後でも呼べるようになる
proc init_cells(): Cells
proc init_field(): Field
proc write(field: Field)
proc random_birthday(field: var Field)
proc get_neighbors_count(field: Field, point: Point): int
proc decide_life(field: var Field, point: Point)
proc live_cell(field: var Field, point: Point)
proc death_cell(field: var Field, point: Point)
proc is_under_population(count: int): bool
proc is_over_population(count: int): bool
proc is_just_population(count: int): bool
proc is_over0(num: int): bool
proc is_under_count(num: int): bool
proc is_exists(field: Field, point: Point): bool

# fieldオブジェクトの初期化
proc init_field(): Field =
  let cells = init_cells()
  return Field(cells: cells, next_cells: cells)

# cellsの初期化
proc init_cells(): Cells =
  var cells: array[COUNT, array[COUNT, Status]]
  for x in countup(0, COUNT-1):
    for y in countup(0, COUNT-1):
      cells[x][y] = Status.Death
  cells

#現在の状況を描画する
proc write(field: Field) =
  for x in countup(0, COUNT - 1):
    for y in countup(0, COUNT - 1):
      let cell = field.next_cells[x][y]
      field.cells[x][y] = cell
      case cell
        of Status.Live:
          write(stdout, "o ")
        of Status.Death:
          write(stdout, "_ ")
    echo("")

# 最初からいる生物をランダムに発生させる
# dot(.)でアクセスするとdotの前が第一引数になるらしい
# field.random_birthday() === random_birthday(field)?
# 多分 varで引数を指定するとミュータブルになる
proc random_birthday(field: var Field) =
  for i in countup(0, PIONEER):
    field.next_cells[random(COUNT-1)][random(COUNT-1)] = Status.Live

#周辺のcellの個数を取得
proc get_neighbors_count(field: Field, point: Point): int =
  var result = 0
  let x = point.x
  let y = point.y
  if is_over0(x-1) and is_over0(y-1) and field.is_exists((x-1, y-1)): result += 1
  if is_over0(y-1) and field.is_exists((x, y-1)): result += 1
  if is_under_count(x+1) and is_over0(y-1) and field.is_exists((x+1, y-1)): result += 1
  if is_over0(x-1) and field.is_exists((x-1, y)): result += 1
  if is_under_count(x+1) and field.is_exists((x+1, y)): result += 1
  if is_over0(x-1) and is_under_count(y+1) and field.is_exists((x-1, y+1)): result += 1
  if is_under_count(y+1) and field.is_exists((x, y+1)): result += 1
  if is_under_count(x+1) and is_under_count(y+1) and field.is_exists((x+1, y+1)): result += 1
  result

#人生を決める
proc decide_life(field: var Field, point: Point) =
  let neighbors_count = field.get_neighbors_count(point)
  if field.is_exists(point):
    if is_under_population(neighbors_count) or is_over_population(neighbors_count):
      field.death_cell(point)
  else:
    if is_just_population(neighbors_count):
      field.live_cell(point)

#cellを生む
proc live_cell(field: var Field, point: Point) =
  field.next_cells[point.x][point.y] = Status.Live

#cellを殺す
proc death_cell(field: var Field, point: Point) =
  field.next_cells[point.x][point.y] = Status.Death

# 過疎か判断
proc is_under_population(count: int): bool =
  #pythonに似ていて && ||はないかも
  count == 0 and count == 1

# 過密か判断
proc is_over_population(count: int): bool =
  count >= 4

#ちょうどいいか判断
proc is_just_population(count: int): bool =
  count == 3

proc is_over0(num: int): bool =
  num >= 0

proc is_under_count(num: int): bool =
  num < COUNT

#cellが存在しているか
proc is_exists(field: Field, point: Point): bool =
  field.cells[point.x][point.y] == Status.Live

proc main() =
  randomize()
  var field = init_field()
  field.random_birthday()
  field.write()
  while readLine(stdin) != "q":
    for x in countup(0, COUNT-1):
      for y in countup(0, COUNT-1):
        field.decide_life((x,y))
    field.write()

main()
