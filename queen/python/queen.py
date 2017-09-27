class Queen():
    def __init__(self, num):
        self._num = num
        self._count = 0
        self._result = [-1 for i in range(num)]

    #メイン処理
    def run(self, y = 0):
        for x in range(self._num):
            self._init_array(y)
            if self._can_put(x, y) == False: continue
            self._put(x, y)
            if y == self._num - 1:
                self._count += 1
                self._write()
            else:
                self.run(y+1)

    def get_count(self):
        return self._count


    #今チェックしている行以下を初期化
    def _init_array(self, y):
        i = 0
        for i in range(self._num):
            if i >= y: self._result[i] = -1

    # そこにおけるかどうかのチェック:
    def _can_put(self, x, y):
        return (self._result[y] == -1) and (not x in self._result) and (self._slant_check(x, y))

    # 斜めのチェック
    def _slant_check(self, x, y):
        check = True
        tmp1 = y - x
        tmp2 = y + x
        _y = 0
        for _x in self._result:
            if _x == -1: continue
            if _y == _x + tmp1 or  _y == (-_x) + tmp2:
                check = False
            _y += 1
        return check

    #描画
    def _write(self):
        for y in range(self._num):
            line = ""
            for x in range(self._num):
                line += "Q " if self._result[y] == x else ". "
            print(line)
        print("\n")

    # 配列に含まれているかのチェック:
    def _is_include(self, x):
        check = False
        for r in self._result:
            if r == x: check = True
        return check

    def _put(self, x, y):
        self._result[y] = x

def main():
    q = Queen(4)
    q.run()
    print("point: ", q.get_count())

if __name__ == '__main__':
    main()

