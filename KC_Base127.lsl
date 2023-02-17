/*

	Base127 <> list[ints]
	
Encode/decodes list of integers to/from base127-or-less string.

Its like Base128, but worse so it works within LSL not allowing U+0
2 chars encode 14-bits or 13-bit to account for the half-bit loss.

Loosely based off https://base91.sourceforge.net/
but taken to the extreme to maximize the usable bits available in LSL and UTF-8

DO NOT USE WITH LinkSetData, will break rez due to BUG-233015

*/
#ifndef KCBASE127
	#define KCBASE127

/*
	Encoding Base

Anything from 91 to 127 should work
>127 requires too many bits.
*/
#if !defined(KCBASE127_BASE)
#define KCBASE127_BASE 127
#endif


/*
Magic number to account for the half-bit
All values <= it overlap with all 14-bit values

Use this formula to calculate for other bases:
(base^2 - 1) % (2^13)

Notable values:

base91	88
base92	271
base93	456
base94	643
base95	832
base96	1023
base97	1216
base98	1411
base99	1608
base100	1807
base101	2008
base102	2211
base103	2416
base104	2623
base105	2832
base106	3043
base107	3256
base108	3471
base109	3688
base110	3907
base111	4128
base112	4351
base113	4576
base114	4803
base115	5032
base116	5263
base117	5496
base118	5731
base119	5968
base120	6207
base121	6448
base122	6691
base123	6936
base124	7183
base125	7432
base126	7683
base127	7936
*/
#if !defined(KCBASE127_MAGIC_NUMBER)
#define KCBASE127_MAGIC_NUMBER 7936
#endif



#if !defined(KCBASE127_ENCTAB)
#define KCBASE127_ENCTAB( int_char ) llChar(int_char + 1)
#endif

#if !defined(KCBASE127_DECTAB)
#define KCBASE127_DECTAB( string_buffer, int_index ) (llOrd(string_buffer, int_index) - 1)
#endif




string KCLib_Base127_Encode(list in) {
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
				val = queue & 0x1FFF;
				if (val > KCBASE127_MAGIC_NUMBER) {
					queue = queue>> 13;
					queue_nbits -= 13;
				} else {	// we can take 14 bits
					val = queue & 0x3FFF;
					queue = queue >> 14;
					queue_nbits -= 14;
				}
				encoded += KCBASE127_ENCTAB(val % KCBASE127_BASE) + KCBASE127_ENCTAB(val / KCBASE127_BASE); 
			} while (queue_nbits > 13);
		}
	}
	
	if (queue_nbits) {
		encoded += KCBASE127_ENCTAB(queue % KCBASE127_BASE);
		if ((queue_nbits > 7) || (queue >= KCBASE127_BASE)) encoded += KCBASE127_ENCTAB(queue / KCBASE127_BASE);
	}
	
	return encoded;
}


list KCLib_Base127_Decode(string encoded) {
	list decoded;
	integer len = llStringLength(encoded);
	integer i; 
	integer output_buffer; 
	integer output_nbits;
	integer queue;
	integer queue_nbits;
	integer val = -1;
	integer input_buffer;

	while (i < len) {
		input_buffer = KCBASE127_DECTAB(encoded, i);
		i++;
		
		if (input_buffer < KCBASE127_BASE) { // ignore non-alphabet chars
			if (val == -1)
				val = input_buffer;	// start next value
			else {
				val += input_buffer * KCBASE127_BASE;
				queue = queue | (val << queue_nbits);
				if ((val & 0x1FFF) > KCBASE127_MAGIC_NUMBER) queue_nbits += 13;
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

#endif //KCBASE127
