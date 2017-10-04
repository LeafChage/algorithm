import Darwin

enum Status{
      case Live
      case Death
}

class Field {
      static let LENGTH = 30
      static let PIONEER = 300
      private var cells: [[Status]];
      init(){
            self.cells = [[Status]](repeating: [Status](repeating: Status.Death, count: Field.LENGTH), count: Field.LENGTH)
      }

      /* public function */
      public func randomBirthday(){
            let max = UInt32(Field.LENGTH)
            for _ in 0 ..< Field.PIONEER {
                  let a = Int(arc4random() % max)
                  let b = Int(arc4random() % max)
                  self._liveCell(x: a, y: b);
            }
      }

      public func run() -> Field {
            let tmp = Field()
            tmp.cells = self.cells
            for y in 0 ..< Field.LENGTH {
                  for x in 0 ..< Field.LENGTH {
                        if self._isLiveCell(x: x, y: y) {
                              tmp._liveCell(x: x, y: y)
                        }else{
                              tmp._deadCell(x: x, y: y)
                        }
                  }
            }
            return tmp
      }

      public func write() {
            var text = "";
            for line in self.cells {
                  for l in line {
                        text += (l == Status.Live) ? "o " : "_ "
                  }
                  text += "\n"
            }
            print(text)
      }

      /* private function */
      private func _isLiveCell(x: Int, y: Int) -> Bool {
            let neighbor_count = self._getNeighborsCount(x: x, y: y)
            if self._isExist(x: x, y: y){
                  return !(self._isUnderPopulation(count: neighbor_count) || self._isOverPopulation(count: neighbor_count))
            }else{
                  return self._isJustPopulation(count: neighbor_count)
            }
      }


      private func _liveCell(x: Int, y: Int){
            self.cells[y][x] = Status.Live;
      }
      private func _deadCell(x: Int, y: Int){
            self.cells[y][x] = Status.Death;
      }

      private func _getNeighborsCount(x: Int, y: Int) -> Int {
            var result = 0
            if self._isNotOutOfField(num: x-1) && self._isNotOutOfField(num: y-1) && self._isExist(x: x-1, y: y-1){ result += 1 }
            if self._isNotOutOfField(num: y-1) && self._isExist(x: x, y: y-1){ result += 1 }
            if self._isNotOutOfField(num: x+1) && self._isNotOutOfField(num: y-1) && self._isExist(x: x+1, y: y-1){ result += 1 }
            if self._isNotOutOfField(num: x-1) && self._isExist(x: x-1, y: y){ result += 1 }
            if self._isNotOutOfField(num: x+1) && self._isExist(x: x+1, y: y){ result += 1 }
            if self._isNotOutOfField(num: x-1) && self._isNotOutOfField(num: y+1) && self._isExist(x: x-1, y: y+1){ result += 1 }
            if self._isNotOutOfField(num: y+1) && self._isExist(x: x, y: y+1){ result += 1 }
            if self._isNotOutOfField(num: x+1) && self._isNotOutOfField(num: y+1) && self._isExist(x: x+1, y: y+1){ result += 1 }
            return result
      }

      private func _isUnderPopulation(count: Int) -> Bool {
            return count == 0 || count == 1
      }

      private func _isOverPopulation(count: Int) -> Bool {
            return count >= 4
      }

      private func _isJustPopulation(count: Int) -> Bool {
            return count == 3
      }

      private func _isExist(x: Int, y: Int) -> Bool {
            return self.cells[y][x] == Status.Live
      }

      private func _isNotOutOfField(num: Int) -> Bool {
            return self._overZero(num: num) && self._underCount(num: num)
      }

      private func _overZero(num: Int) -> Bool {
            return num >= 0
      }

      private func _underCount(num: Int) -> Bool {
            return num < Field.LENGTH
      }
}




func main(){
      var field = Field()
      field.randomBirthday()
      field.write()
      for _ in 0..<500 {
            usleep(UInt32(20000))
            field = field.run()
            field.write()
      }
}

main()
