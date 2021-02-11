// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Examples/PushMeOnTheBeat"
{
	Properties
	{
		_PushAmount1("PushAmount", Range( 0 , 1)) = 1
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
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows vertex:vertexDataFunc 
		struct Input
		{
			float2 uv_texcoord;
		};

		uniform float _PushAmount1;
		uniform sampler2D _Pig_type_01_A_diff;
		uniform float4 _Pig_type_01_A_diff_ST;

		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			float3 ase_vertexNormal = v.normal.xyz;
			v.vertex.xyz += ( ase_vertexNormal * ( _PushAmount1 * ( ( _SinTime.w + 1.0 ) * 0.5 ) ) );
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_Pig_type_01_A_diff = i.uv_texcoord * _Pig_type_01_A_diff_ST.xy + _Pig_type_01_A_diff_ST.zw;
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
0;73;1373;773;1300.993;457.433;1.3;True;False
Node;AmplifyShaderEditor.CommentaryNode;19;-711.3187,252.1715;Inherit;False;510.1001;229;sin(something) + 1 ->  [0, 2]. Then *0.5 -> [0,1];3;5;8;9;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SinTimeNode;5;-689.9188,303.4715;Inherit;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;8;-505.6187,346.9715;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;21;-270.2,-146.4;Inherit;False;438.1;272;normal scaling;2;1;4;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;20;-153.8187,146.2715;Inherit;False;219;183;Sinus scaling;1;6;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;2;-579.8002,117.6;Inherit;False;Property;_PushAmount1;PushAmount;0;0;Create;True;0;0;False;0;1;0.1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;9;-370.2186,345.9715;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.NormalVertexDataNode;1;-220.2,-96.4;Inherit;False;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;6;-103.8187,196.2715;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;4;-1.100003,-7.399984;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SamplerNode;10;-158.5236,-361.3647;Inherit;True;Property;_Pig_type_01_A_diff;Pig_type_01_A_diff;1;0;Create;True;0;0;False;0;-1;f8696587ed4b70e4090fb77b2bd6c43f;f8696587ed4b70e4090fb77b2bd6c43f;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;226.662,-238.3667;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;Examples/PushMeOnTheBeat;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;8;0;5;4
WireConnection;9;0;8;0
WireConnection;6;0;2;0
WireConnection;6;1;9;0
WireConnection;4;0;1;0
WireConnection;4;1;6;0
WireConnection;0;0;10;0
WireConnection;0;11;4;0
ASEEND*/
//CHKSM=4499451DC29FCD37AA0A60832E85DFCEC706A8A2