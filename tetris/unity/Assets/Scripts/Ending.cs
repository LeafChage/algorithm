using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Ending : MonoBehaviour {
    [SerializeField] private GameObject title;

    private GUIStyle style;
    private string comment = "success";

    private void Update()
    {
        if (Input.GetKeyDown(KeyCode.Space))
        {
            endSetting();
        }
    }

    private void OnGUI()
    {
        style = new GUIStyle();
        style.fontSize = 30;

        GUI.Box(new Rect(Screen.width * 0.2f, Screen.height * 0.3f, Screen.width * 0.6f, Screen.height * 0.5f), "");
        GUI.Label(new Rect(Screen.width * 0.3f, Screen.height * 0.4f , Screen.width * 0.4f, Screen.height * 0.25f), comment, style);
        if (GUI.Button(new Rect(Screen.width * 0.3f, Screen.height * 0.55f, Screen.width* 0.4f, Screen.height * 0.2f), "タイトルに戻る"))
        {
            endSetting();
        }
    }

    public void SetResult(bool success)
    {
        if (success)
        {
            comment = "Success";
        }
        else
        {
            comment = "GameOver";
        }
    }

    private void endSetting()
    {
        Instantiate(title);
        Destroy(this.gameObject);
    }
}
