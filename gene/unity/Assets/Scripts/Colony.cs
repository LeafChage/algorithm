using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Colony {
    public static readonly int GENERATION = 400;
    public static readonly int DESTROY = 100;

    private List<Indivisual> colony;
    public Colony()
    {
        colony = new List<Indivisual>();
        initColony(colony);
    }

    #region PUBLIC_METHOD
    public List<Indivisual> GetColony()
    {
        return colony;
    }

    public Indivisual GetIndexColony(int index)
    {
        return colony[index];
    }

    public void Reviews()
    {
        foreach(Indivisual g in colony)
        {
            g.Review();
        }
    }

    public void Delete()
    {
        for (int i = 0; i < DESTROY; i++){
            int s_key = 0;
            int s_point = 0;
            int j = 0;
            foreach(Indivisual g in colony)
            {
                int point = g.GetPoint();
                if(j == 0)
                {
                    s_point = point;
                }
                else if(point < s_point)
                {
                    s_key = j;
                    s_point = point;
                }
                j++;
            }
            colony.RemoveAt(s_key);
        }
    }

    public void MakeChild()
    {
        for(int i = 0; i < DESTROY; i++)
        {
            int father = Random.Range(0, GENERATION - DESTROY);
            int mother = Random.Range(0, GENERATION - DESTROY);
            Indivisual child = Indivisual.MakeChild(colony[father], colony[mother]);
            colony.Add(child);
        }
    }

    public void Mutations()
    {
        foreach(Indivisual g in colony)
        {
            int rnd = Random.Range(0, 15);
            if (rnd == 1)
            {
                g.Mutation();
            }

        }
    }

    public int GetBestGene()
    {
        int max_key = 0;
        int max_point = 0;
        int i = 0;
        foreach(Indivisual g in colony)
        {
            int point = g.GetPoint();
            if (i == 0)
            {
                max_point = point;
            }
            else if (point > max_point)
            {
                max_key = i;
                max_point = point;
            }
            i++;
        }
        return max_key;
    }
    #endregion

    #region PRIVATE_METHOD
    private void initColony(List<Indivisual> colony)
    {
        for(int i = 0; i < GENERATION; i++)
        {
            colony.Add(new Indivisual());
        }
    }
    #endregion
}

