using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class Tetris : MonoBehaviour {
    [SerializeField] private GameObject default_object;
    [SerializeField] private GameObject ending_obj;
    [SerializeField] private Text text;

    private Field field;
    private GameObject[][] field_blocks;
    private CurrentBlock current;
    private int wait_time = 0;
    private bool button_on = false;
    private CurrentBlock tmp;
    private bool finish = false;
    private float time = 0;
    private List<int> outputBlockIndex;

    private Color None = new Color(0, 0, 0, 0);
    private Color Active = Color.green;
    private Color Fix = Color.green;
    private Color Wall = Color.black;

	void Start () {
        outputBlockIndex = new List<int>();
        finish = false;
        wait_time = 0;
        time = 0;

        field = new Field();
        field_blocks = new GameObject[Field.HEIGHT][];
        current = new CurrentBlock(5, 0);

        initArray(field_blocks);
        createField(field.GetFields());
        updateField(field.GetFields(), field_blocks);

        initSetting();
	}

    void Update () {
        time += Time.deltaTime;
        if(time < 3){
            return;
        }

        if (finish) return;
        if (Input.GetKeyDown(KeyCode.P))
        {
            Debug.Log(field.GetPoint());
        }
        // if(Application.isEditor){
        //     inputButton(ref tmp);
        // }else{
        inputTouch(ref tmp);
        // }
        updateUi();

        wait_time++;
        if (wait_time < Setting.Time)
        {
            return;
        }
        else
        {
            wait_time = 0;
        }

        if (field.IsFinishGame())
        {
            Debug.Log("finish");
            end(true);
        }

        int[][] next_pos = tmp.MovePosition();

        if (!field.AreWallOrFix(next_pos))
        {
            field.PreFix(next_pos);
            current = tmp;
        }
        else
        {
            if (!button_on)
            {
                field.Fix(current.MovePosition());
                current = new CurrentBlock(5, 0);
                next_pos = current.MovePosition();
                if (field.AreWallOrFix(next_pos))
                {
                    Debug.Log("game over");
                    end(false);
                }
            }
        }

        initSetting();

        updateField(field.GetFields(), field_blocks);
        field.Reflash();
        field.DeleteCompleteLine();
    }

    #region PUBLIC_METHOD
    #endregion

    #region PRIVATE_METHOD
    private void updateUi(){
        text.text = field.GetPoint().ToString();
    }


    //入力をとって動作まで
    private void inputButton(ref CurrentBlock tmp)
    {
        if (Input.GetKeyDown(KeyCode.RightArrow))
        {
            Debug.Log("right");
            tmp = current.MoveRight();
            button_on = true;
        }
        else if (Input.GetKeyDown(KeyCode.LeftArrow))
        {
            Debug.Log("left");
            tmp = current.MoveLeft();
            button_on = true;
        }
        else if (Input.GetKeyDown(KeyCode.Space))
        {
            Debug.Log("rotate");
            tmp = current.Rotate();
            button_on = true;

            transform.Rotate(new Vector3(0f, 0f, 90f));
        }
        else if (Input.GetKeyDown(KeyCode.DownArrow))
        {
            Debug.Log("under");
            moveUnder(ref tmp);
            button_on = true;
        }
    }
    private void inputTouch(ref CurrentBlock tmp){
        Vector2 pos = touchPoint();
        if (pos == Vector2.zero)
        {
            return;
        }
        else if (pos.y > Screen.height * 0.2f)
        {
            if (pos.x > Screen.width * 0.8f)
            {
                Debug.Log("right");
                tmp = current.MoveRight();
                button_on = true;
            }
            else if (pos.x < Screen.width * 0.2f)
            {
                Debug.Log("left");
                tmp = current.MoveLeft();
                button_on = true;
            }
            else
            {
                Debug.Log("rotate");
                tmp = current.Rotate();
                button_on = true;

                transform.Rotate(new Vector3(0f, 0f, 90f));
            }
        }
        else
        {
            Debug.Log("under");
            moveUnder(ref tmp);
            button_on = true;
        }
    }
    private Vector2 touchPoint()
    {
        #if UNITY_EDITOR
        if(Input.GetMouseButtonDown(0)){
            return Input.mousePosition;
        }else{
        return Vector2.zero;
        }
        #else
        if (Input.touchCount > 0)
        {
            Touch touch = Input.GetTouch(0);
            if (touch.phase == TouchPhase.Began)
            {
                return touch.position;
            }

        }
        return Vector2.zero;
        #endif
    }


    private void moveUnder(ref CurrentBlock tmp)
    {
        tmp = current.Fall();
        while (true)
        {
            if (!field.AreWallOrFix(tmp.MovePosition()))
            {
                current = tmp;
                tmp = current.Fall();
            }
            else
            {
                tmp = current;
                return;
            }
        }
    }

    private void initArray(GameObject[][] f)
    {
        for(int i = 0; i < f.Length; i++)
        {
            f[i] = new GameObject[Field.WIDTH];
        }
    }

    //fieldのオブジェクトを生成する
    private void createField(Field.BlockStatus[][] f)
    {
        for (int y = 0; y < f.Length; y++)
        {
            for (int x = 0; x < f[0].Length; x++)
            {
                field_blocks[y][x] = Instantiate(default_object, new Vector3(x - 6, -y + 12 , 0), Quaternion.identity) as GameObject;
                field_blocks[y][x].transform.parent = this.transform;
            }
        }
    }

    private void updateField(Field.BlockStatus[][] f, GameObject[][] fb)
    {
        for (int y = 0; y < f.Length; y++)
        {
            for (int x = 0; x < f[0].Length; x++)
            {
                fb[y][x].GetComponent<MeshRenderer>().enabled = true;
                Color c = None;
                switch (f[y][x])
                {
                    case Field.BlockStatus.Wall:
                        c = Wall;
                        break;
                    case Field.BlockStatus.Active:
                        c = Active;
                        break;
                    case Field.BlockStatus.Fix:
                        c = Fix;
                        break;
                    case Field.BlockStatus.None:
                        fb[y][x].GetComponent<MeshRenderer>().enabled = false;
                        c = None;
                        break;
                }
                fb[y][x].GetComponent<Renderer>().material.color = c;
            }
        }
    }

    //buttonが押されているかのチェックのbutton_onと、次の動きのtmpを初期化する
    private void initSetting()
    {
        button_on = false;
        tmp = current.Fall();
    }

    private void end(bool success)
    {
        finish = true;
        GameObject e = Instantiate(ending_obj) as GameObject;
        Ending ending = e.GetComponent<Ending>();
        ending.SetResult(success);
    }

    #endregion
}
