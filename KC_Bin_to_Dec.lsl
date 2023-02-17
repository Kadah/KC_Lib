/*
	Dec <> Binary

Converts integer to/from a string of binary


Usage:

string should consists of only "1" and "0", no validation preformed.

integer dec = KC_Bin_to_Dec("1111")
string bin = KC_Dec_To_Bin(256)

*/


#ifndef KC_BIN_TO_DEC
	#define KC_BIN_TO_DEC

// http://wiki.secondlife.com/wiki/BinaryDecimalConverter
integer KC_Bin_to_Dec(string val)
{
    integer dec = 0;
    integer i = ~llStringLength(val);
    while(++i)
        dec = (dec << 1) + (integer)llGetSubString(val, i, i);
    return dec;
}
string KC_Dec_To_Bin(integer val)
{
    string binary = (string)(val & 1);
    for(val = ((val >> 1) & 0x7FFFffff); val; val = (val >> 1))
    {
        if (val & 1)
            binary = "1" + binary;
        else
            binary = "0" + binary;
    }
    return binary;
}

#endif //KC_BIN_TO_DEC
