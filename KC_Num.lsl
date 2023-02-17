/*
	KC Num Library

Collection of number util


TODO: additional cleanup
TODO: finish documentation
*/

#ifndef KC_NUM
#define KC_NUM

/*============================

				Integer <> Base64

Long integers takes 1-11 characters as a string, they can be transmitted reliably as 6 base64 characters
Only 6 of the 8 chars returned by llIntegerToBase64 are needed
============================*/
#define KCLib$Integer_To_Base64( int_Number ) llGetSubString(llIntegerToBase64(int_Number),0, 5)
#define KCLib$Base64_To_Integer( str_Base64_Int ) llBase64ToInteger(str_Base64_Int)



/*============================
				Hex
============================*/
string KC_HEX_CHARS = "0123456789abcdef";

/*============================

				Hex <> Integer

Converts [0-9A-Fa-f]{1,8} to/from integer
============================*/
#define KCLib$Hex_To_Int( str_upto8char ) ((integer)("0x" + (str_upto8char)))

#define KCLib$Int_To_Hex( int_bits, str_nybbles ) { \
	integer lsn; str_nybbles = ""; \
	do { \
		str_nybbles = llGetSubString(KC_HEX_CHARS, lsn = (int_bits & 0xF), lsn) + str_nybbles; \
		int_bits = (0xfffFFFF & (int_bits >> 4)); \
	} while (llStringLength(str_nybbles) < 8); \
}

// Converts Integer to 8 hex chars without the leading 0x
string KCLib_Int_To_Hex( integer int_bits ) {
	string str_nybbles;
	KCLib$Int_To_Hex( int_bits, str_nybbles ) 
	return str_nybbles;
}


/*============================

				Hex <> Base64

Converts [0-9A-Fa-f]{1,8} to/from Base64
============================*/
#define KCLib$Hex_To_Base64( str_upto8char_hex ) KCLib$Integer_To_Base64( KCLib$Hex_To_Int((str_upto8char_hex)) )
#define KCLib$Base64_To_Hex( str_Base64_Hex ) KCLib_Int_To_Hex(Base64_To_Integer(str_Base64_Hex))




/*================================================
The next two sections contains magic, dragons and/or pepperoni
=================================================*/

/*============================

				Float > Hex

Converts float to sa[0-9A-Fa-f]{1,8}
http://wiki.secondlife.com/wiki/Float2Hex
Copyright Strife Onizuka, 2006-2007, LGPL, http://www.gnu.org/copyleft/lesser.html or (cc-by) http://creativecommons.org/licenses/by/3.0/
============================*/
string KC_Float_To_Hex(float input) {
    if(input != (integer)input)//LL screwed up hex integers support in rotation & vector string typecasting
    {
        string out = (string)input;
        if(!~llSubStringIndex(out, ".")) return out; //NaN and Infinities, it's quick, it's easy.
        float unsigned = llFabs(input);//logs don't work on negatives.
        integer exponent = llFloor((llLog(unsigned) / 0.69314718055994530941723212145818));//floor(log2(b)) + rounding error
        integer mantissa = (integer)((unsigned / (float)("0x1p"+(string)(exponent -= ((exponent >> 31) | 1)))) * 0x4000000);//shift up into integer range
        integer index = (integer)(llLog(mantissa & -mantissa) / 0.69314718055994530941723212145818);//index of first 'on' bit
        out = "p" + (string)(exponent + index - 26);
        mantissa = mantissa >> index;
        do
            out = llGetSubString(KC_HEX_CHARS, 15 & mantissa, 15 & mantissa) + out;
        while(mantissa = mantissa >> 4);
        if(input < 0)
            return "-0x" + out;
        return "0x" + out;
    }//integers pack well so anything that qualifies as an integer we dump as such, supports negative zero
    return llDeleteSubString((string)input,-7,-1);//trim off the float portion, return an integer
}

/*============================

				Float <> Integer

Converts float to/from integer
http://wiki.secondlife.com/wiki/User:Strife_Onizuka/Float_Functions
============================*/
integer KC_Float_To_Int(float a) {
    if((a)){//is it nonzero?
        integer b = 0x80000000 * (a < 0);//the sign
        if((a = llFabs(a)) < 2.3509887016445750159374730744445e-38)//Denormalized range check & last stride of normalized range
            return b | (integer)(a / 1.4012984643248170709237295832899e-45);//the math overlaps; saves cpu time.
        if(a > 3.4028234663852885981170418348452e+38)//Round up to infinity
            return b | 0x7F800000;//Positive or negative infinity
        if(a > 1.4012984643248170709237295832899e-45){//It should at this point, except if it's NaN
            integer c = ~-llFloor(llLog(a) * 1.4426950408889634073599246810019);//extremes will error towards extremes. following yuch corrects it
            return b | (0x7FFFFF & (integer)(a * (0x1000000 >> c))) | ((126 + (c = ((integer)a - (3 <= (a *= llPow(2, -c))))) + c) * 0x800000);
        }//the previous requires a lot of unwinding to understand it.
        return 0x7FC00000;//NaN time! We have no way to tell NaN's apart so lets just choose one.
    }//Mono does not support indeterminates so I'm not going to worry about them.
    return 0x80000000 * ((string)a == "-0.000000");//for grins, detect the sign on zero. it's not pretty but it works.
}

float KC_Int_To_Float(integer a) {
    if(!(0x7F800000 & ~a))
        return (float)llGetSubString("-infnan", 3 * ~!(a & 0x7FFFFF), ~a >> 31);
    return llPow(2, (a | !a) + 0xffffff6a) * (((!!(a = (0xff & (a >> 23)))) * 0x800000) | (a & 0x7fffff)) * (1 | (a >> 31));
}

