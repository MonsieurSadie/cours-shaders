// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Custom/PostProcess/OutlinePostProcess"
{
	Properties
	{
		_MainTex ( "Screen", 2D ) = "black" {}
		_PixelSize("PixelSize", Float) = 2
		_Threshold("Threshold", Float) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}

	}

	SubShader
	{
		LOD 0

		
		
		ZTest Always
		Cull Off
		ZWrite Off

		
		Pass
		{ 
			CGPROGRAM 

			

			#pragma vertex vert_img_custom 
			#pragma fragment frag
			#pragma target 3.0
			#include "UnityCG.cginc"
			

			struct appdata_img_custom
			{
				float4 vertex : POSITION;
				half2 texcoord : TEXCOORD0;
				
			};

			struct v2f_img_custom
			{
				float4 pos : SV_POSITION;
				half2 uv   : TEXCOORD0;
				half2 stereoUV : TEXCOORD2;
		#if UNITY_UV_STARTS_AT_TOP
				half4 uv2 : TEXCOORD1;
				half4 stereoUV2 : TEXCOORD3;
		#endif
				float4 ase_texcoord4 : TEXCOORD4;
			};

			uniform sampler2D _MainTex;
			uniform half4 _MainTex_TexelSize;
			uniform half4 _MainTex_ST;
			
			UNITY_DECLARE_DEPTH_TEXTURE( _CameraDepthTexture );
			uniform float4 _CameraDepthTexture_TexelSize;
			uniform float _PixelSize;
			uniform float _Threshold;


			v2f_img_custom vert_img_custom ( appdata_img_custom v  )
			{
				v2f_img_custom o;
				float4 ase_clipPos = UnityObjectToClipPos(v.vertex);
				float4 screenPos = ComputeScreenPos(ase_clipPos);
				o.ase_texcoord4 = screenPos;
				
				o.pos = UnityObjectToClipPos( v.vertex );
				o.uv = float4( v.texcoord.xy, 1, 1 );

				#if UNITY_UV_STARTS_AT_TOP
					o.uv2 = float4( v.texcoord.xy, 1, 1 );
					o.stereoUV2 = UnityStereoScreenSpaceUVAdjust ( o.uv2, _MainTex_ST );

					if ( _MainTex_TexelSize.y < 0.0 )
						o.uv.y = 1.0 - o.uv.y;
				#endif
				o.stereoUV = UnityStereoScreenSpaceUVAdjust ( o.uv, _MainTex_ST );
				return o;
			}

			half4 frag ( v2f_img_custom i ) : SV_Target
			{
				#ifdef UNITY_UV_STARTS_AT_TOP
					half2 uv = i.uv2;
					half2 stereoUV = i.stereoUV2;
				#else
					half2 uv = i.uv;
					half2 stereoUV = i.stereoUV;
				#endif	
				
				half4 finalColor;

				// ase common template code
				float2 uv_MainTex = i.uv.xy * _MainTex_ST.xy + _MainTex_ST.zw;
				float4 screenPos = i.ase_texcoord4;
				float4 ase_screenPosNorm = screenPos / screenPos.w;
				ase_screenPosNorm.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_screenPosNorm.z : ase_screenPosNorm.z * 0.5 + 0.5;
				float2 appendResult9_g169 = (float2(0.0 , 0.0));
				float clampDepth3_g169 = Linear01Depth(SAMPLE_DEPTH_TEXTURE( _CameraDepthTexture, float4( ( ase_screenPosNorm.xy + appendResult9_g169 ), 0.0 , 0.0 ).xy ));
				float temp_output_115_0 = (0.0 + (clampDepth3_g169 - 0.0) * (100.0 - 0.0) / (1.0 - 0.0));
				float4 break52 = ( _MainTex_TexelSize * _PixelSize );
				float2 appendResult9_g170 = (float2(break52.x , 0.0));
				float clampDepth3_g170 = Linear01Depth(SAMPLE_DEPTH_TEXTURE( _CameraDepthTexture, float4( ( ase_screenPosNorm.xy + appendResult9_g170 ), 0.0 , 0.0 ).xy ));
				float temp_output_1_0_g185 = 1.0;
				float ifLocalVar5_g185 = 0;
				if( abs( ( temp_output_115_0 - (0.0 + (clampDepth3_g170 - 0.0) * (100.0 - 0.0) / (1.0 - 0.0)) ) ) >= _Threshold )
				ifLocalVar5_g185 = temp_output_1_0_g185;
				else
				ifLocalVar5_g185 = 0.0;
				float2 appendResult9_g172 = (float2(-break52.x , 0.0));
				float clampDepth3_g172 = Linear01Depth(SAMPLE_DEPTH_TEXTURE( _CameraDepthTexture, float4( ( ase_screenPosNorm.xy + appendResult9_g172 ), 0.0 , 0.0 ).xy ));
				float temp_output_1_0_g184 = 1.0;
				float ifLocalVar5_g184 = 0;
				if( abs( ( temp_output_115_0 - (0.0 + (clampDepth3_g172 - 0.0) * (100.0 - 0.0) / (1.0 - 0.0)) ) ) >= _Threshold )
				ifLocalVar5_g184 = temp_output_1_0_g184;
				else
				ifLocalVar5_g184 = 0.0;
				float2 appendResult9_g171 = (float2(0.0 , break52.y));
				float clampDepth3_g171 = Linear01Depth(SAMPLE_DEPTH_TEXTURE( _CameraDepthTexture, float4( ( ase_screenPosNorm.xy + appendResult9_g171 ), 0.0 , 0.0 ).xy ));
				float temp_output_1_0_g182 = 1.0;
				float ifLocalVar5_g182 = 0;
				if( abs( ( temp_output_115_0 - (0.0 + (clampDepth3_g171 - 0.0) * (100.0 - 0.0) / (1.0 - 0.0)) ) ) >= _Threshold )
				ifLocalVar5_g182 = temp_output_1_0_g182;
				else
				ifLocalVar5_g182 = 0.0;
				float2 appendResult9_g173 = (float2(0.0 , -break52.y));
				float clampDepth3_g173 = Linear01Depth(SAMPLE_DEPTH_TEXTURE( _CameraDepthTexture, float4( ( ase_screenPosNorm.xy + appendResult9_g173 ), 0.0 , 0.0 ).xy ));
				float temp_output_1_0_g183 = 1.0;
				float ifLocalVar5_g183 = 0;
				if( abs( ( temp_output_115_0 - (0.0 + (clampDepth3_g173 - 0.0) * (100.0 - 0.0) / (1.0 - 0.0)) ) ) >= _Threshold )
				ifLocalVar5_g183 = temp_output_1_0_g183;
				else
				ifLocalVar5_g183 = 0.0;
				

				finalColor = ( tex2D( _MainTex, uv_MainTex ) * ( 1.0 - ( ifLocalVar5_g185 + ifLocalVar5_g184 + ifLocalVar5_g182 + ifLocalVar5_g183 ) ) );

				return finalColor;
			} 
			ENDCG 
		}
	}
	CustomEditor "ASEMaterialInspector"
	
	
}
/*ASEBEGIN
Version=18800
0;73;933;746;-111.4002;-8.251038;2.039849;False;False
Node;AmplifyShaderEditor.CommentaryNode;39;-657.5886,465.4006;Inherit;False;591.8747;257;Pixel size in normalized screen space;4;13;20;40;52;;1,1,1,1;0;0
Node;AmplifyShaderEditor.TemplateShaderPropertyNode;13;-607.5886,515.4006;Inherit;False;0;0;_MainTex_TexelSize;Shader;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;40;-393.0862,643.4022;Inherit;False;Property;_PixelSize;PixelSize;0;0;Create;True;0;0;0;False;0;False;2;0.9;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;20;-370.0163,518.4877;Inherit;False;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;1;False;1;FLOAT4;0
Node;AmplifyShaderEditor.BreakToComponentsNode;52;-212.0355,520.5058;Inherit;False;FLOAT4;1;0;FLOAT4;0,0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.NegateNode;58;-43.06271,807.9337;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ScreenPosInputsNode;82;-300.6407,280.783;Float;False;0;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.NegateNode;59;-46.54671,1107.556;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;116;-73.11194,290.2327;Inherit;False;Constant;_MaxDepth;MaxDepth;2;0;Create;True;0;0;0;False;0;False;100;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;115;89.32848,450.1836;Inherit;False;GetPixelDepth;-1;;169;6dbc8432a36589a49ba82565cc4d8fb1;0;4;5;FLOAT2;0,0;False;6;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;50;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;114;98.03832,624.3824;Inherit;False;GetPixelDepth;-1;;170;6dbc8432a36589a49ba82565cc4d8fb1;0;4;5;FLOAT2;0,0;False;6;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;50;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;113;98.03834,918.7785;Inherit;False;GetPixelDepth;-1;;171;6dbc8432a36589a49ba82565cc4d8fb1;0;4;5;FLOAT2;0,0;False;6;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;50;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;112;101.5906,770.3348;Inherit;False;GetPixelDepth;-1;;172;6dbc8432a36589a49ba82565cc4d8fb1;0;4;5;FLOAT2;0,0;False;6;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;50;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;111;103.2644,1059.879;Inherit;False;GetPixelDepth;-1;;173;6dbc8432a36589a49ba82565cc4d8fb1;0;4;5;FLOAT2;0,0;False;6;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;50;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;99;457.7417,897.0796;Inherit;False;FloatDistance;-1;;177;991b52d42ddd0de4ca62079ecf71084b;0;2;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;71;532.0878,311.3133;Inherit;False;Constant;_Float1;Float 1;1;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;97;461.2936,650.2059;Inherit;False;FloatDistance;-1;;176;991b52d42ddd0de4ca62079ecf71084b;0;2;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;67;457.0802,517.0234;Inherit;False;FloatDistance;-1;;175;991b52d42ddd0de4ca62079ecf71084b;0;2;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;104;719.2245,348.7221;Inherit;False;Property;_Threshold;Threshold;1;0;Create;True;0;0;0;False;0;False;0;0.1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;98;457.7415,774.5307;Inherit;False;FloatDistance;-1;;174;991b52d42ddd0de4ca62079ecf71084b;0;2;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;70;535.5719,406.8425;Inherit;False;Constant;_Float0;Float 0;1;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;119;704,672;Inherit;False;SelectOnDistance;-1;;184;de0c3f01235893d46b7f54d94f96d4b6;0;4;4;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;117;704,816;Inherit;False;SelectOnDistance;-1;;182;de0c3f01235893d46b7f54d94f96d4b6;0;4;4;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;118;706.6846,964.1521;Inherit;False;SelectOnDistance;-1;;183;de0c3f01235893d46b7f54d94f96d4b6;0;4;4;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;120;706.6846,530.076;Inherit;False;SelectOnDistance;-1;;185;de0c3f01235893d46b7f54d94f96d4b6;0;4;4;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;103;992.3391,682.1751;Inherit;False;4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TemplateShaderPropertyNode;105;994.7529,446.9303;Inherit;False;0;0;_MainTex;Shader;False;0;5;SAMPLER2D;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.OneMinusNode;108;1151.451,853.1833;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;106;1170.796,468.2102;Inherit;True;Property;_TextureSample0;Texture Sample 0;2;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;109;1366.184,748.7182;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;0;1541.447,734.307;Float;False;True;-1;2;ASEMaterialInspector;0;2;Custom/PostProcess/OutlinePostProcess;c71b220b631b6344493ea3cf87110c93;True;SubShader 0 Pass 0;0;0;SubShader 0 Pass 0;1;False;False;False;False;False;False;False;False;False;True;2;False;-1;False;False;False;False;False;True;2;False;-1;True;7;False;-1;False;True;0;False;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;2;0;;0;0;Standard;0;0;1;True;False;;False;0
Node;AmplifyShaderEditor.CommentaryNode;51;39.32848,400.1836;Inherit;False;325;209;Current Pixel (center);0;;1,1,1,1;0;0
WireConnection;20;0;13;0
WireConnection;20;1;40;0
WireConnection;52;0;20;0
WireConnection;58;0;52;0
WireConnection;59;0;52;1
WireConnection;115;5;82;0
WireConnection;115;1;116;0
WireConnection;114;5;82;0
WireConnection;114;6;52;0
WireConnection;114;1;116;0
WireConnection;113;5;82;0
WireConnection;113;8;52;1
WireConnection;113;1;116;0
WireConnection;112;5;82;0
WireConnection;112;6;58;0
WireConnection;112;1;116;0
WireConnection;111;5;82;0
WireConnection;111;8;59;0
WireConnection;111;1;116;0
WireConnection;99;1;115;0
WireConnection;99;2;111;0
WireConnection;97;1;115;0
WireConnection;97;2;112;0
WireConnection;67;1;115;0
WireConnection;67;2;114;0
WireConnection;98;1;115;0
WireConnection;98;2;113;0
WireConnection;119;4;97;0
WireConnection;119;3;104;0
WireConnection;119;1;70;0
WireConnection;119;2;71;0
WireConnection;117;4;98;0
WireConnection;117;3;104;0
WireConnection;117;1;70;0
WireConnection;117;2;71;0
WireConnection;118;4;99;0
WireConnection;118;3;104;0
WireConnection;118;1;70;0
WireConnection;118;2;71;0
WireConnection;120;4;67;0
WireConnection;120;3;104;0
WireConnection;120;1;70;0
WireConnection;120;2;71;0
WireConnection;103;0;120;0
WireConnection;103;1;119;0
WireConnection;103;2;117;0
WireConnection;103;3;118;0
WireConnection;108;0;103;0
WireConnection;106;0;105;0
WireConnection;109;0;106;0
WireConnection;109;1;108;0
WireConnection;0;0;109;0
ASEEND*/
//CHKSM=FD3434718C19774906E7CCC3AD5A169352047D42