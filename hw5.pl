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

/* all pre-req of course, not working */
allprereq([],[]) :- !.
allprereq([],A).
allprereq([H|T],A) :-
	course(H,X,_), 
	atomic_list_concat(L,'',H),  
	append(X,L,A),
	allprereq(X,A).

/***************** PART 2 ******************/

/* takes a list and counts number of atoms that occur in the list at all levels, not working */
all_length([],0). 
all_length([H|T],L) :-
	atom(H),
	all_length(T,L1),
	L is L1+1,
	!.
all_length([H|T],L) :-
	is_list(H),
	all_length(H,L1),
	all_length(T,L2),
	L is L1+L2.

/* returns true if L contains equal number of a and b terms, not working */



	



	