/*============================

				Float <> Base64

Converts float to/from integer
http://wiki.secondlife.com/wiki/User:Strife_Onizuka/Float_Functions
============================*/
// Base64-Float
#define KCLib$Float_To_Base64( float_in ) KCLib$Integer_To_Base64(KC_Float_To_Int(float_in))
#define KCLib$Base64_To_Float( str_encoded ) KC_Int_To_Float(KCLib$Base64_To_Integer(str_encoded))



/*============================

				Vector <> Base64

TODO: cleanup
============================*/

// Converts a floored vector within <0,0,0> to <255,255,4095> in to 28-bits integer
#define KCLib$vectorToInteger( vec_Pos ) (((integer)vec_Pos.x & 0xff) | (((integer)vec_Pos.y & 0xff)  << 8) | (((integer)vec_Pos.z & 0xfff) << 16))
#define KCLib$integerToVector( int_Pos ) (< (int_Pos & 0xff), ((int_Pos >> 8) & 0xff), ((int_Pos >> 16) & 0xfff) >)
#define KCLib$integerToX( int_Pos ) (int_Pos & 0xff)
#define KCLib$integerToY( int_Pos ) ((int_Pos >> 8) & 0xff)
#define KCLib$integerToZ( int_Pos ) ((int_Pos >> 16) & 0xfff)
// Same as above but uses the remaining 4-bits for flags/extra data
#define KCLib$vectorToIntegerFlags( vec_Pos, flags ) (((integer)vec_Pos.x & 0xff) | (((integer)vec_Pos.y & 0xff)  << 8) | (((integer)vec_Pos.z & 0xfff) << 16)| ((flags & 0xf) << 28))
#define KCLib$integerToVectorFlags( int_Pos ) ((int_Pos >> 28) & 0xf)
// Removes the flag bits
#define KCLib$integerToVectorInteger( int_Pos ) (int_Pos & 0xfffffff)
// A pure macro implementation, limited to <0,0,0> to <255,255,255>
#define VEC(x, y, z) DEC(z,y,x)


#define KCLib$vectorToBase64( vec_Pos ) (fuis(vec_Pos.x) + fuis(vec_Pos.y) + fuis(vec_Pos.z))
#define KCLib$rotationToBase64( rot_Rot ) (fuis(rot_Rot.x) + fuis(rot_Rot.y) + fuis(rot_Rot.z) + fuis(rot_Rot.s))

#define KCLib$base64ToVector( str_Data, int_Offest ) (< siuf(llGetSubString(str_Data, (0 + int_Offest), (5 + int_Offest))), siuf(llGetSubString(str_Data, (6 + int_Offest), (11 + int_Offest))), siuf(llGetSubString(str_Data, (12 + int_Offest), (17 + int_Offest))) >)
#define KCLib$base64ToRotation( str_Data, int_Offest ) (< siuf(llGetSubString(str_Data, (0 + int_Offest), (5 + int_Offest))), siuf(llGetSubString(str_Data, (6 + int_Offest), (11 + int_Offest))), siuf(llGetSubString(str_Data, (12 + int_Offest), (17 + int_Offest))), siuf(llGetSubString(str_Data, (18 + int_Offest), (23 + int_Offest))) >)








/*============================

				Randon Helpers

TODO: cleanup and move some to own file
============================*/

integer KCLib_Min( integer x, integer y) {
   if( y < x ) return y;
   return x;
}
integer KCLib_Max( integer x, integer y) {
   if( y > x ) return y;
   return x;
}
#define KCLib$Min_Abs( x, y ) (( ( llAbs(x) >= llAbs(y) ) * y ) + ( ( llAbs(x) < llAbs(y) ) * x ))
#define KCLib$Min_Float( x, y ) (( ( llAbs( x >= y ) ) * y ) + ( ( llAbs( x < y ) ) * x ))



// This shortcut template macro takes a vector and expands it for passing to functions that take x,y,z integers
#define VEC_TO_INTS_PRAMS(vec) (integer)vec.x, (integer)vec.y, (integer)vec.z

// Floors valuse in vectors
// String one useful as an alternative to (string)vector for debug output and in comm when decimals are not needed
#define FLOOR_VEC( vec ) (< (integer)vec.x, (integer)vec.y, (integer)vec.z >)
#define FLOOR_VEC_STRING( vec_Pos ) ("<" + (string)((integer)vec_Pos.x) + "," + (string)((integer)vec_Pos.y) + "," + (string)((integer)vec_Pos.z) + ">")

/*
2023-01-27T07:35:32.795008Z
32795008
*/
integer Millisec(string Stamp) {
    return
		(integer)llGetSubString(Stamp, 8, 9) * 86400000 + // Days
        (integer)llGetSubString(Stamp, 11, 12) * 3600000 + // Hours
        (integer)llGetSubString(Stamp, 14, 15) * 60000 + // Minutes
        llRound(((float)llGetSubString(Stamp, 17, -2) * 1000.0)) // Seconds.Milliseconds
        - 617316353; // Offset to fit between [-617316353,2147483547]
}
/*// Released to Public Domain without limitation. Created by Nexii Malthus. //*/



/*
	KCLib_Bitmask
	
Creates bitmask of the given number of bits
If a function because lack of ternary conditional operator :/
*/
integer KCLib_Bitmask( integer bits ) {
   if( bits == 32 ) return -1;
   return (1 <<  bits) - 1;
}



#endif //KC_NUM
