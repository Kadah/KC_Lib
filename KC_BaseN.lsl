/*
	BaseN Library

Coverts lists of integers from one arbitrary base to a list of another arbitrary base
Each list element is essentially a digit

Caveats:
Because this works with arbitrary base on both ends, it is not efficient for converting
root2 bases. It is not fast. It has a non-linear time increase with the size of the input
list and the sizes the bases, probably close to O(n^2) at worst.

Output is not padded, so is not a predictable length
TODO: write optional padding function

Negative numbers may not work as expected, YMMV
TODO: test

Bases greater than 0x3FFFFFFF will cause overflow
First convert S32 to at most base 0xFFFFFF first or U16.
Or just don't use this for lists of integers.
TODO: further testing required.

This BaseN is likely not all that useful outside of niche and edge cases, too many trade-offs.
It is slower and uses more working mem than using native llBase64 or many other methods.
*/

#ifndef KC_BASEN
#define KC_BASEN

/*
	BaseN Conversion

lst_in: list of integers of int_base_in
lst_out: list of integer of int_base_out
*/
#define KCLib$BaseN( lst_in, int_base_in, lst_out, int_base_out ) { \
	integer _BaseN_i; integer _BaseN_work_byte; integer _BaseN_remainder; \
    do { \
        for( _BaseN_i = 0; _BaseN_i < llGetListLength(lst_in); _BaseN_i++ ){ \
            _BaseN_work_byte  = ( _BaseN_remainder * int_base_in ) + llList2Integer( lst_in, _BaseN_i ); \
            lst_in = llListReplaceList( lst_in, [ _BaseN_work_byte / int_base_out ], _BaseN_i, _BaseN_i ); \
            _BaseN_remainder = _BaseN_work_byte % int_base_out; \
        } \
        lst_out = _BaseN_remainder + lst_out; \
        _BaseN_remainder = 0; \
    } while( llListStatistics( LIST_STAT_SUM, lst_in ) > 0 ); \
}

/*
	BaseN Conversion

input: list of integers of base_in
returns: list of integer of base_out
*/
list BaseN( list input, integer base_in, integer base_out) {
    list encoded;
	KCLib$BaseN( input, base_in, encoded, base_out );
    return encoded;
}



/*
	Encode to BaseN

Coverts list of integers from one base to a string in another base
Use built-in llBase64 functions instead of this for Base64

lst_in: list of integers of int_base_in
str_encoded: a int_base_out encoded string
int_char_offset: encoded character offset, at a minimum this needs to be 1 as NULL is not usable in LSL
*/
#define __BaseN_Encode_1( lst_in, int_base_in, str_encoded, int_base_out, int_char_offset ) { \
	str_encoded = ""; \
	integer _BaseN_i; integer _BaseN_work_byte; integer _BaseN_remainder; \
    do { \
        for( _BaseN_i = 0; _BaseN_i < llGetListLength(lst_in); _BaseN_i++ ){ \
            _BaseN_work_byte  = ( _BaseN_remainder * int_base_in ) + llList2Integer( lst_in, _BaseN_i ); \
            lst_in = llListReplaceList( lst_in, [ _BaseN_work_byte / int_base_out ], _BaseN_i, _BaseN_i ); \
            _BaseN_remainder = _BaseN_work_byte % int_base_out; \
        } \
		str_encoded = llChar(_BaseN_remainder + int_char_offset) + str_encoded; \
        _BaseN_remainder = 0; \
    } while( llListStatistics( LIST_STAT_SUM, lst_in ) > 0 ); \
}

#define __BaseN_Encode_0( lst_in, int_base_in, str_encoded, int_base_out ) { \
	__BaseN_Encode_1( lst_in, int_base_in, str_encoded, int_base_out, 1 ) { \
	
#define KCLib$BaseN_Encode(lst_in, int_base_in, str_encoded, int_base_out, ...) \
	OVERLOAD(__BaseN_Encode_, __VA_ARGS__)(lst_in, int_base_in, str_encoded, int_base_out, __VA_ARGS__)

string KCLib_BaseN_Encode(list in, integer base_in, integer base_out, integer char_offset) {
	string encoded;
	KCLib$BaseN_Encode( in, base_in, encoded, base_out, char_offset )
	return encoded;
}

/*
	Decode to BaseN

TODO: might be possible to combine the for look with the BaseN conversion to save some time/mem

str_encoded: a int_base_in encoded string
lst_out: list of integers of int_base_out
int_char_offset: encoded character offset, at a minimum this needs to be 1 as NULL is not usable in LSL
*/
#define __BaseN_Decode_1( str_encoded, int_base_in, lst_out, int_base_out, int_char_offset ) { \
	list lst_in; integer i; \
	for(i = 0; i < llStringLength(str_encoded); i++){ lst_in += llOrd(str_encoded, i) - int_char_offset; } \
	KCLib$BaseN( lst_in, int_base_in, lst_out, int_base_out ); \
}

#define __BaseN_Decode_0( str_encoded, int_base_in, lst_out, int_base_out ) { \
	__BaseN_Decode_1( str_encoded, int_base_in, lst_out, int_base_out, 1 ) { \
	
#define KCLib$BaseN_Decode(str_encoded, int_base_in, lst_out, int_base_out, ...) \
	OVERLOAD(__BaseN_Decode_, __VA_ARGS__)(str_encoded, int_base_in, lst_out, int_base_out, __VA_ARGS__)

list KCLib_BaseN_Decode(string encoded, integer base_in, integer base_out, integer char_offset) {
	list out;
	KCLib$BaseN_Decode( encoded, base_in, out, base_out, char_offset )
	return out;
}



#endif //KC_BASEN
