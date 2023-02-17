/*
	Dec > Hex preproc macro

	This is an incredibly stupid macro
	Turns a list of decimal integer from 0-255 in to a single hex number
	
	Generally used for taking 2 or more small 8-bit integers and combining them in to a single 32-bit integer.
	Supplying a single number to DEC() will work, but is silly and just clamps the input 8-bits.

Usage:
	
	DEC(b1,b2,b3,b4)
	Function is overload, use only as many args as needed.

Example:

DEC(255,255) expands to 0xff

*/

#ifndef KCDEC2HEX
#define KCDEC2HEX

#include "./preproc/KC_OVERLOAD.lsl"

#define DEC_0	00
#define DEC_1	01
#define DEC_2	02
#define DEC_3	03
#define DEC_4	04
#define DEC_5	05
#define DEC_6	06
#define DEC_7	07
#define DEC_8	08
#define DEC_9	09
#define DEC_10	0A
#define DEC_11	0B
#define DEC_12	0C
#define DEC_13	0D
#define DEC_14	0E
#define DEC_15	0F
#define DEC_16	10
#define DEC_17	11
#define DEC_18	12
#define DEC_19	13
#define DEC_20	14
#define DEC_21	15
#define DEC_22	16
#define DEC_23	17
#define DEC_24	18
#define DEC_25	19
#define DEC_26	1A
#define DEC_27	1B
#define DEC_28	1C
#define DEC_29	1D
#define DEC_30	1E
#define DEC_31	1F
#define DEC_32	20
#define DEC_33	21
#define DEC_34	22
#define DEC_35	23
#define DEC_36	24
#define DEC_37	25
#define DEC_38	26
#define DEC_39	27
#define DEC_40	28
#define DEC_41	29
#define DEC_42	2A
#define DEC_43	2B
#define DEC_44	2C
#define DEC_45	2D
#define DEC_46	2E
#define DEC_47	2F
#define DEC_48	30
#define DEC_49	31
#define DEC_50	32
#define DEC_51	33
#define DEC_52	34
#define DEC_53	35
#define DEC_54	36
#define DEC_55	37
#define DEC_56	38
#define DEC_57	39
#define DEC_58	3A
#define DEC_59	3B
#define DEC_60	3C
#define DEC_61	3D
#define DEC_62	3E
#define DEC_63	3F
#define DEC_64	40
#define DEC_65	41
#define DEC_66	42
#define DEC_67	43
#define DEC_68	44
#define DEC_69	45
#define DEC_70	46
#define DEC_71	47
#define DEC_72	48
#define DEC_73	49
#define DEC_74	4A
#define DEC_75	4B
#define DEC_76	4C
#define DEC_77	4D
#define DEC_78	4E
#define DEC_79	4F
#define DEC_80	50
#define DEC_81	51
#define DEC_82	52
#define DEC_83	53
#define DEC_84	54
#define DEC_85	55
#define DEC_86	56
#define DEC_87	57
#define DEC_88	58
#define DEC_89	59
#define DEC_90	5A
#define DEC_91	5B
#define DEC_92	5C
#define DEC_93	5D
#define DEC_94	5E
#define DEC_95	5F
#define DEC_96	60
#define DEC_97	61
#define DEC_98	62
#define DEC_99	63
#define DEC_100	64
#define DEC_101	65
#define DEC_102	66
#define DEC_103	67
#define DEC_104	68
#define DEC_105	69
#define DEC_106	6A
#define DEC_107	6B
#define DEC_108	6C
#define DEC_109	6D
#define DEC_110	6E
#define DEC_111	6F
#define DEC_112	70
#define DEC_113	71
#define DEC_114	72
#define DEC_115	73
#define DEC_116	74
#define DEC_117	75
#define DEC_118	76
#define DEC_119	77
#define DEC_120	78
#define DEC_121	79
#define DEC_122	7A
#define DEC_123	7B
#define DEC_124	7C
#define DEC_125	7D
#define DEC_126	7E
#define DEC_127	7F
#define DEC_128	80
#define DEC_129	81
#define DEC_130	82
#define DEC_131	83
#define DEC_132	84
#define DEC_133	85
#define DEC_134	86
#define DEC_135	87
#define DEC_136	88
#define DEC_137	89
#define DEC_138	8A
#define DEC_139	8B
#define DEC_140	8C
#define DEC_141	8D
#define DEC_142	8E
#define DEC_143	8F
#define DEC_144	90
#define DEC_145	91
#define DEC_146	92
#define DEC_147	93
#define DEC_148	94
#define DEC_149	95
#define DEC_150	96
#define DEC_151	97
#define DEC_152	98
#define DEC_153	99
#define DEC_154	9A
#define DEC_155	9B
#define DEC_156	9C
#define DEC_157	9D
#define DEC_158	9E
#define DEC_159	9F
#define DEC_160	A0
#define DEC_161	A1
#define DEC_162	A2
#define DEC_163	A3
#define DEC_164	A4
#define DEC_165	A5
#define DEC_166	A6
#define DEC_167	A7
#define DEC_168	A8
#define DEC_169	A9
#define DEC_170	AA
#define DEC_171	AB
#define DEC_172	AC
#define DEC_173	AD
#define DEC_174	AE
#define DEC_175	AF
#define DEC_176	B0
#define DEC_177	B1
#define DEC_178	B2
#define DEC_179	B3
#define DEC_180	B4
#define DEC_181	B5
#define DEC_182	B6
#define DEC_183	B7
#define DEC_184	B8
#define DEC_185	B9
#define DEC_186	BA
#define DEC_187	BB
#define DEC_188	BC
#define DEC_189	BD
#define DEC_190	BE
#define DEC_191	BF
#define DEC_192	C0
#define DEC_193	C1
#define DEC_194	C2
#define DEC_195	C3
#define DEC_196	C4
#define DEC_197	C5
#define DEC_198	C6
#define DEC_199	C7
#define DEC_200	C8
#define DEC_201	C9
#define DEC_202	CA
#define DEC_203	CB
#define DEC_204	CC
#define DEC_205	CD
#define DEC_206	CE
#define DEC_207	CF
#define DEC_208	D0
#define DEC_209	D1
#define DEC_210	D2
#define DEC_211	D3
#define DEC_212	D4
#define DEC_213	D5
#define DEC_214	D6
#define DEC_215	D7
#define DEC_216	D8
#define DEC_217	D9
#define DEC_218	DA
#define DEC_219	DB
#define DEC_220	DC
#define DEC_221	DD
#define DEC_222	DE
#define DEC_223	DF
#define DEC_224	E0
#define DEC_225	E1
#define DEC_226	E2
#define DEC_227	E3
#define DEC_228	E4
#define DEC_229	E5
#define DEC_230	E6
#define DEC_231	E7
#define DEC_232	E8
#define DEC_233	E9
#define DEC_234	EA
#define DEC_235	EB
#define DEC_236	EC
#define DEC_237	ED
#define DEC_238	EE
#define DEC_239	EF
#define DEC_240	F0
#define DEC_241	F1
#define DEC_242	F2
#define DEC_243	F3
#define DEC_244	F4
#define DEC_245	F5
#define DEC_246	F6
#define DEC_247	F7
#define DEC_248	F8
#define DEC_249	F9
#define DEC_250	FA
#define DEC_251	FB
#define DEC_252	FC
#define DEC_253	FD
#define DEC_254	FE
#define DEC_255	FF


