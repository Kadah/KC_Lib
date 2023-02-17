/*
	Key encode/decode "compression"

Converts UUID keys in to shorter strings to conserve space


TODO: additional cleanup
TODO: finish documentation
*/

#ifndef KC_KEYS
#define KC_KEYS

#include "./preproc/KC_OVERLOAD.lsl"

/*============================

				Keys <> Base64

============================*/

/*
	KCLib$Key_To_Base64

key_in: UUID, can be key type or string
returns: Base64 encoded key

TODO: update docs for macros that dont actually have returns
*/
#define __Key_To_Base64_1( key_in ) ( \
	KCLib$Hex_To_Base64(llGetSubString(key_in, 0, 7)) \
	+ KCLib$Hex_To_Base64(llGetSubString(key_in, 9, 12)+llGetSubString(key_in, 14, 17)) \
	+ KCLib$Hex_To_Base64(llGetSubString(key_in, 19, 22)+llGetSubString(key_in, 24, 27)) \
	+ KCLib$Hex_To_Base64(llGetSubString(key_in, 28, 35)) \
)
#define __Key_To_Base64_2( key_in, key_out ) {key_out = __Key_To_Base64_1(key_in)}
#define KCLib$Key_To_Base64(...) OVERLOAD(__Key_To_Base64_, __VA_ARGS__)(__VA_ARGS__)

string KCLib_Key_To_Base64( string str_key ) {
	return KCLib$Key_To_Base64( str_key);
}

/*
	KCLib$Base64_To_Key

str_encoded: Base64 encoded key
key_out: UUID, can be key type or string

if the original value is not needed after decode,
str_encoded and key_out can be the same string variable to save some memory
*/
#define __Base64_To_Key_2( str_encoded, key_out ) { \
	key_out = KCLib_Int_To_Hex(KCLib$Base64_To_Integer(llGetSubString(str_encoded, 0, 5))) \
		+ KCLib_Int_To_Hex(KCLib$Base64_To_Integer(llGetSubString(str_encoded, 6, 11))) \
		+ KCLib_Int_To_Hex(KCLib$Base64_To_Integer(llGetSubString(str_encoded, 12, 17))) \
		+ KCLib_Int_To_Hex(KCLib$Base64_To_Integer(llGetSubString(str_encoded, 18, 23))); \
	key_out = llDumpList2String([ \
		llGetSubString(key_out, 0, 7), \
		llGetSubString(key_out, 8, 11), \
		llGetSubString(key_out, 12, 15), \
		llGetSubString(key_out, 16, 19), \
		llGetSubString(key_out, 20, 31) \
	],"-"); \
}
#define __Base64_To_Key_1( str_encoded ) __Base64_To_Key_2( str_encoded, str_encoded )
#define KCLib$Base64_To_Key(...) OVERLOAD(__Base64_To_Key_, __VA_ARGS__)(__VA_ARGS__)

key KCLib_Base64_To_Key( string str_key ) {
	KCLib$Base64_To_Key( str_key, str_key )
	return (key)str_key;
}



/*============================

				Keys <> BaseN

============================*/

#include "./KC_Num.lsl"
#include "./KC_BaseN.lsl"

/*
	Base used for BaseN encoding

Defaults to Base127
That is the largest base possible within LSL and UTF-8 while remaining at 1-byte per char
This is the current "ideal" base for max key storage in LSD due to the native UTF-8 structure

LSL strings are UTF-16, so base can be much higher due to the minimum 2-bytes per char

KC_KEYS_ENCODED_OFFSET

*/
#ifndef KC_KEYS_ENCODED_BASE
#define KC_KEYS_ENCODED_BASE 127
#endif


/*
	Char/Ord offset of encoded chars

At a minimum, this needs to be 1 as NULL is not usable in LSL,
which is why the max 7-bit base is 127 and not 128.
*/
#ifndef KC_KEYS_ENCODED_OFFSET
#define KC_KEYS_ENCODED_OFFSET 1
#endif


/*
	Key <> Base-FFFF conversion

65536 is the size of 4 hex chars
This is a convenient base since keys can easily be cut in to 4 char sections

Do not change
*/
#define KC_KEYS_KEY_BASE 0xFFFF

