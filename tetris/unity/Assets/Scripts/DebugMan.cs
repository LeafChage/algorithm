using System.Collections;
using System.Collections.Generic;
using UnityEngine;
public class DebugMan : MonoBehaviour {
    static string debug_text = "";
    static List<string> debugs = new List<string>();
    
    static int max_debug = 100;

    void OnGUI()
    {
        GUI.Label(new Rect(0, 0, Screen.width, Screen.height), debug_text);
    }
    public static void Log(string t)
    {
        Debug.Log(t);
        if (debugs.Count > max_debug)
        {
            debugs.RemoveAt(0);
        }
        debugs.Add(t + "\n");
        debug_text = "";
        foreach (string a in debugs)
        {
            debug_text += a;
        }
    }
}
