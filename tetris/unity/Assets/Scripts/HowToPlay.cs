using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class HowToPlay : MonoBehaviour {

	private float time = 0;
	void Start () {
		time = 0;
	}
	
	void Update () {
        Debug.Log("myself kill");
		time += Time.deltaTime;
		if(time > 3f){
			Debug.Log("myself kill");
			Destroy(this.gameObject);
			Destroy(this);
		}
	}
}
