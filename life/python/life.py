import random

COUNT = 20
LIVE = 'o '
DEATH = '_ '
PIONEER = 100

class Field:
    def __init__(self):
        self._cells = [[DEATH for i in range(COUNT)] for j in range(COUNT)]

    def random_birthday(self):
        for i in range(PIONEER):
            self._cells[random.randint(0, COUNT - 1)][random.randint(0, COUNT - 1)] = LIVE

    def decide_life(self, x, y):
        neighbor_count = self._get_neighbors_count(x, y)
        if self._is_exists(x, y):
            if self._is_under_population(neighbor_count) or self._is_over_population(neighbor_count):
                self._death_cell(x, y)
        else:
            if self._is_just_population(neighbor_count):
                self._live_cell(x, y)

    def write(self):
        for line in self._cells:
            for l in line:
                print(l, end="")
            print("")
        print("")


    def _is_under_population(self, count):
        return count == 0 or count == 1

    def _is_over_population(self, count):
        return count >= 4

    def _is_just_population(self, count):
        return count == 3

    def _live_cell(self, x, y):
        self._cells[x][y] = LIVE

    def _death_cell(self, x, y):
        self._cells[x][y] = DEATH

    def _is_exists(self, x, y):
        return self._cells[x][y] == LIVE

    def _get_neighbors_count(self, x, y):
        result = 0
        if self._over0(x-1) and self._over0(y-1) and self._is_exists(x-1, y-1): result += 1
        if self._over0(y-1) and self._is_exists(x, y-1): result += 1
        if self._under_count(x+1) and self._over0(y-1) and self._is_exists(x+1, y-1): result += 1
        if self._over0(x-1) and self._is_exists(x-1, y): result += 1
        if self._under_count(x+1) and self._is_exists(x+1, y): result += 1
        if self._over0(x-1) and self._under_count(y+1) and self._is_exists(x-1, y+1): result += 1
        if self._under_count(y+1) and self._is_exists(x, y+1): result += 1
        if self._under_count(x+1) and self. _under_count(y+1) and self._is_exists(x+1, y+1): result += 1
        return result

    def _over0(self, num):
        return num >= 0

    def _under_count(self, num):
        return num < COUNT


def main():
    field = Field()
    field.random_birthday()
    field.write()
    i = 0
    while i < 500:
        for x in range(COUNT - 1):
            for y in range(COUNT - 1):
                field.decide_life(x, y)
        field.write()
        i += 1

if __name__ == "__main__":
    main()
