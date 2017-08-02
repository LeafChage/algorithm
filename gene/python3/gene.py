import random

class Gene:
    GENE_COUNT = 18
    CORRECT_GENE = ['c', 'a', 'r', 'a', 'm', 'e', 'l', 'f', 'r', 'a', 'p', 'p', 'u', 'c', 'h', 'i', 'n', 'o']
    ALPHABET = [
            'a', 'b', 'c', 'd', 'e',
            'f', 'g', 'h', 'i', 'j',
            'k', 'l', 'm', 'n', 'o',
            'p', 'q', 'r', 's', 't',
            'u', 'v', 'w', 'x', 'y', 'z'
            ]
    def __init__(self):
        self.__gene = []
        self.__point = 0
        for _ in range(self.GENE_COUNT):
            self.__gene.append(random.choice(self.ALPHABET))

    def get_gene(self): return self.__gene
    def get_gene_index(self, index): return self.__gene[index]
    def set_gene_index(self, index, value): self.__gene[index] = value
    def get_point(self): return self.__point
    def set_point(self, point): self.__point = point

    def review(self):
        self.__point = 0
        i = 0
        for g in self.__gene:
            if g == self.CORRECT_GENE[i]: self.__point += 1
            i += 1

    def mutation(self):
        num1 = random.randint(0, self.GENE_COUNT - 1)
        num2 = random.randint(0, self.GENE_COUNT - 1)
        self.__gene[num1] = random.choice(self.ALPHABET)
        self.__gene[num2] = random.choice(self.ALPHABET)

    @staticmethod
    def make_child(father, mother):
        rnd = random.randint(0, Gene.GENE_COUNT - 1)
        child = Gene()
        for i in range(Gene.GENE_COUNT):
            if i > rnd:
                mother_g = mother.get_gene_index(i)
                child.set_gene_index(i, mother_g)
            else:
                father_g = father.get_gene_index(i)
                child.set_gene_index(i, father_g)
        return child


class Colony:
    GENERATION = 20
    DESTROY = 5

    def __init__(self):
        self.__colony = []
        for _ in range(self.GENERATION ):
            self.__colony.append(Gene())

    def get_colony(self): return self.__colony;

    def reviews(self):
        for c in self.__colony:
            c.review()

    def delete(self):
        for _ in range(self.DESTROY):
            s_key = 0
            s_point = 0
            i = 0
            for c in self.__colony:
                point = c.get_point()
                if i == 0:
                    s_point = point
                elif s_point > point:
                    s_key = i
                    s_point = point
                i += 1
        pass

    def make_children(self):
        for _ in range(len(self.__colony)):
            father = random.randint(0, self.GENERATION - self.DESTROY - 1)
            mother = random.randint(0, self.GENERATION - self.DESTROY - 1)
            child = Gene.make_child(self.__colony[father], self.__colony[mother])
            self.__colony.append(child)

    def mutations(self):
        for c in self.__colony:
            rnd = random.randint(0, 25)
            if rnd == 1:
                c.mutation()

def main():
    generations = Colony()
    i = 1
    while True:
        generations.reviews()

        point = 0
        genes_s = ""
        for c in generations.get_colony():
            tmp_s = ""
            for g in c.get_gene():
                tmp_s += g

            point = c.get_point()
            gene_s = tmp_s
            print(gene_s, point, "generations:", i)
            if point >= Gene.GENE_COUNT:
                print("finish")
                break

            generations.delete()
            generations.make_children()
            generations.mutations()
            i += 1

if __name__ == '__main__':
    main()




















