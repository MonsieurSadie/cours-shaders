// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Examples/Slices"
{
	Properties
	{
		_NumSlices("NumSlices", Range( 1 , 30)) = 0
		_SlicesWidth("SlicesWidth", Range( 0 , 1)) = 0.5
		_Pig_type_01_A_diff("Pig_type_01_A_diff", 2D) = "white" {}
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" }
		Cull Back
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows exclude_path:deferred 
		struct Input
		{
			float2 uv_texcoord;
			float3 worldPos;
		};

		uniform sampler2D _Pig_type_01_A_diff;
		uniform float4 _Pig_type_01_A_diff_ST;
		uniform float _NumSlices;
		uniform float _SlicesWidth;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_Pig_type_01_A_diff = i.uv_texcoord * _Pig_type_01_A_diff_ST.xy + _Pig_type_01_A_diff_ST.zw;
			float3 ase_vertex3Pos = mul( unity_WorldToObject, float4( i.worldPos , 1 ) );
			clip( frac( ( ase_vertex3Pos.y * _NumSlices ) ) - _SlicesWidth);
			o.Albedo = tex2D( _Pig_type_01_A_diff, uv_Pig_type_01_A_diff ).rgb;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=17800
0;73;1373;773;1302.741;513.8834;1.304743;True;False
Node;AmplifyShaderEditor.CommentaryNode;22;-807.2966,-77.41364;Inherit;False;443.1716;372.5797;Ici on scale la position Y (position locale) du vertex;3;14;17;3;;1,1,1,1;0;0
Node;AmplifyShaderEditor.PosVertexDataNode;3;-781.7668,-28.41364;Inherit;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;17;-757.2966,179.166;Inherit;False;Property;_NumSlices;NumSlices;0;0;Create;True;0;0;False;0;0;20.8;1;30;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;23;-348.0132,-41.49612;Inherit;False;204;160;Fract renvoie la partie derrière la virgule;1;19;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;14;-562.125,79.50388;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;5;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;24;-340.405,152.881;Inherit;False;428.3272;268.5368;de [0,1] on passe à [-0.5   0.5] si SlicesW = 0.5;2;15;18;;1,1,1,1;0;0
Node;AmplifyShaderEditor.FractNode;19;-298.0132,8.503883;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;25;-186.4644,-264.1439;Inherit;False;266;206;pixel rendu SI Alpha > 0;1;2;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SamplerNode;21;-580.4452,-330.1226;Inherit;True;Property;_Pig_type_01_A_diff;Pig_type_01_A_diff;2;0;Create;True;0;0;False;0;-1;f8696587ed4b70e4090fb77b2bd6c43f;f8696587ed4b70e4090fb77b2bd6c43f;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;18;-320.405,310.5894;Inherit;False;Property;_SlicesWidth;SlicesWidth;1;0;Create;True;0;0;False;0;0.5;0.611;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;15;-109.5631,202.881;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0.9;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClipNode;2;-136.4644,-214.1439;Inherit;False;3;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;2;FLOAT;0.5;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;155.8263,-100.6753;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;Examples/Slices;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;ForwardOnly;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0.1;0.9339623,0.5242524,0.5242524,0;VertexScale;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;14;0;3;2
WireConnection;14;1;17;0
WireConnection;19;0;14;0
WireConnection;15;1;18;0
WireConnection;2;0;21;0
WireConnection;2;1;19;0
WireConnection;2;2;18;0
WireConnection;0;0;2;0
ASEEND*/
//CHKSM=27B27FFD21BAB0D7ED8BA3DE3F591DF85A4B2214