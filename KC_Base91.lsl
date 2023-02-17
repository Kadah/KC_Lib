/*
	Base91

BasE91, with a capital E
https://base91.sourceforge.net/
Is optionally compatible with this implementation if using the lookup tables.
But has extra memory overhead verse llChar/llOrd.
	
TODO: cleanup
*/

#ifndef KCBASE91
	#define KCBASE91




// BasE91 compat mode, requires more script time and mem
list enctab = [
	"A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M",
	"N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z",
	"a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m",
	"n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z",
	"0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "!", "#", "$",
	"%", "&", "(", ")", "*", "+", ",", ".", "/", ":", ";", "<", "=",
	">", "?", "@", "[", "]", "^", "_", "`", "{", "|", "}", "~", "\""
];
// string enctab_string = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789!#$%&()*+,./:;<=>?@[]^_`{|}~\"";
list dectab = [
	91, 91, 91, 91, 91, 91, 91, 91, 91, 91, 91, 91, 91, 91, 91, 91,
	91, 91, 91, 91, 91, 91, 91, 91, 91, 91, 91, 91, 91, 91, 91, 91,
	91, 62, 90, 63, 64, 65, 66, 91, 67, 68, 69, 70, 71, 91, 72, 73,
	52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 74, 75, 76, 77, 78, 79,
	80,  0,  1,  2,  3,  4,  5,  6,  7,  8,  9, 10, 11, 12, 13, 14,
	15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 81, 91, 82, 83, 84,
	85, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40,
	41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 86, 87, 88, 89, 91,
	91, 91, 91, 91, 91, 91, 91, 91, 91, 91, 91, 91, 91, 91, 91, 91,
	91, 91, 91, 91, 91, 91, 91, 91, 91, 91, 91, 91, 91, 91, 91, 91,
	91, 91, 91, 91, 91, 91, 91, 91, 91, 91, 91, 91, 91, 91, 91, 91,
	91, 91, 91, 91, 91, 91, 91, 91, 91, 91, 91, 91, 91, 91, 91, 91,
	91, 91, 91, 91, 91, 91, 91, 91, 91, 91, 91, 91, 91, 91, 91, 91,
	91, 91, 91, 91, 91, 91, 91, 91, 91, 91, 91, 91, 91, 91, 91, 91,
	91, 91, 91, 91, 91, 91, 91, 91, 91, 91, 91, 91, 91, 91, 91, 91,
	91, 91, 91, 91, 91, 91, 91, 91, 91, 91, 91, 91, 91, 91, 91, 91
];
// #define get_BasE91_enctab( int_char ) llList2String(enctab, (int_char))
// #define get_BasE91_enctab( int_char ) llGetSubString(enctab_string, (int_char), (int_char))

// #define get_BasE91_dectab( string_buffer, int_index ) llList2Integer(dectab, llOrd(string_buffer, int_index))
// #define get_BasE91_dectab( string_buffer, int_index ) llListFindList(enctab, [llGetSubString(string_buffer, int_index, int_index)])
// #define get_BasE91_dectab( string_buffer, int_index ) llSubStringIndex(enctab_string, llGetSubString(string_buffer, int_index, int_index))


// offset by 36 to use $ thru ~ of ASCII
#define get_BasE91_enctab( int_char ) llChar(int_char + 36)
#define get_BasE91_dectab( string_buffer, int_index ) (llOrd(string_buffer, int_index) - 36);


#define BaseE91_valid_char( int_char ) (int_char < 91)

/*

string KCLib_BasE91_Encode(list in) {
	string encoded;
	
	integer len = llGetListLength(in);
	
	integer _BaseN_i; 
	
	integer input_buffer; 
	integer input_nbits;
	
	integer queue;
	integer queue_nbits;
	integer val;
	
	list debug_output;
	
	while( _BaseN_i < len ){

		input_buffer = llList2Integer(in, _BaseN_i);
		input_nbits = 32;
		_BaseN_i++;
		
		while( input_nbits ){
		
			debug_output += input_buffer & 0xFF;
			
			queue = queue | ((input_buffer & 0xFF) << queue_nbits);
			queue_nbits += 8;
			
			input_buffer = input_buffer >> 8;
			input_nbits -= 8;
			
			if (queue_nbits > 13) {	// enough bits in queue
				val = queue & 0x1FFF;

				// Why is 88 special?
				// All values <= 88 overlap with all 14-bit values
				// (91^2 - 1) % (2^13)
				// (base^2 - 1) % (2^abs(log2(base^2 - 1)))
				if (val > 88) {
					queue = queue>> 13;
					queue_nbits -= 13;
				} else {	// we can take 14 bits
					val = queue & 0x3FFF;
					queue = queue >> 14;
					queue_nbits -= 14;
				}
				encoded += get_BasE91_enctab(val % 91) + get_BasE91_enctab(val / 91);
			}
		}
	}
	
	if (queue_nbits) {
		encoded += get_BasE91_enctab(queue % 91);
		if ((queue_nbits > 7) || (queue > 90))
			encoded += get_BasE91_enctab(queue / 91);
	}
	
	return encoded;
}
*/

