/*******************************************/
/**    Your solution goes in this file    **/ 
/*******************************************/


/***************** PART 1 ******************/

/* Given Set of facts: 			 */
/* course(number, prereq, units) */
/* student(name, courses taken)  */
/* instructor(name, course list) */ 

/* courses with 3 or 4 units */
fc_course(C) :- 
	course(C,_,X), 
	(X=3; X=4).

/* courses whose immediate pre-req is ecs 110 */
prereq_110(P) :- 
	course(P,X,_),
	member(ecs110,X).

/* names of all students in ecs140a */
ecs140a_students(S) :-
	student(S,X),
	member(ecs140a,X).

/* name of all instructors who teach john's courses */
instructor_names(I) :-
	instructor(I, IC),
	student(john, SC),
	intersection(SC, IC).
	/* I think this works because it separates the intersection logic away from the original and statement */

/* names of all students who are in jim's class */
students(S):-
	instructor(jim, IC),
	student(S, SC),
	intersection(SC, IC).

/* Mark intersections of SC and IC as true */
intersection(SC, IC):-
	member(X, SC),
	member(X, IC),
	!.

/* all pre-req of course */
allprereq([],Prereq):-
	Prereq = [].
allprereq([H|T], Prereq):-
  /* Continue recursion on head */
	course(H, HeadPrereq, _),
	allprereq(HeadPrereq, HeadPrereqPrereq),
	/* Continue recursion on tail */
	allprereq(T, TailPrereq),
	append(HeadPrereqPrereq, HeadPrereq, HeadTotalPrereq),
	append(TailPrereq, HeadTotalPrereq, Prereq).
allprereq(Course, Prereq):-
	course(Course, CoursePrereqs, _),
	allprereq(CoursePrereqs, CoursePrereqsPrereqs),
	append(CoursePrereqsPrereqs, CoursePrereqs, Prereq).

/***************** PART 2 ******************/

/* takes a list and counts number of atoms that occur in the list at all levels */
all_length([],0).
all_length([H|T],Result):-
	all_length(T, ResultOfTail),
	(is_list(H) ->
		(length(H, 0) ->
			ResultOfHead = 1;
			all_length(H, ResultOfHead)
			);
		ResultOfHead=1
		),
	Result is ResultOfTail + ResultOfHead.

/* returns true if L contains equal number of a and b terms */
equal_a_b(L) :- 
	findall(a,member(a, L),X),
	findall(b,member(b, L),Y),
	length(X,Count),
	length(Y,Count).

/* returns true if */
/* 		- K is sub-list of L */
/* 		- S is a list in form of [suffix of L + K + prefix of L] */

swap_prefix_suffix(Sublist, List, Swap):-
	append(Prefix, Rest, List),
	append(Sublist, Suffix, Rest),

	append(Suffix, Rest2, Swap),
	append(Sublist, Prefix, Rest2).

	/* TODO: Figure out why this doesn't work (Results in stack overflow) */
		/* append(Prefix, Sublist, Temp), */
		/* append(Temp, Suffix, List), */

/* returns true if L is a palindrome */
palin(L):-
	reverse(L, L2),
	L=L2.

/* returns true if input is a valid sequence in accordance to rules below */

/* seq = [0] */
good([0]).
/* seq = [1,seq,seq] */
good([1|[A,B]]):-
	good(A),
	good(B).

/***************** PART 3 ******************/

/***************** TERMS *******************/
/* [Farmer, Wolf, Goat, Cabbage] */

/* left, right side of bank  */
term(right).
term(left).

/* opposite */
opposite(right,left).
opposite(left,right).

/* return true if target is unsafe */
/* farmer not watching over Wolf and Goat*/
unsafe(state(A, B, B, C)) :-
  opposite(A, B).

 /* farmer not watching over Cabbage and Goat*/
unsafe(state(A, B, C, C)) :-
  opposite(A, C).

/* return true if target is safe */
safe(A):-
	\+ unsafe(A).

/* move object X from bank A to bank B */
take(X,A,B) :-
	(A == left ->
		X = right;
	X = left).

/***************** MAIN *******************/

/* arc */
arc(take(wolf, X, Y), state(X, X, C, D), state(Y, Y, C, D)):-
  opposite(X, Y).

arc(take(goat, X, Y), state(X, B, X, D), state(Y, B, Y, D)):-
  opposite(X, Y).

arc(take(cabbage, X, Y), state(X, B, C, X), state(Y, B, C, Y)):-
  opposite(X, Y).

arc(take(farmer, X, Y), state(X, B, C, D), state(Y, B, C, D)):-
  opposite(X, Y).

/* solve */
solve:- 
	go(state(left,left,left,left),state(right,right,right,right)).

go(A,B):-
  go_helper(A,B,[A]).

go_helper(A, C, Route):-
	/* Make move */
  arc(_, A, B),
  /* Only allow new moves */
	findall(B,member(B, Route), Found),
	length(Found, 0),
  safe(B),

  /* Recurse */
  append(Route, [B], R),
  go_helper(B, C, R).

/* Define endpoint */
go_helper(state(A,B,C,D), state(A,B,C,D),R):-
	writeresults(R).

/***************** PRINT *******************/
writeresults([H,N|T]) :-
	writehead(H,N),
	writeresults([N|T]).

writehead(state(X, X, C, D),state(Y, Y, C, D)):-
	write('take(wolf,'),
	write(X),write(','),
	write(Y),write(')'),nl.

writehead(state(X, B, X, D),state(Y, B, Y, D)):-
	write('take(goat,'),
	write(X),write(','),
	write(Y),write(')'),nl.

writehead(state(X, B, C, X),state(Y, B, C, Y)):-
	write('take(cabbage,'),
	write(X),write(','),
	write(Y),write(')'),nl.

writehead(state(X, B, C, D),state(Y, B, C, D)):-
	write('take(none,'),
	write(X),write(','),
	write(Y),write(')'),nl.
