using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[ExecuteInEditMode]
public class CustomPostProcess : MonoBehaviour
{
  public Material postProcessMaterial;

  private void Awake()
  {
		if (postProcessMaterial == null)
		{
			enabled = false;
		}
		else
		{
			// This is on purpose ... it prevents the know bug
			// https://issuetracker.unity3d.com/issues/calling-graphics-dot-blit-destination-null-crashes-the-editor
			// from happening
			postProcessMaterial.mainTexture = postProcessMaterial.mainTexture;
		}
	}

  private void OnRenderImage(RenderTexture source, RenderTexture destination)
  {
    Graphics.Blit(source, destination, postProcessMaterial);
  }

}
