/*
	Various time related functions

Mostly intended for usage in benchmarking
*/

#ifndef KCTIME
	#define KCTIME


/*
	KCLib$Get_Timestamp\
	KCLib$Get_Time_Elapsed_ms

Stores seconds (unix time) and milliseconds as 2 integers, because 32-bit
Get difference from 2 pairs of these timestamps
*/
#define KCLib$Get_Timestamp( seconds, millis ) { \
	seconds=llGetUnixTime(); \
	millis=(integer)llGetSubString(llGetTimestamp(),-7,-2); \
}

// millis is good to just over 35 minutes
#define KCLib$Get_Time_Elapsed_ms( seconds_start, millis_start, seconds_end, millis_end ) \
	(((seconds_end - seconds_start) * 1000000) + (millis_end - millis_start))


/*
	KCLib$MicrosecondsDiff

Takes two llGetTimestamp strings and returns the difference in microseconds

Uses strings for storage for speed and to work around the 32-bit limit

For memory effeceint storage of the timestamp, possibly use the above, or something similar,
and store seconds and sub-seconds as 2 separate integers 
*/
#define KCLib$MicrosecondsDiff(start_time, end_time) ( \
	( \
		(integer)llGetSubString(end_time, 8, 9) * 86400 \
		- (integer)llGetSubString(start_time, 8, 9) * 86400 \
		+ (integer)llGetSubString(end_time, 11, 12) * 3600 \
		- (integer)llGetSubString(start_time, 11, 12) * 3600 \
		+ (integer)llGetSubString(end_time, 14, 15) * 60 \
		- (integer)llGetSubString(start_time, 14, 15) * 60 \
		+ (integer)llGetSubString(end_time, 17, 19) \
		- (integer)llGetSubString(start_time, 17, 19) \
	) * 1000000 \
	+ ( \
		(integer)llGetSubString(end_time, 20, -2) \
		- (integer)llGetSubString(start_time, 20, -2) \
	) \
)



/*
	KCLib_Microseconds

Returns microseconds timestamp between -2147483648 and 2147483547
Rollsover every 35 minutes

Limitation, rollover not handled and will cause complications

TODO: likely not useful over other methods
*/
integer KCLib_Microseconds() {
	string Stamp = llGetTimestamp();
	return
		((
			(integer)llGetSubString(Stamp, 8, 9) * 86400 + // Days
			(integer)llGetSubString(Stamp, 11, 12) * 3600 + // Hours
			(integer)llGetSubString(Stamp, 14, 15) * 60 + // Minutes
			(integer)llGetSubString(Stamp, 17, 19) // Seconds
		) % 2147) * 1000000 +
		(integer)llGetSubString(Stamp, 20, -2) // Microseconds
		-2147483648;
}



#endif //KCTIME