/*
list KCLib_BasE91_Decode(string encoded) {
	list decoded;
	
	integer len = llStringLength(encoded);
	
	integer _BaseN_i; 
	
	integer output_buffer; 
	integer output_nbits;
	
	
	integer queue;
	integer queue_nbits;
	integer val = -1;
	integer d;
	

	while(_BaseN_i < len) {
		
		d = get_BasE91_dectab(encoded, _BaseN_i);
		_BaseN_i++;
		
		if BaseE91_valid_char(d) { // ignore non-alphabet chars
			if (val == -1)
				val = d;	// start next value
			else {
				val += d * 91;
				queue = queue | (val << queue_nbits);
				if ((val & 0x1FFF) > 88) queue_nbits += 13;
				else queue_nbits += 14;
				
				do {
					// pop 8 bits to the output buffer
					output_buffer = output_buffer | ((queue & 0xFF) << output_nbits);
					output_nbits += 8;
					queue = queue >> 8;
					queue_nbits -= 8;
					
					// flush buffer when full
					if (output_nbits == 32) {
						decoded += output_buffer;
						output_buffer = 0;
						output_nbits = 0;
					}
					
				} while (queue_nbits > 7);
				val = -1;	// mark value complete
			}
		}
	}
	
	if (val != -1) {
		queue = queue | (val << queue_nbits);
		output_buffer = output_buffer | (queue << output_nbits);
		decoded += output_buffer;
	}

	return decoded;
}
*/




// offset by 36 to use $ thru ~ of ASCII
// #define get_BasE91_enctab( int_char ) llChar(int_char + 36)
// #define get_BasE91_dectab( string_buffer, int_index ) (llOrd(string_buffer, int_index) - 36);
// #define BaseE91_valid_char( int_char ) (int_char < 91)


string KCLib_BasE91_Encode(list in) {
	string encoded;
	
	integer len = llGetListLength(in);
	
	integer _BaseN_i; 
	
	integer input_buffer; 
	integer input_nbits;
	
	integer queue;
	integer queue_nbits;
	integer val;
	
	while( _BaseN_i < len ){
		input_buffer = llList2Integer(in, _BaseN_i);
		input_nbits = 2; // gives 2 loops, bits are popped off 16 at a time
		_BaseN_i++;
		
		while( input_nbits-- ) {
			queue = queue | ((input_buffer & 0xFFFF) << queue_nbits);
			queue_nbits += 16;
			input_buffer = input_buffer >> 16;
			
			// there will always be enough bits in queue, but there might be twice as many
			do {
				// Why is 88 special?
				// All values <= 88 overlap with all 14-bit values
				// (91^2 - 1) % (2^13)
				// (base^2 - 1) % (2^abs(log2(base^2 - 1)))
				val = queue & 0x1FFF;
				if (val > 88) {
					queue = queue>> 13;
					queue_nbits -= 13;
				} else {	// we can take 14 bits
					val = queue & 0x3FFF;
					queue = queue >> 14;
					queue_nbits -= 14;
				}
				encoded += get_BasE91_enctab(val % 91) + get_BasE91_enctab(val / 91);
			} while (queue_nbits > 13);
		}
	}
	
	if (queue_nbits) {
		encoded += get_BasE91_enctab(queue % 91);
		if ((queue_nbits > 7) || (queue > 90)) encoded += get_BasE91_enctab(queue / 91);
	}
	
	return encoded;
}


list KCLib_BasE91_Decode(string encoded) {
	list decoded;
	
	integer len = llStringLength(encoded);
	
	integer _BaseN_i; 
	
	integer output_buffer; 
	integer output_nbits;
	
	
	integer queue;
	integer queue_nbits;
	integer val = -1;
	integer input_buffer;
	

	while(_BaseN_i < len) {
		
		input_buffer = get_BasE91_dectab(encoded, _BaseN_i);
		_BaseN_i++;
		
		if BaseE91_valid_char(input_buffer) { // ignore non-alphabet chars
			if (val == -1)
				val = input_buffer;	// start next value
			else {
				val += input_buffer * 91;
				queue = queue | (val << queue_nbits);
				if ((val & 0x1FFF) > 88) queue_nbits += 13;
				else queue_nbits += 14;
				
				// pop 16 bits to the output buffer
				// a loop is not required here as it is impossible to overflow
				if (queue_nbits >= 16) {
					output_buffer = output_buffer | ((queue & 0xFFFF) << output_nbits);
					output_nbits += 16;
					queue = queue >> 16;
					queue_nbits -= 16;
				
					// flush buffer when full
					if (output_nbits == 32) {
						decoded += output_buffer;
						output_buffer = 0;
						output_nbits = 0;
					}
				}
				val = -1;	// mark value complete
			}
		}
	}
	
	if (val != -1) {
		queue = queue | (val << queue_nbits);
		output_buffer = output_buffer | (queue << output_nbits);
		decoded += output_buffer;
	}

	return decoded;
}


#endif //KCBASE91