/*
	KCLib$Key_To_IntList

key_in: UUID, can be key type or string
returns: list of integers of base FFFF
*/
#define KCLib$Key_To_IntList( key_in ) [ \
	KCLib$Hex_To_Int(llGetSubString(key_in, 0, 3)), \
	KCLib$Hex_To_Int(llGetSubString(key_in, 4, 7)), \
	KCLib$Hex_To_Int(llGetSubString(key_in, 9, 12)), \
	KCLib$Hex_To_Int(llGetSubString(key_in, 14, 17)), \
	KCLib$Hex_To_Int(llGetSubString(key_in, 19, 22)), \
	KCLib$Hex_To_Int(llGetSubString(key_in, 24, 27)), \
	KCLib$Hex_To_Int(llGetSubString(key_in, 28, 31)), \
	KCLib$Hex_To_Int(llGetSubString(key_in, 32, 35)) \
]

/*
	KCLib$IntList_To_Key

lst_in: list of integers of base FFFF
key_out: UUID, can be key type or string
*/
#define KCLib$IntList_To_Key( lst_in, key_out ) { \
	key_out = KCLib_Int_To_Hex((llList2Integer(lst_in, 0) << 16) + llList2Integer(lst_in, 1)) \
		+ KCLib_Int_To_Hex((llList2Integer(lst_in, 2) << 16) + llList2Integer(lst_in, 3)) \
		+ KCLib_Int_To_Hex((llList2Integer(lst_in, 4) << 16) + llList2Integer(lst_in, 5)) \
		+ KCLib_Int_To_Hex((llList2Integer(lst_in, 6) << 16) + llList2Integer(lst_in, 7)); \
	key_out = llDumpList2String([ \
		llGetSubString(key_out, 0, 7), \
		llGetSubString(key_out, 8, 11), \
		llGetSubString(key_out, 12, 15), \
		llGetSubString(key_out, 16, 19), \
		llGetSubString(key_out, 20, 31) \
	],"-"); \
}



/*
	Encodes a key to string of base KC_KEYS_ENCODED_BASE
	
If only being called once, the in-line macro is around 500-bytes smaller verses the sub function

if the original value is not needed after encode,
key_input and str_out can be the same string variable to save some memory
*/
#define __Key_BaseN_Encode_2( key_input, str_out ) { \
	list lst_in = KCLib$Key_To_IntList(key_input); \
	KCLib$BaseN_Encode( lst_in, KC_KEYS_KEY_BASE, str_out, KC_KEYS_ENCODED_BASE, KC_KEYS_ENCODED_OFFSET ); \
}
#define __Key_BaseN_Encode_1( keystr_io ) __Key_BaseN_Encode_2( keystr_io, keystr_io )
#define KCLib$Key_BaseN_Encode(...) OVERLOAD(__Key_BaseN_Encode_, __VA_ARGS__)(__VA_ARGS__)

string KCLib_Key_BaseN_Encode( string str_key ) {
	KCLib$Key_BaseN_Encode( str_key )
	return str_key;
}


/*
	Decodes a string of base KC_KEYS_ENCODED_BASE to a key

if the original value is not needed after decode,
str_encoded and key_out can be the same string variable to save some memory
*/
#define __Key_BaseN_Decode_2( str_encoded, key_out ) { \
	list lst_out; \
	KCLib$BaseN_Decode( str_encoded, KC_KEYS_ENCODED_BASE, lst_out, KC_KEYS_KEY_BASE, KC_KEYS_ENCODED_OFFSET ); \
	KCLib$IntList_To_Key( lst_out, key_out ); \
}
#define __Key_BaseN_Decode_1( str_encoded ) __Key_BaseN_Decode_2( str_encoded, str_encoded )
#define KCLib$Key_BaseN_Decode(...) OVERLOAD(__Key_BaseN_Decode_, __VA_ARGS__)(__VA_ARGS__)

key KCLib_Key_BaseN_Decode( string str_key ) {
	KCLib$Key_BaseN_Decode( str_key, str_key )
	return (key)str_key;
}



/*============================

				KCLib_isKey

Extended key test
2: valid key, not NULL_KEY
1: NULL_KEY
0: not a key
============================*/
integer KCLib_isKey(key in) {
    if (in)
        return 2;
    return (in == NULL_KEY);
}


#endif //KC_KEYS
