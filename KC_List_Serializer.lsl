/*

	List_Serializer
	
	
TODO: unfinished experiment, do not use
*/
#ifndef KCLISTSERIALIZER
	#define KCLISTSERIALIZER





#if !defined(KCLISTSERIALIZER_ENCHAR)
#define KCLISTSERIALIZER_ENCHAR( int_char ) llChar(KCLib_Base1T_Encode_Char_Offset(int_char))
#endif

#if !defined(KCLISTSERIALIZER_DECHAR)
#define KCLISTSERIALIZER_DECHAR( string_buffer, int_index ) KCLib_Base1T_Decode_Char_Offset(llOrd(string_buffer, int_index))
#endif

string encoded;
integer input_buffer; 
integer input_nbits;
integer queue_buffer;
integer queue_nbits;
integer val;
integer take_nbits;

_encode_block() {
	do {
		take_nbits = 32 - queue_nbits;
		if (take_nbits >= input_nbits) take_nbits = input_nbits;
		
		queue_buffer = queue_buffer | (( input_buffer & KCLib_Bitmask(take_nbits) ) << queue_nbits);
		queue_nbits += take_nbits;
		input_nbits -= take_nbits;
		input_buffer = (input_buffer >> take_nbits) & KCLib_Bitmask(input_nbits);
		
		if (queue_nbits >= 21) {
			val = queue_buffer & 0xFFFFF;
			if (val > KCBASE1T_MAGIC_NUMBER) {
				queue_buffer = (queue_buffer >> 20) & 0xFFF;
				queue_nbits -= 20;
			} else {	// we can take 21 bits
				val = queue_buffer & 0x1FFFFF;
				queue_buffer = (queue_buffer >> 21) & 0x7FF;
				queue_nbits -= 21;
			}
			encoded += KCBASE1T_ENCTAB(val);
		} 
	} while ( input_nbits > 0 );
}


#define _encode_data( nbits, data ) { input_nbits = nbits; input_buffer = data; _encode_block(); }


string KCLib_List_Serialize( list input_list ) {
	integer input_len = llGetListLength(in);
	
	encoded =""
	input_buffer = 0;
	input_nbits = 0;
	queue_buffer = 0;
	queue_nbits = 0;
	val = 0;
	take_nbits = 0;

	
	integer input_index;
	integer input_type;
	
	integer block_header;
	string block_data;
	
	while (input_index < input_len) {
		input_type = llGetListEntryType( input_list, input_index);
		block_header = input_type;
		
		if (input_type == TYPE_STRING) {
			// strings len has a max of 16,383 here, which should excessive.
			block_data = llList2String(input_list, input_index);
			block_header = (block_header | (llStringLength(block_data) << 3)) & 0x3FFF;
			
			_encode_data( 17, block_header );
			
			// push remaining bits
			if (queue_nbits) {
				encoded += KCLISTSERIALIZER_ENCHAR(queue_buffer);
				queue_nbits = 0;
				queue_buffer = 0;
			}
			
			// glue string on to output
			encoded += block_data;
			block_data = "";
			
		}
		else {
			// TODO: encode length of each int to save space
			_encode_data( 3, block_header );
			
			if (input_type == TYPE_INTEGER) {
				_encode_data( 32, llList2Integer(input_list, input_index) );
			}
			else if (input_type == TYPE_FLOAT) {
				_encode_data( 32, KC_Float_To_Int(llList2Float(input_list, input_index)) );
			}
			else if (input_type == TYPE_KEY) {
			}
			else if (input_type == TYPE_VECTOR) {
			}
			else if (input_type == TYPE_ROTATION) {
			}
			
		}
		
		
		input_index++;
	}
	
	if (queue_nbits) {
		encoded += KCLISTSERIALIZER_ENCHAR(queue_buffer);
	}
	
	return encoded;
}


list KCLib_List_Deserialize(string encoded) {
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
		input_buffer = KCBASE1T_DECTAB(encoded, i);
		i++;
		
		if (input_buffer < KCBASE1T_BASE) { // ignore non-alphabet chars
			queue = queue | (input_buffer << queue_nbits);
			if ((input_buffer & 0xFFFFF) > KCBASE1T_MAGIC_NUMBER) queue_nbits += 20;
			else queue_nbits += 21;
			
			// if (queue_nbits >= 32) {
				// llOwnerSay("dec queue_nbits: " + (string)queue_nbits);
			// }
			
			// pop 8 bits to the output buffer
			do {
				if (queue_nbits >= 8) {
					output_buffer = output_buffer | ((queue & 0xFF) << output_nbits);
					output_nbits += 8;
					queue = (queue >> 8) & 0xFFFFFF;
					queue_nbits -= 8;
					
					// flush buffer when full
					if (output_nbits == 32) {
						decoded += output_buffer;
						output_buffer = 0;
						output_nbits = 0;
					}
				}
			} while ( queue_nbits >= 8 );
		}
	}
	return decoded;
}





#endif //KCLISTSERIALIZER
