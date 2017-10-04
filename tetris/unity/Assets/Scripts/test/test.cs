using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class test : MonoBehaviour {

	void Start () {
		
	}
	
	void Update () {
		DebugMan.Log(
			"x: " + Input.acceleration.x.ToString() + 
			" /y: " + Input.acceleration.y.ToString() + 
			" /z: " + Input.acceleration.z.ToString() 
		);
	}
}
