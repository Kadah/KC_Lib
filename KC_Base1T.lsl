/*

	Base1T <> list
	aka Base1099511627776
	aka Kadah shoving a 40-bits in to two Unicode characters
	
	Encode/decodes list of stuff to/from Base1T string
	
	Character set: U+80..U+D7FF, U+E000..U+FFEF, U+10000..U+10FFFF

TODO: unfinished experiment, use with caution

*/
#ifndef KCBASE1T
	#define KCBASE1T

/*
	Character Set
	
	
*/
#if !defined(KCBASE32K_CHAR_OFFSET)
#define KCBASE32K_CHAR_OFFSET 0x5800
#endif

#if !defined(KCBASE32K_ENCTAB)
#define KCBASE32K_ENCTAB( int_char ) llChar(int_char + KCBASE32K_CHAR_OFFSET)
#endif

#if !defined(KCBASE32K_DECTAB)
#define KCBASE32K_DECTAB( string_buffer, int_index ) (llOrd(string_buffer, int_index) - KCBASE32K_CHAR_OFFSET)
#endif


/* Re-indexing
FirstChar	LastChar		Size				StartIndex	Offset
U+80				U+D7FF			0xD780			0x0				0x80
U+E000			U+FFEF			0x1FF0			0xD780			0x880
U+10000		U+10FFFF		0x100000		0xF770			0x890

Size: LastChar - FirstChar
StartIndex: Sum size of all previous ranges
Offset: Size of all gaps current and previous ranges
*/

integer KCLib_Base1T_Encode_Char_Offset(integer buffer) {
	if (buffer >= 0xF770) { // larger than the size of the first 2 ranges
		return buffer + 0x890;
	}
	else if (buffer >= 0xD780) { // larger than the first range
		return buffer + 0x880;
	}
	return buffer + 0x80;
}

integer KCLib_Base1T_Decode_Char_Offset(integer buffer) {
	if (buffer >= 0x10000) {
		return buffer - 0x890;
	}
	else if (buffer >= 0xE000) {
		return buffer - 0x880;
	}
	return buffer - 0x80;
}


string KCLib_Base1Ta_Encode(list in) {
	string encoded;
	integer len = llGetListLength(in);
	integer iter;
	integer input_buffer; 
	while (iter < len) {
		input_buffer = llList2Integer(in, iter++);
		encoded += llChar( KCLib_Base1T_Encode_Char_Offset(input_buffer & 0xFFFFF) );
		encoded += llChar( KCLib_Base1T_Encode_Char_Offset((input_buffer >> 20) & 0xFFF) );
	}
	
	return encoded;
}


list KCLib_Base1Ta_Decode(string encoded) {
	list decoded;
	integer len = llStringLength(encoded);
	integer iter;
	while (iter < len) {
		decoded += [
			KCLib_Base1T_Decode_Char_Offset(llOrd(encoded, iter)) |
			(KCLib_Base1T_Decode_Char_Offset(llOrd(encoded, iter+1)) << 20)
		];
		iter += 2;
	}
	return decoded;
}



#if !defined(KCBASE1T_BASE)
#define KCBASE1T_BASE 1111917
// #define KCBASE1T_BASE 1111916
#endif

#if !defined(KCBASE1T_MAGIC_NUMBER)
#define KCBASE1T_MAGIC_NUMBER 136847787112
// #define KCBASE1T_MAGIC_NUMBER 136845563279
#endif

#if !defined(KCBASE1T_ENCTAB)
#define KCBASE1T_ENCTAB( int_char ) llChar(KCLib_Base1T_Encode_Char_Offset(int_char))
#endif

#if !defined(KCBASE1T_DECTAB)
#define KCBASE1T_DECTAB( string_buffer, int_index ) KCLib_Base1T_Decode_Char_Offset(llOrd(string_buffer, int_index))
#endif


integer loops_enc;
integer loops_dec;

string KCLib_Base1T_Encode(list in) {
	string encoded;
	integer len = llGetListLength(in);
	integer i; 
	integer input_buffer; 
	integer input_nbits;
	integer queue;
	integer queue_nbits;
	integer val;
	integer take_nbits;
	
	loops_enc = 0;
	
	while (i < len) {
		// encoded += llChar(llList2Integer(in, i));
		// encoded += KCLib$Integer_To_Base64(llList2Integer(in, i));
		// i++;
		
		input_buffer = llList2Integer(in, i);
		input_nbits = 32;
		i++;
		
		do {
			take_nbits = 32 - queue_nbits;
			if (take_nbits >= input_nbits) take_nbits = input_nbits;
			
			queue = queue | (( input_buffer & KCLib_Bitmask(take_nbits) ) << queue_nbits);
			queue_nbits += take_nbits;
			input_nbits -= take_nbits;
			input_buffer = (input_buffer >> take_nbits) & KCLib_Bitmask(input_nbits);
			
			if (queue_nbits >= 21) {
				val = queue & 0xFFFFF;
				if (val > KCBASE1T_MAGIC_NUMBER) {
					queue = (queue >> 20) & 0xFFF;
					queue_nbits -= 20;
				} else {	// can take +1 bits
					val = queue & 0x1FFFFF;
					queue = (queue >> 21) & 0x7FF;
					queue_nbits -= 21;
				}
				encoded += KCBASE1T_ENCTAB(val);
			}
			loops_enc++;
		} while ( input_nbits > 0 );
	}
	
	if (queue_nbits) {
		encoded += KCBASE1T_ENCTAB(queue);
	}
	
	return encoded;
}


