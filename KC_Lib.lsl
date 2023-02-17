/*
	KC Lib, version: yes
	
Kadah Coba, 2023

What:
A collection of random universal functions to make life more complicated
A random collection of useful code and mostly macros
An assortment of code that I cannot figured out what it does or how it works
Random answers to questions somebody or nobody asked


Tips:
When both a macro and function version are provided. Use the macro instead if only calling the code a few times.
Functions can have a few hundred byte penalty, not counting additional usage for arguments.

Can include this file to have everything available,
or just the individual modules needed to speed up preproc processing,
or just copy out and modify as needed.

*/
#ifndef KC_LIB
#define KC_LIB

#include "./preproc/KC_Stringize.lsl"
#include "./preproc/KC_CAT.lsl"
#include "./preproc/KC_OVERLOAD.lsl"

#include "./KC_Num.lsl"
#include "./KC_BaseN.lsl"
#include "./KC_Base91.lsl"
#include "./KC_Base127.lsl"
#include "./KC_Base32k.lsl"
#include "./KC_Base1T.lsl"
#include "./KC_Keys.lsl"

#include "./KC_List_Serializer.lsl"

#include "./KC_Time.lsl"

#include "./KC_Bin_to_Hex.lsl"
#include "./KC_Dec_to_Hex.lsl"
#include "./KC_Bin_to_Dec.lsl"

#include "./KC_Progress.lsl"

#endif //KC_LIB
