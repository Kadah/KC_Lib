/*

	Base32k <> list[ints]
	
Encode/decodes list of integers to/from base3k string

Defaults uses character range of U+5800..U+D7FF range
aka the 32768 codepoints before the surrogates blocks.

*/
#ifndef KCBASE32K
	#define KCBASE32K

/*
	Encoding Base / Bits
	
	Base needs to be a square
	Bits must match base
*/
#if !defined(KCBASE32K_BASE)
#define KCBASE32K_BASE 32768
#endif

#if !defined(KCBASE32K_BITS)
#define KCBASE32K_BITS 15
#endif


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




// string KCLib_Base32k_Encode(list in) {
	// string encoded;
	// integer len = llGetListLength(in);
	// integer i; 
	// integer input_buffer; 
	// integer input_nbits;
	// integer queue;
	// integer queue_nbits;
	// integer val;
	
	// while (i < len) {
		// input_buffer = llList2Integer(in, i);
		// input_nbits = 2; // gives 2 loops, bits are popped off 16 at a time
		// i++;
		
		// while( input_nbits-- ) {
			// queue = queue | ((input_buffer & 0xFFFF) << queue_nbits);
			// queue_nbits += 16;
			// input_buffer = input_buffer >> 16;
			
			// // there will always be enough bits in queue, but there might be twice as many as needed
			// do {
				// val = queue & 0x7FFF;
				// queue = queue>> KCBASE32K_BITS;
				// queue_nbits -= KCBASE32K_BITS;
				// encoded += KCBASE32K_ENCTAB(val); 
			// } while (queue_nbits >= KCBASE32K_BITS);
		// }
	// }
	
	// if (queue_nbits) {
		// encoded += KCBASE32K_ENCTAB(queue);
	// }
	
	// return encoded;
// }


// list KCLib_Base32k_Decode(string encoded) {
	// list decoded;
	// integer len = llStringLength(encoded);
	// integer i; 
	// integer output_buffer; 
	// integer output_nbits;
	// integer queue;
	// integer queue_nbits;
	// integer input_buffer;
	
	// while (i < len) {
		// input_buffer = KCBASE32K_DECTAB(encoded, i);
		// i++;
		
		// if ((input_buffer >= 0) || (input_buffer < KCBASE32K_BASE)) { // ignore anything outside of our range
			// queue = queue | (input_buffer << queue_nbits);
			// queue_nbits += 15;
			
			// // pop 16 bits to the output buffer
			// // a loop is not required here as it is impossible to overflow
			// if (queue_nbits >= 16) {
				// output_buffer = output_buffer | ((queue & 0xFFFF) << output_nbits);
				// output_nbits += 16;
				// queue = queue >> 16;
				// queue_nbits -= 16;
				
				// // flush buffer
				// if (output_nbits == 32) {
					// decoded += output_buffer;
					// output_buffer = 0;
					// output_nbits = 0;
				// }
			// }
		// }
	// }
	
	// return decoded;
// }





string KCLib_Base32k_Encode(list in) {
	string encoded;
	integer len = llGetListLength(in);
	integer i; 
	integer input_buffer; 
	integer input_nbits;
	integer queue;
	integer queue_nbits;
	integer val;
	
	while (i < len) {
		input_buffer = llList2Integer(in, i);
		input_nbits = 2; // gives 2 loops, bits are popped off 16 at a time
		i++;
		
		while( input_nbits-- ) {
			queue = queue | ((input_buffer & 0xFFFF) << queue_nbits);
			queue_nbits += 16;
			input_buffer = input_buffer >> 16;
			
			// there will always be enough bits in queue, but there might be twice as many as needed
			do {
				val = queue & 0x7FFF;
				queue = queue>> KCBASE32K_BITS;
				queue_nbits -= KCBASE32K_BITS;
				encoded += KCBASE32K_ENCTAB(val); 
			} while (queue_nbits >= KCBASE32K_BITS);
		}
	}
	
	if (queue_nbits) {
		encoded += KCBASE32K_ENCTAB(queue);
	}
	
	return encoded;
}


list KCLib_Base32k_Decode(string encoded) {
	list decoded;
	integer len = llStringLength(encoded);
	integer i; 
	integer output_buffer; 
	integer output_nbits;
	integer queue;
	integer queue_nbits;
	integer input_buffer;
	
	while (i < len) {
		input_buffer = KCBASE32K_DECTAB(encoded, i);
		i++;
		
		if ((input_buffer >= 0) || (input_buffer < KCBASE32K_BASE)) { // ignore anything outside of our range
			queue = queue | (input_buffer << queue_nbits);
			queue_nbits += 15;
			
			// pop 16 bits to the output buffer
			// a loop is not required here as it is impossible to overflow
			if (queue_nbits >= 16) {
				output_buffer = output_buffer | ((queue & 0xFFFF) << output_nbits);
				output_nbits += 16;
				queue = queue >> 16;
				queue_nbits -= 16;
				
				// flush buffer
				if (output_nbits == 32) {
					decoded += output_buffer;
					output_buffer = 0;
					output_nbits = 0;
				}
			}
		}
	}
	
	return decoded;
}

#endif //KCBASE32K
