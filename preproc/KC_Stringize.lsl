/*
	Bog standard preproc stringize macro

Converts args to a string literal
*/

#ifndef KC_STRINGIZE
#define KC_STRINGIZE

#define STRINGIZE(...) STRINGIZE_I(__VA_ARGS__)
#define STRINGIZE_I(...) #__VA_ARGS__

#endif //KC_STRINGIZE
