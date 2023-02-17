/*
	Bog standard preproc concatenate macro
*/

#ifndef KCCAT
	#define KCCAT

	#define CAT(a, ...) CAT_INDIRECT(a, __VA_ARGS__)
	#define CAT_INDIRECT(a, ...) a ## __VA_ARGS__

#endif //KCCAT
