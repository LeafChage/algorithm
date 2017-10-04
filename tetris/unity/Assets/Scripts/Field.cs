using UnityEngine;

public class Field
{
    public enum BlockStatus
    {
        None,
        Wall,
        Active,
        Fix,
    }

    public static readonly int HEIGHT = 22;
    public static readonly int WIDTH = 12;
    private readonly int FINISH_POINT = 40;

    private BlockStatus[][] fields;
    private int point = 0;

    public Field()
    {
        point = 0;
        fields = new BlockStatus[HEIGHT][];
        initArray(fields);
        initField(fields);
    }
    
    #region PUBLIC_METHOD
    public int GetPoint() { return point; }

    public BlockStatus[][] GetFields() { return fields; }

    //複数の場所にブロックがすでにあるか確認　ある -> true
    public bool AreWallOrFix(int[][] next_position)
    {
        bool flag = false;
        for (int i = 0; i < next_position.Length; i++)
        {
            if (isWallOrFix(next_position[i][0], next_position[i][1]))
            {
                flag = true;
            }
        }
        return flag;
    }

    //終了 -> true
    public bool IsFinishGame()
    {
        return point > FINISH_POINT;
    }

    //activeを消してfix, wall, noneのみにする
    public void Reflash()
    {
        for (int y = 0; y < HEIGHT; y++)
        {
            for (int x = 0; x < WIDTH; x++)
            {
                fields[y][x] = (fields[y][x] == BlockStatus.Active) ? BlockStatus.None : fields[y][x];
            }
        }
    }

    //一列そろっている行を削除する
    public void DeleteCompleteLine()
    {
        for (int y = 0; y < HEIGHT; y++)
        {
            if (isDeleteLine(fields[y]))
            {
                deleteLine(fields, y);
                addPoint();
            }
        }
    }

    //確定
    public void Fix(int[][] pos)
    {
        for(int i = 0; i < pos.Length; i++)
        {
            int x = pos[i][0];
            int y = pos[i][1];
            fields[y][x] = BlockStatus.Fix;
        }
    }

    //まだアクティブだが、一時的に確定
    public void PreFix(int[][] pos)
    {
        for(int i = 0; i < pos.Length; i++)
        {
            int x = pos[i][0];
            int y = pos[i][1];
            fields[y][x] = BlockStatus.Active;
        }
    }
    #endregion

    #region PRIVATE_METHOD
    private void initArray(BlockStatus[][] fields)
    {
        for(int i = 0; i < HEIGHT; i++)
        {
            fields[i] = new BlockStatus[WIDTH];
        }
    }

    private void initField(BlockStatus[][] fields)
    {
        for (int y = 0; y < HEIGHT; y++)
        {
            if (y == HEIGHT - 1)
            {
                setWallLine(fields, y);
            }
            else
            {
                setNewLine(fields, y);
            }
        }
    }

    //指定された行に何もない一行を入れる
    private void setNewLine(BlockStatus[][] fields, int index)
    {
        for (int x = 0; x < WIDTH; x++)
        {
            fields[index][x] = (x == 0 || x == WIDTH - 1) ? BlockStatus.Wall : BlockStatus.None;
        }
    }

    //指定された行に壁の一行をいれる
    private void setWallLine(BlockStatus[][] fields, int index)
    {
        for (int x = 0; x < WIDTH; x++)
        {
            fields[index][x] = BlockStatus.Wall;
        }
    }

    //場所にブロックがすでにあるか確認 ある -> true
    private bool isWallOrFix(int x, int y)
    {
        return (fields[y][x] == BlockStatus.Wall || fields[y][x] == BlockStatus.Fix);
    }

    private void addPoint()
    {
        point++;
    }

    //そのラインを消してもいいかどうか
    private bool isDeleteLine(BlockStatus[] line)
    {
        bool flag = true;
        for(int x = 0; x < line.Length; x++)
        {
            if(x == 0 || x == line.Length - 1)
            {
                if(line[x] != BlockStatus.Wall)
                {
                    flag = false;
                }
            }
            else
            {
                if(line[x] != BlockStatus.Fix)
                {
                    flag = false;
                }
            }
        }
        return flag;
    }

    //実際にラインを消す
    private void deleteLine(BlockStatus[][] fields, int delete_index)
    {
        BlockStatus[][] tmp = new BlockStatus[fields.Length][];
        BlockStatus[] new_line = new BlockStatus[fields[0].Length];
        createNewLine(new_line);
        tmp[0] = new_line;
        int new_y = 1;
        for(int y = 0; y < fields.Length; y++)
        {
            if(y != delete_index)
            {
                tmp[new_y] = fields[y];
                new_y++;
            }
        }
        tmp.CopyTo(fields, 0);
    }

    //新しいラインをつくる
    private void createNewLine(BlockStatus[] line)
    {
        for (int i = 0; i < line.Length; i++)
        {
            if (i == 0 || i == line.Length - 1)
            {
                line[i] = BlockStatus.Wall;
            }
            else
            {
                line[i] = BlockStatus.None;
            }
        }
    }
    #endregion
}
