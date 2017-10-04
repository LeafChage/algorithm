using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Gene : MonoBehaviour
{
    private readonly int MAX_WAIT = 2 * 60;

    [SerializeField]
    private GameObject block;

    [SerializeField]
    private GameObject thankyou;


    private Renderer[] renderers;
    private Colony generations;
    private int point;
    private Indivisual best_gene;
    private int best_point = 0;
    private GameObject mario;


    private int time = 0;

    void Start()
    {
        renderers = new Renderer[Indivisual.GENE_COUNT];
        generations = new Colony();
        writeGene(Indivisual.CORRECT_GENE, renderers);
    }

    // Update is called once per frame
    void Update()
    {
        time++;
        if (time < MAX_WAIT) return;
        generations.Reviews();
        int best = generations.GetBestGene();
        best_gene = generations.GetIndexColony(best);
        changeGene(best_gene.GetGene(), renderers);
        best_point = best_gene.GetPoint();
        if(best_point >= Indivisual.GENE_COUNT)
        {
            Instantiate(thankyou);
            Debug.Log("thank you");
        }
        generations.Delete();
        generations.MakeChild();
        generations.Mutations();
    }

    #region PRIVATE_METHOD
    private void writeGene(Color[] genes, Renderer[] renderers)
    {
        int x = 0;
        int y = 0;
        int i = 0;
        GameObject tmp;
        foreach (Color c in genes)
        {
            tmp = Instantiate(block, new Vector3(x, y, 0), Quaternion.identity);
            renderers[i] = tmp.GetComponent<Renderer>();
            renderers[i].material.color = c;
            if (x >= Mathf.Sqrt(Indivisual.GENE_COUNT) - 1)
            {
                x = 0;
                y--;
            }
            else
            {
                x++;
            }
            i++;
        }
    }

    private void changeGene(Color[] genes, Renderer[] renderers)
    {
        int i = 0;
        foreach (Renderer r in renderers)
        {
            r.material.color = genes[i];
            i++;
        }
    }
    #endregion

}
