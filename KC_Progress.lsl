/*
	Simple text progress indicators
	
Roughly based off http://wiki.secondlife.com/wiki/Progress_Bar

TODO: cleanup, redo
*/
#ifndef KC_PROGRESS
#define KC_PROGRESS


string kcGetSubString( string str_Text, integer int_Pos ) { return llGetSubString(str_Text, int_Pos, int_Pos); }

string _progressPie = "○◔◑◕●";
string _progressFill = "䷁䷖䷇䷏䷎䷆䷗䷚䷂䷲䷣䷒䷨䷻䷵䷊䷙䷄䷡䷍䷪䷀";
string _progressBar = "▁▂▃▄▅▆▇█▇▆▅▄▃▂▁";
string _progressArrow = "⬆⬈➨⬊⬇⬋⬅⬉";
string _progressCircle = "◐◒◑◓";

// Progress completion from 0.0 to 1.0
#define KCLib$progressPie( flt_Cur )		kcGetSubString( _progressPie,		llFloor(flt_Cur * 5) )
#define KCLib$progressFill( flt_Cur )		kcGetSubString( _progressFill,		llFloor(flt_Cur * 22) )
#define KCLib$progressBar( flt_Cur )		kcGetSubString( _progressBar,		llFloor(flt_Cur * 8) )
#define KCLib$progressArrow( flt_Cur )		kcGetSubString( _progressArrow,		llFloor(flt_Cur * 8) )
#define KCLib$progressCircle( flt_Cur )		kcGetSubString( _progressCircle,	llFloor(flt_Cur * 4) )

// Progress indication, animation steps once per increment. Use llFloor(int_Cur/int_SomeInt) to slow anim
#define KCLib$progressPieStep( int_Cur )	kcGetSubString( _progressPie,		int_Cur % 5 )
#define KCLib$progressFillStep( int_Cur )	kcGetSubString( _progressFill,		int_Cur % 22 )
#define KCLib$progressBarStep( int_Cur )	kcGetSubString( _progressBar,		int_Cur % 15 )
#define KCLib$progressArrowStep( int_Cur )	kcGetSubString( _progressArrow,		int_Cur % 8 )
#define KCLib$progressCircleStep( int_Cur )	kcGetSubString( _progressCircle,	int_Cur % 4 )

// #define KCLib$progressSteps( int_Cur, int_Steps ) ((int_Cur % int_Steps) / (float)int_Steps)
// #define KCLib$progressArrowSpin( int_Cur, int_Spins ) KCLib$progressArrow(KCLib$progressSteps( int_Cur, int_Spins ))

#endif //KC_PROGRESS
