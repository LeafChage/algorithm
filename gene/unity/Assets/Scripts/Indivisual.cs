using UnityEngine;

public class BW
{
    public static Color A = new Color(0.0f, 0.0f, 0.0f);
    public static Color B = new Color(0.1f, 0.1f, 0.1f);
    public static Color C = new Color(0.2f, 0.2f, 0.2f); //cha
    public static Color D = new Color(0.3f, 0.3f, 0.3f);
    public static Color E = new Color(0.4f, 0.4f, 0.4f); //blue
    public static Color F = new Color(0.5f, 0.5f, 0.5f);
    public static Color G = new Color(0.6f, 0.6f, 0.6f); //red
    public static Color H = new Color(0.7f, 0.7f, 0.7f); //skin
    public static Color I = new Color(0.8f, 0.8f, 0.8f);
    public static Color J = new Color(0.9f, 0.9f, 0.9f);
    public static Color K = new Color(1.0f, 1.0f, 1.0f);
}

public class Indivisual
{
    public readonly static int GENE_COUNT = 18 * 18;
    public readonly static Color[] CORRECT_GENE = new Color[] {
        BW.K, BW.K, BW.K, BW.K, BW.K, BW.K, BW.K, BW.K, BW.K, BW.K, BW.K, BW.K, BW.K, BW.K, BW.K, BW.K, BW.K, BW.K,
        BW.K, BW.K, BW.K, BW.K, BW.K, BW.K, BW.G, BW.G, BW.G, BW.G, BW.G, BW.K, BW.K, BW.K, BW.K, BW.K, BW.K, BW.K,
        BW.K, BW.K, BW.K, BW.K, BW.K, BW.G, BW.G, BW.G, BW.G, BW.G, BW.G, BW.G, BW.G, BW.G, BW.K, BW.K, BW.K, BW.K,
        BW.K, BW.K, BW.K, BW.K, BW.K, BW.C, BW.C, BW.C, BW.H, BW.H, BW.A, BW.H, BW.K, BW.K, BW.K, BW.K, BW.K, BW.K,
        BW.K, BW.K, BW.K, BW.K, BW.C, BW.H, BW.C, BW.H, BW.H, BW.H, BW.A, BW.H, BW.H, BW.H, BW.K, BW.K, BW.K, BW.K,
        BW.K, BW.K, BW.K, BW.K, BW.C, BW.H, BW.C, BW.C, BW.H, BW.H, BW.H, BW.A, BW.H, BW.H, BW.H, BW.K, BW.K, BW.K,
        BW.K, BW.K, BW.K, BW.K, BW.K, BW.C, BW.H, BW.H, BW.H, BW.H, BW.A, BW.A, BW.A, BW.A, BW.K, BW.K, BW.K, BW.K,
        BW.K, BW.K, BW.K, BW.K, BW.K, BW.K, BW.H, BW.H, BW.H, BW.H, BW.H, BW.H, BW.K, BW.K, BW.K, BW.K, BW.K, BW.K,
        BW.K, BW.K, BW.K, BW.K, BW.K, BW.G, BW.G, BW.E, BW.G, BW.G, BW.E, BW.G, BW.G, BW.K, BW.K, BW.K, BW.K, BW.K,
        BW.K, BW.K, BW.K, BW.K, BW.G, BW.G, BW.G, BW.E, BW.G, BW.G, BW.E, BW.G, BW.G, BW.G, BW.K, BW.K, BW.K, BW.K,
        BW.K, BW.K, BW.K, BW.G, BW.G, BW.G, BW.G, BW.E, BW.E, BW.E, BW.E, BW.G, BW.G, BW.G, BW.G, BW.K, BW.K, BW.K,
        BW.K, BW.K, BW.K, BW.H, BW.H, BW.G, BW.E, BW.H, BW.E, BW.E, BW.H, BW.E, BW.G, BW.H, BW.H, BW.K, BW.K, BW.K,
        BW.K, BW.K, BW.K, BW.H, BW.H, BW.H, BW.E, BW.E, BW.E, BW.E, BW.E, BW.E, BW.H, BW.H, BW.H, BW.K, BW.K, BW.K,
        BW.K, BW.K, BW.K, BW.H, BW.H, BW.E, BW.E, BW.E, BW.E, BW.E, BW.E, BW.E, BW.E, BW.H, BW.H, BW.K, BW.K, BW.K,
        BW.K, BW.K, BW.K, BW.K, BW.K, BW.E, BW.E, BW.E, BW.K, BW.K, BW.E, BW.E, BW.E, BW.K, BW.K, BW.K, BW.K, BW.K,
        BW.K, BW.K, BW.K, BW.K, BW.C, BW.C, BW.C, BW.K, BW.K, BW.K, BW.K, BW.C, BW.C, BW.C, BW.K, BW.K, BW.K, BW.K,
        BW.K, BW.K, BW.K, BW.C, BW.C, BW.C, BW.C, BW.K, BW.K, BW.K, BW.K, BW.C, BW.C, BW.C, BW.C, BW.K, BW.K, BW.K,
        BW.K, BW.K, BW.K, BW.K, BW.K, BW.K, BW.K, BW.K, BW.K, BW.K, BW.K, BW.K, BW.K, BW.K, BW.K, BW.K, BW.K, BW.K,
    };
    private Color[] color_set = new Color[] { BW.A, BW.B, BW.C, BW.D, BW.E, BW.F, BW.G, BW.H, BW.I, BW.J, BW.K, };

    private Color[] gene;
    private int point;
    public Indivisual()
    {
        point = 0;
        gene = new Color[GENE_COUNT];
        initGene(gene);
    }

    #region PUBLIC_METHOD
    public int GetPoint()
    {
        return point;
    }

    public Color[] GetGene()
    {
        return gene;
    }

    public Color GetIndexGene(int index)
    {
        return gene[index];
    }

    public void SetIndexGene(int index, Color value)
    {
        gene[index] = value;
    }

    //突然変異
    public void Mutation()
    {
        int rnd1 = Random.Range(0, GENE_COUNT);
        int rnd2 = Random.Range(0, color_set.Length);
        gene[rnd1] = color_set[rnd2];
    }

    //評価
    public void Review()
    {
        point = 0;
        int i = 0;
        foreach (Color g in gene)
        {
            if (g == CORRECT_GENE[i])
            {
                point++;
            }
            i++;
        }
    }
    #endregion

    #region PRIVATE_METHOD
    private void initGene(Color[] gene)
    {
        for (int i = 0; i < GENE_COUNT; i++)
        {
            int rnd = Random.Range(0, color_set.Length);
            gene[i] = color_set[rnd];
        }
    }
    #endregion

    #region STATIC_METHOD
    public static Indivisual MakeChild(Indivisual father, Indivisual mother)
    {
        int rnd = Random.Range(0, GENE_COUNT);
        Indivisual child = new Indivisual();
        for(int i = 0; i < GENE_COUNT; i++)
        {
            if(i > rnd)
            {
                child.SetIndexGene(i, mother.GetIndexGene(i));
            }
            else
            {
                child.SetIndexGene(i, father.GetIndexGene(i));
            }
        }

        return child;
    }
    #endregion


}
