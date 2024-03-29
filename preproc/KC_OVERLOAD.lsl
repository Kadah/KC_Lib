/*
	Preproc Macro Overload

Functionally similar to BOOST_PP_OVERLOAD(prefix,...)
https://www.boost.org/doc/libs/1_81_0/libs/preprocessor/doc/index.html

Usage:

prefix for the non-variadic macro name
Variadic size is appended to the prefix to make the non-variadic macro name

Example: See KC_Bin_to_Hex.lsl
*/

#ifndef KCOVERLOAD
	#define KCOVERLOAD
	
	#include "./KC_CAT.lsl"
	
	// Shortened from boost/preprocessor/variadic/size.hpp
	#define VARIADIC_SIZE(...) VARIADIC_SIZE_I(__VA_ARGS__, 64, 63, 62, 61, 60, 59, 58, 57, 56, 55, 54, 53, 52, 51, 50, 49, 48, 47, 46, 45, 44, 43, 42, 41, 40, 39, 38, 37, 36, 35, 34, 33, 32, 31, 30, 29, 28, 27, 26, 25, 24, 23, 22, 21, 20, 19, 18, 17, 16, 15, 14, 13, 12, 11, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1,)
	#define VARIADIC_SIZE_I(e0, e1, e2, e3, e4, e5, e6, e7, e8, e9, e10, e11, e12, e13, e14, e15, e16, e17, e18, e19, e20, e21, e22, e23, e24, e25, e26, e27, e28, e29, e30, e31, e32, e33, e34, e35, e36, e37, e38, e39, e40, e41, e42, e43, e44, e45, e46, e47, e48, e49, e50, e51, e52, e53, e54, e55, e56, e57, e58, e59, e60, e61, e62, e63, size, ...) size

	// Shortened from boost/preprocessor/facilities/overload.hpp
	#define OVERLOAD(prefix, ...) CAT(prefix, VARIADIC_SIZE(__VA_ARGS__))

#endif //KCOVERLOAD
