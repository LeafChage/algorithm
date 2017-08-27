require 'io/console'

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
      FIX = 3
      ACTIVE = 2
      FINISH_COUNT = 40
      WALL_CHAR = "□ "
      BLOCK_CHAR = "■ "
      NONE_CHAR = "  "
      attr_reader :point

      def initialize()
            @field = init_field
            @point  = 0
      end
      def clear()
            @field.each_with_index do |line, y|
                  line.each_with_index do |l, x|
                       @field[y][x] = 0 if l == ACTIVE
                  end
            end
      end

      def line_clear()
            @field.each_with_index do |line, y|
                  if line == [WALL, FIX, FIX, FIX, FIX, FIX, FIX, FIX, FIX, FIX, WALL]
                        @point += 1
                        @field.delete_at(y)
                        @field.insert(0, [WALL, NONE, NONE, NONE, NONE, NONE, NONE, NONE, NONE, NONE, WALL])
                  end
            end
      end

      def game_finish?()
            @point >= 40
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
                  @field[pos[1]][pos[0]] = FIX
            end
      end

      def pre_fix(now_pos)
            now_pos.each do |pos|
                  @field[pos[1]][pos[0]] = ACTIVE
            end
      end

      def write()
            text = "\n\e[25D"
            @field.each do |line|
                  line.each do |l|
                        if l == NONE
                              text += NONE_CHAR
                        elsif l == ACTIVE || l == FIX
                              text += BLOCK_CHAR
                        else
                              text += WALL_CHAR
                        end
                  end
                  text += "\n\e[25D"
            end
            puts text
      end

      private
      def is_block?(x, y)
            @field[y][x] == WALL || @field[y][x] == FIX
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
            tmp = Array.new(4){ Array.new(4, 0)}
            #転置させて、行の順番をひっくりかえす
            @current.each_with_index do |line, y|
                  line.each_with_index do |l, x|
                        tmp[x][y] = l
                  end
            end
            tmp.each_with_index do |line, i|
                  tmp[i] = line.reverse
            end
            Current.new(@x, @y, tmp)
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

def display_clear()
      print "\x1b[2J\x1b[0;0H"
end

def main()
      display_clear()

      field = Field.new()
      field.write()

      current = Current.new(5, 0)
      current.write()

      cmd = 'n'
      thread = Thread::start do
            while (cmd = STDIN.getch)
                  if cmd ==  "\C-c"
                        break
                  end
            end
      end
      loop do
            sleep(0.2)
            display_clear()
            puts "left: f, right: j, rotate: space\e[25D"
            puts "\e[25D#{field.point}\e[25D"
            case cmd
            when 'f' then
                  tmp = current.left
            when 'j' then
                  tmp = current.right
            when ' ' then
                  tmp = current.rotation
            else
                  tmp = current.fall
            end
            next_pos = tmp.move_position
            # p next_pos
            if !field.are_block?(next_pos)
                  field.pre_fix(next_pos)
                  current = tmp
            elsif cmd != 'n'
                  current = current
            else
                  field.fix(current.move_position)
                  current = Current.new(5, 0)
                  next_pos = current.move_position
                  if field.are_block?(next_pos)
                        puts "game over"
                        break
                  end
            end
            field.write
            field.clear
            field.line_clear
            cmd = 'n'
            if field.game_finish?()
                  puts "success!!!!!!"
                  break
            end
      end
      Thread.kill(thread)
end

main()