#define DEC1_HEXIFY(b1) 0x ## b1
#define DEC1_RELAY(b1) DEC1_HEXIFY(b1)
#define DEC1(b1) DEC1_RELAY(DEC_##b1)

#define DEC2_HEXIFY(b1,b2) 0x ## b1 ## b2
#define DEC2_RELAY(b1,b2) DEC2_HEXIFY(b1, b2)
#define DEC2(b1,b2) DEC2_RELAY(DEC_##b1, DEC_##b2)

#define DEC3_HEXIFY(b1,b2,b3) 0x ## b1 ## b2 ## b3
#define DEC3_RELAY(b1,b2,b3) DEC3_HEXIFY(b1, b2, b3)
#define DEC3(b1,b2,b3) DEC3_RELAY(DEC_##b1, DEC_##b2, DEC_##b3)

#define DEC4_HEXIFY(b1,b2,b3,b4) 0x ## b1 ## b2 ## b3 ## b4
#define DEC4_RELAY(b1,b2,b3,b4) DEC4_HEXIFY(b1, b2, b3, b4)
#define DEC4(b1,b2,b3,b4) DEC4_RELAY(DEC_##b1, DEC_##b2, DEC_##b3, DEC_##b4)


#define DEC(...) OVERLOAD(DEC, __VA_ARGS__)(__VA_ARGS__)


#endif //KCDEC2HEX
