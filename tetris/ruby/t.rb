require 'io/console'
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
      ACTIVE = 2

      def initialize()
            @field = init_field
      end

      def clear()
            @field.each_with_index do |line, y|
                  line.each_with_index do |l, x|
                       @field[y][x] = 0 if l == ACTIVE
                  end
            end
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
                  @field[pos[1]][pos[0]] = WALL
            end
      end

      def pre_fix(now_pos)
            now_pos.each do |pos|
                  @field[pos[1]][pos[0]] = ACTIVE
            end
      end

      def write()
            @field.each do |line|
                  line.each do |l|
                        print (l == 0) ? "_ " : "0 "
                  end
                  print "\n"
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
            block_position
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
            # puts @x
            # puts @y
            puts ""
      end

      private
end


def main()
      field = Field.new()
      field.write()

      current = Current.new(5, 0)
      current.write()

      cmd = 'n'
      thread = Thread::start do
            cmd = STDIN.getch
      end
      500.times do
            if !thread.alive?
                  thread = Thread::start do
                        cmd = STDIN.getch
                  end
            end
            sleep(0.3)
            case cmd
            when 'n'
                  tmp = current.fall
            when 'f' then
                  tmp = current.left
                  cmd = 'n'
            when 'j' then
                  tmp = current.right
                  cmd = 'n'
            when ' ' then
                  tmp = current.rotation
                  cmd = 'n'
            end
            p cmd
            next_pos = tmp.move_position
            # p next_pos
            if !field.are_block?(next_pos)
                  field.pre_fix(next_pos)
                  current = tmp
            else
                  field.fix(current.move_position)
                  current = Current.new(5, 0)
            end
            field.write
            current.write
            field.clear
            if thread.alive?
                  Thread.kill(thread)
            end
      end
end

main()
