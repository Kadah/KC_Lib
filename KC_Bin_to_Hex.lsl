/*
	Binary > Hex preproc macro

General preprocessor abuse to convert binary numbers in to hex at compile time

Credits:
http://www.cakoose.com/wiki/c_preprocessor_abuse
https://web.archive.org/web/20170119015350/http://cakoose.com/wiki-support/BinaryLiteral.h
LSL preproc port and additional stuff by Kadah


Usage:
	
Invoke BIN(b1,b2,...,b8). Where each arg is a 4 digit binary number.
Marco is overloaded, so use between 1 to 8 args as needed.


Example:
	
BIN(0101) expands to 0x5
BIN(1111,1111,1111,1111) expands to 0xffff
BIN(1101,1110,1010,1101,1011,1110,1110,1111) expands to 0xdeadbeef

*/

#ifndef KCBIN2HEX
#define KCBIN2HEX

#include "./preproc/KC_OVERLOAD.lsl"


#define BIN_0000 0
#define BIN_0001 1
#define BIN_0010 2
#define BIN_0011 3
#define BIN_0100 4
#define BIN_0101 5
#define BIN_0110 6
#define BIN_0111 7
#define BIN_1000 8
#define BIN_1001 9
#define BIN_1010 a
#define BIN_1011 b
#define BIN_1100 c
#define BIN_1101 d
#define BIN_1110 e
#define BIN_1111 f

#define BIN_4_HEXIFY(b1) 0x ## b1
#define BIN_4_RELAY(b1) BIN_4_HEXIFY(b1)
#define BIN_4(b1) BIN_4_RELAY(BIN_##b1)

#define BIN_8_HEXIFY(b1,b2) 0x ## b1 ## b2
#define BIN_8_RELAY(b1,b2) BIN_8_HEXIFY(b1, b2)
#define BIN_8(b1,b2) BIN_8_RELAY(BIN_##b1, BIN_##b2)

#define BIN_12_HEXIFY(b1,b2,b3) 0x ## b1 ## b2 ## b3
#define BIN_12_RELAY(b1,b2,b3) BIN_12_HEXIFY(b1, b2, b3)
#define BIN_12(b1,b2,b3) BIN_12_RELAY(BIN_##b1, BIN_##b2, BIN_##b3)

#define BIN_16_HEXIFY(b1,b2,b3,b4) 0x ## b1 ## b2 ## b3 ## b4
#define BIN_16_RELAY(b1,b2,b3,b4) BIN_16_HEXIFY(b1, b2, b3, b4)
#define BIN_16(b1,b2,b3,b4) BIN_16_RELAY(BIN_##b1, BIN_##b2, BIN_##b3, BIN_##b4)

#define BIN_20_HEXIFY(b1,b2,b3,b4,b5) 0x ## b1 ## b2 ## b3 ## b4 ## b5
#define BIN_20_RELAY(b1,b2,b3,b4,b5) BIN_20_HEXIFY(b1, b2, b3, b4, b5)
#define BIN_20(b1,b2,b3,b4,b5) BIN_20_RELAY(BIN_##b1, BIN_##b2, BIN_##b3, BIN_##b4, BIN_##b5)

#define BIN_24_HEXIFY(b1,b2,b3,b4,b5,b6) 0x ## b1 ## b2 ## b3 ## b4 ## b5 ## b6
#define BIN_24_RELAY(b1,b2,b3,b4,b5,b6) BIN_24_HEXIFY(b1, b2, b3, b4, b5, b6)
#define BIN_24(b1,b2,b3,b4,b5,b6) BIN_24_RELAY(BIN_##b1, BIN_##b2, BIN_##b3, BIN_##b4, BIN_##b5, BIN_##b6)

#define BIN_28_HEXIFY(b1,b2,b3,b4,b5,b6,b7) 0x ## b1 ## b2 ## b3 ## b4 ## b5 ## b6 ## b7
#define BIN_28_RELAY(b1,b2,b3,b4,b5,b6,b7) BIN_28_HEXIFY(b1, b2, b3, b4, b5, b6, b7)
#define BIN_28(b1,b2,b3,b4,b5,b6,b7) BIN_28_RELAY(BIN_##b1, BIN_##b2, BIN_##b3, BIN_##b4, BIN_##b5, BIN_##b6, BIN_##b7)

#define BIN_32_HEXIFY(b1,b2,b3,b4,b5,b6,b7,b8) 0x ## b1 ## b2 ## b3 ## b4 ## b5 ## b6 ## b7 ## b8
#define BIN_32_RELAY(b1,b2,b3,b4,b5,b6,b7,b8) BIN_32_HEXIFY(b1, b2, b3, b4, b5, b6, b7, b8)
#define BIN_32(b1,b2,b3,b4,b5,b6,b7,b8) BIN_32_RELAY(BIN_##b1, BIN_##b2, BIN_##b3, BIN_##b4, BIN_##b5, BIN_##b6, BIN_##b7, BIN_##b8)

#define BIN1(b1) BIN_4_RELAY(BIN_##b1)
#define BIN2(b1,b2) BIN_8_RELAY(BIN_##b1, BIN_##b2)
#define BIN3(b1,b2,b3) BIN_12_RELAY(BIN_##b1, BIN_##b2, BIN_##b3)
#define BIN4(b1,b2,b3,b4) BIN_16_RELAY(BIN_##b1, BIN_##b2, BIN_##b3, BIN_##b4)
#define BIN5(b1,b2,b3,b4,b5) BIN_20_RELAY(BIN_##b1, BIN_##b2, BIN_##b3, BIN_##b4, BIN_##b5)
#define BIN6(b1,b2,b3,b4,b5,b6) BIN_24_RELAY(BIN_##b1, BIN_##b2, BIN_##b3, BIN_##b4, BIN_##b5, BIN_##b6)
#define BIN7(b1,b2,b3,b4,b5,b6,b7) BIN_28_RELAY(BIN_##b1, BIN_##b2, BIN_##b3, BIN_##b4, BIN_##b5, BIN_##b6, BIN_##b7)
#define BIN8(b1,b2,b3,b4,b5,b6,b7,b8) BIN_32_RELAY(BIN_##b1, BIN_##b2, BIN_##b3, BIN_##b4, BIN_##b5, BIN_##b6, BIN_##b7, BIN_##b8)

#define BIN(...) OVERLOAD(BIN, __VA_ARGS__)(__VA_ARGS__)


#endif //KCBIN2HEX
