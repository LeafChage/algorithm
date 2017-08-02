class Queen
      def initialize(_queen)
            @queen = _queen
            @count = 0
            @result = Array.new(_queen, nil)
      end

      def queen(y = 0)
            @queen.times do |x|
                  init_array(y)
                  next if !can_put?(x, y)
                  put(x, y)
                  if y == @queen - 1
                        @count += 1
                        write()
                  else
                        queen(y + 1)
                  end
            end
      end

      private
      #自分がいる行以下のqueen初期化
      def init_array(y)
            i = 0
            while i < @queen
                  @result[i] = nil if i >= y
                  i += 1
            end
      end

      #置けるか確認
      def can_put?(x, y)
            return @result[y].nil? && !@result.include?(x) && slant_check(x, y)
      end

      #斜めのチェック
      def slant_check(x, y)
            tmp1 = y - x
            tmp2 = y + x
            @result.each_with_index do |_x, _y|
                  next if _x.nil?
                  if _y == _x + tmp1 ||  _y == (-_x) + tmp2
                        return false
                  end
            end
            return true
      end

      def write()
            @queen.times do |y|
                  line = ""
                  @queen.times do |x|
                        line +=  @result[y] == x ? "Q " : ". "
                  end
                  puts line
            end
            p @count
      end

      def put(x, y)
            @result[y] = x
      end
end

# n = gets().to_i
# p n
q = Queen.new(8)
q.queen()

#4 -> 2
#5 -> 10
