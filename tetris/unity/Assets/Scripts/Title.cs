using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Title : MonoBehaviour {
    [SerializeField] private GameObject blocks;
    [SerializeField] private GameObject ui;
    [SerializeField] private GameObject title;

    private Quaternion rotation;
    private Vector3 rotateRange;
    private void Start()
    {
        rotateRange = new Vector3( Random.Range(0, 5), Random.Range(0, 5), Random.Range(0, 5));
        rotation = title.transform.rotation;
        Debug.Log(blocks.name);
        Debug.Log(ui.name);
        GameObject b = GameObject.Find(blocks.name);
        GameObject u = GameObject.Find(ui.name);
        if(b != null)
        {
            Destroy(b.gameObject);
            Debug.Log("hi");
        }
        if(u != null)
        {
            Destroy(u.gameObject);
        }
    }

    private void Update()
    {
        titleAnimation();
        if (Input.GetKeyDown(KeyCode.Alpha1))
        {
            Setting.Time = 30;
            startSetting();
        }
        if (Input.GetKeyDown(KeyCode.Alpha2))
        {
            Setting.Time = 20;
            startSetting();
        }
        if (Input.GetKeyDown(KeyCode.Space))
        {
            Setting.Time = 10;
            startSetting();
        }
        if (Input.GetKeyDown(KeyCode.Alpha8))
        {
            Setting.Time = 5;
            startSetting();
        }
        if (Input.GetKeyDown(KeyCode.Alpha9))
        {
            Setting.Time = 3;
            startSetting();
        }
        if (Input.GetKeyDown(KeyCode.Alpha0))
        {
            Setting.Time = 1;
            startSetting();
        }
    }

    
    //clickされたとき
    public void clickButton()
    {
        Setting.Time = 10;
        startSetting();
    }
    private void titleAnimation(){
        title.transform.Rotate(rotateRange);
    }

    private void startSetting()
    {
        GameObject b = Instantiate(blocks);
        GameObject u = Instantiate(ui);
        b.name = blocks.name;
        u.name = ui.name;
        Destroy(this.gameObject);
    }
}