list KCLib_Base1T_Decode(string encoded) {
	list decoded;
	integer len = llStringLength(encoded);
	integer i; 
	integer queue_buffer;
	integer queue_nbits;
	integer val = -1;
	integer input_buffer;
	
	integer take_nbits;
	
	loops_dec = 0;
	/*
	integer output_buffer;
	integer output_nbits;
	
	while (i < len) {
		input_buffer = KCBASE1T_DECTAB(encoded, i);
		i++;
		
		if (input_buffer < KCBASE1T_BASE) { // ignore non-alphabet chars
			queue_buffer = queue_buffer | (input_buffer << queue_nbits);
			if ((input_buffer & 0xFFFFF) > KCBASE1T_MAGIC_NUMBER) queue_nbits += 20;
			else queue_nbits += 21;
			
			// if (queue_nbits >= 32) {
				// llOwnerSay("dec queue_nbits: " + (string)queue_nbits);
			// }
			
			// pop 8 bits to the output buffer
			do {
				if (queue_nbits >= 8) {
					output_buffer = output_buffer | ((queue_buffer & 0xFF) << output_nbits);
					output_nbits += 8;
					queue_buffer = (queue_buffer >> 8) & 0xFFFFFF;
					queue_nbits -= 8;
					
					// flush buffer when full
					if (output_nbits == 32) {
						decoded += output_buffer;
						output_buffer = 0;
						output_nbits = 0;
					}
				}
				loops_dec++;
			} while ( queue_nbits >= 8 );
		}
	}
	*/
	
	
	while (i < len) {
		// decoded += llOrd(encoded, i);
		// decoded += KCLib$Base64_To_Integer(llGetSubString(encoded, i, i+5));
		// i += 6;
		
		input_buffer = KCBASE1T_DECTAB(encoded, i);
		i++;
		
		if ((input_buffer & 0xFFFFF) > KCBASE1T_MAGIC_NUMBER) input_nbits = 20;
		else input_nbits = 21;
		
		do {
			take_nbits = 32 - queue_nbits;
			if (take_nbits > input_nbits) take_nbits = input_nbits;
			
			queue_buffer = queue_buffer | (( input_buffer & KCLib_Bitmask(take_nbits) ) << queue_nbits);
			queue_nbits += take_nbits;
			input_nbits -= take_nbits;
			input_buffer = (input_buffer >> take_nbits) & KCLib_Bitmask(input_nbits);
			
			// flush buffer when full
			if (queue_nbits == 32) {
				decoded += queue_buffer;
				queue_buffer = 0;
				queue_nbits = 0;
			}
			loops_dec++;
		} while ( input_nbits > 0 );
	}
	
	return decoded;
}


















/*
string KCLib_Base1T_Encode(list in) {
	string encoded;
	integer len = llGetListLength(in) - 1;
	integer input_buffer; 
	while (len-- >= 0) {
		input_buffer = llList2Integer(in, len);
		llOwnerSay((string)len + " " + (string)input_buffer);
		encoded += llChar( KCLib_Base1T_Encode_Char_Offset(input_buffer & 0xFFFFF) );
		encoded += llChar( KCLib_Base1T_Encode_Char_Offset(input_buffer >> 20) );
	}
	
	return encoded;
}


list KCLib_Base1T_Decode(string encoded) {
	list decoded;
	integer len = llStringLength(encoded) - 1;
	while (len >= 0) {
		llOwnerSay((string)len);
		decoded += [
			KCLib_Base1T_Decode_Char_Offset(llOrd(encoded, len-1)) |
			(KCLib_Base1T_Decode_Char_Offset(llOrd(encoded, len)) << 20)
		];
		len -= 2;
	}
	return decoded;
}
*/





// string KCLib_Base1T_Encode(list in) {
	// string encoded;
	// integer len = llGetListLength(in);
	// integer i;
	// integer input_buffer;
	// integer work_buffer;
	// while (i < len) {
		// input_buffer = llList2Integer(in, i++);
		
		// work_buffer = input_buffer & 0xFFFFF;
		// if (work_buffer > 0xF770) // larger than the size of the first 2 ranges
			// encoded += llChar( work_buffer + 0x892 );
		// else if (work_buffer > 0xD780) // larger than the first range
			// encoded += llChar( work_buffer + 0x881 );
		// else 
			// encoded += llChar( work_buffer + 0x80 );
		
		// work_buffer = input_buffer >> 20;
		// if (work_buffer > 0xF770) // larger than the size of the first 2 ranges
			// encoded += llChar( work_buffer + 0x892 );
		// else if (work_buffer > 0xD780) // larger than the first range
			// encoded += llChar( work_buffer + 0x881 );
		// else 
			// encoded += llChar( work_buffer + 0x80 );
	// }
	
	// return encoded;
// }


// list KCLib_Base1T_Decode(string encoded) {
	// list decoded;
	// integer len = llStringLength(encoded);
	// integer i;
	// integer input_buffer;
	// integer output_buffer;
	// while (i < len) {
		
		// input_buffer = llOrd(encoded, i);
		// if (input_buffer > 0x10000)
			// output_buffer = input_buffer - 0x892;
		// else if (input_buffer > 0xE000)
			// output_buffer = input_buffer - 0x881;
		// else
			// output_buffer = input_buffer - 0x80;
		
		// input_buffer = llOrd(encoded, i+1);
		// if (input_buffer > 0x10000)
			// decoded += [ output_buffer | ((input_buffer - 0x892) << 20) ];
		// else if (input_buffer > 0xE000)
			// decoded += [ output_buffer | ((input_buffer - 0x881) << 20) ];
		// else
			// decoded += [ output_buffer | ((input_buffer - 0x80) << 20) ];
		
		// i += 2;
	// }
	// return decoded;
// }





#endif //KCBASE1T
