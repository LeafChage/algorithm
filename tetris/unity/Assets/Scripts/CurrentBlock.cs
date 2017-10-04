using System.Linq;
using UnityEngine;

public class CurrentBlock
{
    private readonly int[][][] BLOCKS = new int[7][][] {
        new int[4][] { new int[]{0, 1, 0, 0}, new int[]{1, 1, 1, 0}, new int[]{0, 0, 0, 0}, new int[]{0, 0, 0, 0}, },
        new int[4][] { new int[]{0, 1, 1, 0}, new int[]{1, 1, 0, 0}, new int[]{0, 0, 0, 0}, new int[]{0, 0, 0, 0}, },
        new int[4][] { new int[]{1, 1, 0, 0}, new int[]{0, 1, 1, 0}, new int[]{0, 0, 0, 0}, new int[]{0, 0, 0, 0}, },
        new int[4][] { new int[]{1, 1, 1, 1}, new int[]{0, 0, 0, 0}, new int[]{0, 0, 0, 0}, new int[]{0, 0, 0, 0}, },
        new int[4][] { new int[]{1, 1, 0, 0}, new int[]{1, 1, 0, 0}, new int[]{0, 0, 0, 0}, new int[]{0, 0, 0, 0}, },
        new int[4][] { new int[]{1, 0, 0, 0}, new int[]{1, 1, 1, 0}, new int[]{0, 0, 0, 0}, new int[]{0, 0, 0, 0}, },
        new int[4][] { new int[]{0, 0, 1, 0}, new int[]{1, 1, 1, 0}, new int[]{0, 0, 0, 0}, new int[]{0, 0, 0, 0}, },
        };
    private int x = 0;
    private int y = 0;
    private int[][] current = new int[4][];

    public CurrentBlock(int _x, int _y)
    {
        x = _x;
        y = _y;
        current = createBlock();
    }
    CurrentBlock(int _x, int _y, int[][] _current)
    {
        x = _x;
        y = _y;
        current = _current;
    }

    #region PUBLIC_METHOD
    public CurrentBlock MoveRight()
    {
        return new CurrentBlock(x+1, y, current);
    }

    public CurrentBlock MoveLeft()
    {
        return new CurrentBlock(x-1, y, current);
    }

    public CurrentBlock Rotate()
    {
        int[][] tmp = new int[4][] { new int[4], new int[4], new int[4], new int[4] } ;
        for(int i = 0; i < current.Length; i++)
        {
            for (int j = 0; j < current.Length; j++)
            {
                tmp[i][j] = current[j][i];
            }
        }

        for(int i = 0; i < current.Length; i++)
        {
            System.Array.Reverse(tmp[i]);
        }
        return new CurrentBlock(x, y, tmp);
    }

    //一つずつ落ちる
    public CurrentBlock Fall()
    {
        return new CurrentBlock(x, y+1, current);
    }

    public int[][] MovePosition()
    {
        int[][] next_position = new int[4][];
        int count = 0;
        
        for(int _y = 0; _y < current.Length; _y++)
        {
            for (int _x = 0; _x < current.Length; _x++)
            {
                if(current[_y][_x] == 1)
                {
                    next_position[count] = new int[2] { x + _x, y + _y};
                    count++;
                }
            }
        }

        return next_position;
    }
    #endregion

    #region PRIVATE_METHOD
    //新しいブロックを作る
    private int[][] createBlock()
    {
        int rnd = Random.Range(0, BLOCKS.Length);
        return BLOCKS[rnd];
    }
    #endregion
}
