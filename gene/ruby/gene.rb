class Gene
      GENE_COUNT = 18
        #Caramel Frappucchino
      CORRECT_GENE = ['c', 'a', 'r', 'a', 'm', 'e', 'l', 'f', 'r', 'a', 'p', 'p', 'u', 'c', 'h', 'i', 'n', 'o']
      ALPHABET = [
            'a', 'b', 'c', 'd', 'e',
            'f', 'g', 'h', 'i', 'j',
            'k', 'l', 'm', 'n', 'o',
            'p', 'q', 'r', 's', 't',
            'u', 'v', 'w', 'x', 'y', 'z'
      ]
      def initialize()
            @gene = []
            @point = 0
            GENE_COUNT.times do
                  @gene.push(ALPHABET.sample())
            end
      end

      #評価
      def review()
            @point = 0
            @gene.each_with_index do |g, i|
                  if g == CORRECT_GENE[i]
                        @point += 1
                  end

            end
      end

      #突然変異
      def mutation()
            num1 = rand(0..GENE_COUNT)
            num2 = rand(0..GENE_COUNT)
            @gene[num1] = ALPHABET.sample()
            @gene[num2] = ALPHABET.sample()
      end

      #交配
      def self.make_child(mother, father)
            rnd = rand(0..GENE_COUNT)
            child = Gene.new()
            GENE_COUNT.times do |i|
                  if i < rnd
                        m_gene = mother.gene[i]
                        child.gene[i] = mother.gene[i]
                  else
                        f_gene = father.gene[i]
                        child.gene[i] = father.gene[i]
                  end
            end
            return child
      end
      attr_accessor :gene, :point
end


class Colony
      GENERATIONS = 20 #1世代の遺伝子数
      DESTROY = 5 #1世代の淘汰数

      def initialize()
            @colony = []
            GENERATIONS.times do
                  @colony.push(Gene.new())
            end
      end

      #評価
      def reviews()
            @colony.each do |c|
                  c.review()
            end
      end

      #淘汰
      def delete()
            DESTROY.times do
                  s_key = 0
                  s_point = 0
                  @colony.each_with_index do |c, i|
                        if i == 0
                              s_point = c.point
                        elsif s_point > c.point
                              s_key = i
                              s_point = c.point
                        end
                  end
                  @colony.delete_at(s_key)
            end
      end

      #交配
      def make_children()
            DESTROY.times do
                  father = rand(0..GENERATIONS - DESTROY - 1)
                  mother = rand(0..GENERATIONS - DESTROY - 1)
                  child = Gene::make_child(@colony[father], @colony[mother])
                  @colony.push(child)
            end
      end

      def mutations()
            @colony.each do |c|
                  rnd = rand(0..25)
                  if rnd == 1
                        c.mutation()
                  end
            end
      end

      attr_accessor :colony
end


##main処理

generations = Colony.new()

i = 1
while true
      generations.reviews()

      point = 0
      gene_s = ""
      generations.colony.each_with_index do |c, i|
            tmp_s = ""
            c.gene.each do |g|
                  tmp_s += g
            end
            if i == 0
                  point = c.point
                  gene_s = tmp_s
            else
                  point = c.point
                  gene_s = tmp_s
            end
      end
      puts "#{gene_s}: #{point}/ generation: #{i}"
      if point >= Gene::GENE_COUNT
            puts "finish"
            break
      end

      generations.delete()
      generations.make_children()
      generations.mutations()
#      sleep(0.01)
      i += 1
end
