#途中

BLOCKS = [
      [ [0, 1, 0],
        [1, 1, 1] ],

      [ [0, 1, 1],
        [1, 1, 0] ],

      [ [1, 1, 0],
        [0, 1, 1] ],

      [ [1, 1, 1, 1], ],

      [ [1, 1],
        [1, 1] ],

      [ [1, 0, 0],
        [1, 1, 1] ],

      [ [0, 0, 1],
        [1, 1, 1] ],
]

class Field
      WIDTH = 11
      HEIGHT = 20
      WALL = 1
      NONE = 0

      def initialize()
            @field = init_field
      end

      def are_block?(next_pos)
            result = false
            next_pos.each do |pos|
                  if is_block?(pos[0], pos[1])
                        result = true
                  end
            end

            result
      end

      def fix(now_pos)
            now_pos.each do |pos|
                  @field[pos[0]][pos[1]] = 1
            end
      end

      def write()
            @field.each do |line|
                  p line
            end
            puts ""
      end

      private
      def is_block?(x, y)
            @field[y][x] == WALL
      end

      def init_field
            f = []
            HEIGHT.times do |i|
                  line = []
                  WIDTH.times do |j|
                        line[j] = (j == 0 || j == WIDTH - 1 || i == HEIGHT - 1) ? WALL : NONE
                  end
                  f[i] = line
            end
            return f
      end
end

class Current
      def initialize(x, y, current = new_block)
            @x = x
            @y = y
            @current = current
      end

      def move_position()
            count = 0
            block_position = Array.new(4)
            @current.each_with_index do |block, y|
                  block.each_with_index do |b, x|
                        if b == 1
                              block_position[count] = [ @x + x, @y + y ]
                              count += 1
                        end
                  end
            end
      end

      def right()
            Current.new(@x + 1, @y, @current)
      end

      def left()
            Current.new(@x - 1, @y, @current)
      end

      def fall()
            Current.new(@x, @y + 1, @current)
      end

      def rotation()
      end

      def new_block()
            rnd = rand(BLOCKS.length)
            block = BLOCKS[rnd]

            current = Array.new(4){ Array.new(4, 0)}
            block.each_with_index do |line, i|
                  line.each_with_index do |l, j|
                        if l == 1
                              current[i][j] = 1
                        end
                  end
            end
            current
      end

      def write()
            @current.each do |line|
                  p line
            end
            puts ""
      end

      private
end


def main()
      field = Field.new()
      field.write()

      current = Current.new(5, 0)
      current.write()

      500.times do
            tmp = current.fall
            next_pos = tmp.move_position
            if !field.are_block?(next_pos)
                  current = tmp
            else
                  field.fix(current.move_position)
                  current = Current.new(5, 0)
            end
            field.write
      end
end

main()
