// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Custom/CellShading"
{
	Properties
	{
		_DiffuseLightColor("DiffuseLightColor", Color) = (0,0,0,0)
		_DiffuseDarkColor("DiffuseDarkColor", Color) = (0,0,0,0)
		_DiffuseThreshold("DiffuseThreshold", Range( 0 , 1)) = 0.2535545
		_SpecularColor("SpecularColor", Color) = (0,0,0,0)
		_SpecularWidth("SpecularWidth", Range( 0 , 1)) = 0.5
		_SpecularStrength("SpecularStrength", Float) = 10
		_RimColor("RimColor", Color) = (0,0,0,0)
		_RimWidth("RimWidth", Range( 0 , 1)) = 0
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" }
		Cull Back
		ZWrite On
		CGINCLUDE
		#include "UnityPBSLighting.cginc"
		#include "UnityCG.cginc"
		#include "Lighting.cginc"
		#pragma target 3.0
		struct Input
		{
			float3 worldPos;
			float3 worldNormal;
			float3 viewDir;
		};

		struct SurfaceOutputCustomLightingCustom
		{
			half3 Albedo;
			half3 Normal;
			half3 Emission;
			half Metallic;
			half Smoothness;
			half Occlusion;
			half Alpha;
			Input SurfInput;
			UnityGIInput GIData;
		};

		uniform float4 _DiffuseLightColor;
		uniform float _DiffuseThreshold;
		uniform float4 _DiffuseDarkColor;
		uniform float _SpecularStrength;
		uniform float _SpecularWidth;
		uniform float4 _SpecularColor;
		uniform float _RimWidth;
		uniform float4 _RimColor;

		inline half4 LightingStandardCustomLighting( inout SurfaceOutputCustomLightingCustom s, half3 viewDir, UnityGI gi )
		{
			UnityGIInput data = s.GIData;
			Input i = s.SurfInput;
			half4 c = 0;
			float3 ase_worldPos = i.worldPos;
			#if defined(LIGHTMAP_ON) && UNITY_VERSION < 560 //aseld
			float3 ase_worldlightDir = 0;
			#else //aseld
			float3 ase_worldlightDir = normalize( UnityWorldSpaceLightDir( ase_worldPos ) );
			#endif //aseld
			float3 ase_worldNormal = i.worldNormal;
			float dotResult4 = dot( ase_worldlightDir , ase_worldNormal );
			float temp_output_16_0 = step( _DiffuseThreshold , max( dotResult4 , 0.0 ) );
			float dotResult26 = dot( reflect( -ase_worldlightDir , ase_worldNormal ) , i.viewDir );
			float dotResult47 = dot( ( 1.0 - i.viewDir ) , ase_worldNormal );
			float smoothstepResult56 = smoothstep( 0.45 , 0.55 , pow( max( dotResult47 , 0.0 ) , ( 1.0 - _RimWidth ) ));
			c.rgb = ( ( ( _DiffuseLightColor * temp_output_16_0 ) + ( _DiffuseDarkColor * ( 1.0 - temp_output_16_0 ) ) ) + ( step( ( 1.0 - pow( max( dotResult26 , 0.0 ) , _SpecularStrength ) ) , _SpecularWidth ) * _SpecularColor ) + ( smoothstepResult56 * _RimColor ) ).rgb;
			c.a = 1;
			return c;
		}

		inline void LightingStandardCustomLighting_GI( inout SurfaceOutputCustomLightingCustom s, UnityGIInput data, inout UnityGI gi )
		{
			s.GIData = data;
		}

		void surf( Input i , inout SurfaceOutputCustomLightingCustom o )
		{
			o.SurfInput = i;
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf StandardCustomLighting keepalpha fullforwardshadows 

		ENDCG
		Pass
		{
			Name "ShadowCaster"
			Tags{ "LightMode" = "ShadowCaster" }
			ZWrite On
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 3.0
			#pragma multi_compile_shadowcaster
			#pragma multi_compile UNITY_PASS_SHADOWCASTER
			#pragma skip_variants FOG_LINEAR FOG_EXP FOG_EXP2
			#include "HLSLSupport.cginc"
			#if ( SHADER_API_D3D11 || SHADER_API_GLCORE || SHADER_API_GLES || SHADER_API_GLES3 || SHADER_API_METAL || SHADER_API_VULKAN )
				#define CAN_SKIP_VPOS
			#endif
			#include "UnityCG.cginc"
			#include "Lighting.cginc"
			#include "UnityPBSLighting.cginc"
			struct v2f
			{
				V2F_SHADOW_CASTER;
				float3 worldPos : TEXCOORD1;
				float3 worldNormal : TEXCOORD2;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};
			v2f vert( appdata_full v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID( v );
				UNITY_INITIALIZE_OUTPUT( v2f, o );
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO( o );
				UNITY_TRANSFER_INSTANCE_ID( v, o );
				float3 worldPos = mul( unity_ObjectToWorld, v.vertex ).xyz;
				half3 worldNormal = UnityObjectToWorldNormal( v.normal );
				o.worldNormal = worldNormal;
				o.worldPos = worldPos;
				TRANSFER_SHADOW_CASTER_NORMALOFFSET( o )
				return o;
			}
			half4 frag( v2f IN
			#if !defined( CAN_SKIP_VPOS )
			, UNITY_VPOS_TYPE vpos : VPOS
			#endif
			) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID( IN );
				Input surfIN;
				UNITY_INITIALIZE_OUTPUT( Input, surfIN );
				float3 worldPos = IN.worldPos;
				half3 worldViewDir = normalize( UnityWorldSpaceViewDir( worldPos ) );
				surfIN.viewDir = worldViewDir;
				surfIN.worldPos = worldPos;
				surfIN.worldNormal = IN.worldNormal;
				SurfaceOutputCustomLightingCustom o;
				UNITY_INITIALIZE_OUTPUT( SurfaceOutputCustomLightingCustom, o )
				surf( surfIN, o );
				#if defined( CAN_SKIP_VPOS )
				float2 vpos = IN.pos;
				#endif
				SHADOW_CASTER_FRAGMENT( IN )
			}
			ENDCG
		}
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18800
0;73;1085;746;1893.904;479.8435;4.289798;True;False
Node;AmplifyShaderEditor.CommentaryNode;43;-1644.757,705.3246;Inherit;False;2389.601;879.8772;SPECULAR;2;42;29;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;29;-1594.757,755.3246;Inherit;False;984.3311;709.753;Specular Calculation;6;26;17;18;25;24;27;;1,1,1,1;0;0
Node;AmplifyShaderEditor.WorldSpaceLightDirHlpNode;17;-1544.757,981.179;Inherit;False;False;1;0;FLOAT;0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.CommentaryNode;15;-1355.912,-184.5097;Inherit;False;2092.155;840.5902;DIFFUSE;13;16;11;13;1;7;14;6;4;34;2;3;94;95;;1,1,1,1;0;0
Node;AmplifyShaderEditor.WorldNormalVector;18;-1521.299,1123.525;Inherit;False;False;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.CommentaryNode;54;-488.1772,1629.459;Inherit;False;1234.777;650;RIM LIGHTING;11;45;46;48;47;49;52;50;53;55;56;57;;1,1,1,1;0;0
Node;AmplifyShaderEditor.NegateNode;25;-1301.426,1030.078;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.WorldSpaceLightDirHlpNode;2;-1338.675,305.6552;Inherit;False;False;1;0;FLOAT;0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;27;-1498.033,1276.149;Inherit;False;World;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.CommentaryNode;42;-556.9982,760.3539;Inherit;False;1264.039;784.1919;Specular Contribution Tweaking;8;32;39;28;36;30;38;41;19;;1,1,1,1;0;0
Node;AmplifyShaderEditor.WorldNormalVector;3;-1310.686,455.7377;Inherit;False;False;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.ReflectOpNode;24;-1171.426,1080.078;Inherit;True;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;46;-415.0434,1932.802;Inherit;False;World;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.CommentaryNode;32;-506.9984,1229.081;Inherit;False;325;299;Remove the parts where dot produces -1;1;31;;1,1,1,1;0;0
Node;AmplifyShaderEditor.OneMinusNode;49;-239.9967,1989.459;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.CommentaryNode;34;-873.1835,299.0008;Inherit;False;325;299;Remove the parts where dot produces -1;1;35;;1,1,1,1;0;0
Node;AmplifyShaderEditor.WorldNormalVector;48;-438.1772,2093.086;Inherit;False;False;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.DotProductOpNode;4;-1098.181,358.3152;Inherit;True;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DotProductOpNode;26;-843.4263,1204.078;Inherit;True;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DotProductOpNode;47;-80.39989,2024.465;Inherit;True;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMaxOpNode;35;-806.4706,358.1716;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMaxOpNode;31;-454.9984,1279.081;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;6;-1335.675,-130.3447;Inherit;False;Property;_DiffuseThreshold;DiffuseThreshold;2;0;Create;True;0;0;0;False;0;False;0.2535545;0.264;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;50;-432.9449,1679.459;Inherit;False;Property;_RimWidth;RimWidth;7;0;Create;True;0;0;0;False;0;False;0;0.207;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;28;-502.9114,1067.103;Inherit;False;Property;_SpecularStrength;SpecularStrength;5;0;Create;True;0;0;0;False;0;False;10;10;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;57;-78.9082,1733.983;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;30;-161.9983,1241.081;Inherit;True;False;2;0;FLOAT;0;False;1;FLOAT;10;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMaxOpNode;55;116.337,2023.175;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;16;-397.2791,363.898;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;1;-1335.675,126.6553;Inherit;False;Property;_DiffuseLightColor;DiffuseLightColor;0;0;Create;True;0;0;0;False;0;False;0,0,0,0;0.8117647,0.2196078,0.5421416,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;7;-1335.675,-54.34478;Inherit;False;Property;_DiffuseDarkColor;DiffuseDarkColor;1;0;Create;True;0;0;0;False;0;False;0,0,0,0;0.2830189,0.02002492,0.2192627,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PowerNode;52;226.0033,2025.459;Inherit;True;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;39;-503.5975,985.0463;Inherit;False;Property;_SpecularWidth;SpecularWidth;4;0;Create;True;0;0;0;False;0;False;0.5;0.25;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;14;-117.4576,363.803;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;38;64.50238,1259.346;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;13;144.9192,344.7202;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;45;-432.4338,1754.633;Inherit;False;Property;_RimColor;RimColor;6;0;Create;True;0;0;0;False;0;False;0,0,0,0;0.5754717,0.3230242,0.5003386,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StepOpNode;36;208.8025,1290.546;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0.2;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;94;146.8146,112.5986;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;19;-501.6036,805.3246;Inherit;False;Property;_SpecularColor;SpecularColor;3;0;Create;True;0;0;0;False;0;False;0,0,0,0;0.5471698,0.2348701,0.4874092,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SmoothstepOpNode;56;404.2888,1783.096;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0.45;False;2;FLOAT;0.55;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;95;-477.176,-144.0158;Inherit;False;583.1404;306.3471;LIGHT RAMP;2;90;89;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;88;-848.538,-883.9882;Inherit;False;1139.156;427.1794;ProceduralRamp;6;75;12;84;77;81;83;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;41;472.0407,1200.813;Inherit;True;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;11;459.4704,307.5135;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;53;513.7828,2014.715;Inherit;True;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;12;55.6183,-710.8088;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;84;-198.5484,-713.0835;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;75;-633.8054,-723.6627;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;5;False;1;FLOAT;0
Node;AmplifyShaderEditor.FloorOpNode;77;-398.0414,-714.5948;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;81;-505.3444,-833.9882;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;83;-798.538,-832.4769;Half;False;Property;_NumRampSections;NumRampSections;8;1;[IntRange];Create;True;0;0;0;False;0;False;3;2;0;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;89;-435.7121,-91.88175;Inherit;True;Property;_LightRamp;LightRamp;9;0;Create;True;0;0;0;False;0;False;-1;None;823623045450c994ea01e781cd95f9ef;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;44;1337.828,1079.104;Inherit;True;3;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;90;-118.3653,-91.66872;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;1732.867,840.9333;Float;False;True;-1;2;ASEMaterialInspector;0;0;CustomLighting;Custom/CellShading;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;1;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;25;0;17;0
WireConnection;24;0;25;0
WireConnection;24;1;18;0
WireConnection;49;0;46;0
WireConnection;4;0;2;0
WireConnection;4;1;3;0
WireConnection;26;0;24;0
WireConnection;26;1;27;0
WireConnection;47;0;49;0
WireConnection;47;1;48;0
WireConnection;35;0;4;0
WireConnection;31;0;26;0
WireConnection;57;0;50;0
WireConnection;30;0;31;0
WireConnection;30;1;28;0
WireConnection;55;0;47;0
WireConnection;16;0;6;0
WireConnection;16;1;35;0
WireConnection;52;0;55;0
WireConnection;52;1;57;0
WireConnection;14;0;16;0
WireConnection;38;0;30;0
WireConnection;13;0;7;0
WireConnection;13;1;14;0
WireConnection;36;0;38;0
WireConnection;36;1;39;0
WireConnection;94;0;1;0
WireConnection;94;1;16;0
WireConnection;56;0;52;0
WireConnection;41;0;36;0
WireConnection;41;1;19;0
WireConnection;11;0;94;0
WireConnection;11;1;13;0
WireConnection;53;0;56;0
WireConnection;53;1;45;0
WireConnection;12;0;84;0
WireConnection;84;0;77;0
WireConnection;84;1;81;0
WireConnection;75;1;81;0
WireConnection;77;0;75;0
WireConnection;81;0;83;0
WireConnection;44;0;11;0
WireConnection;44;1;41;0
WireConnection;44;2;53;0
WireConnection;90;0;89;0
WireConnection;0;13;44;0
ASEEND*/
//CHKSM=2306F669A906871F1138AFC6562E57192AD75A79