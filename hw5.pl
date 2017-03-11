/*******************************************/
/**    Your solution goes in this file    **/ 
/*******************************************/


/* Given Set of facts: 			 */
/* course(number, prereq, units) */
/* student(name, courses taken)  */
/* instructor(name, course list) */ 

/* courses with 3 or 4 units */
fc_course(C) :- 
	course(C,_,X), 
	(A=3; A=4).

/* courses whose immediate pre-req is ecs 110 */
prereq_110(P) :- 
	course(P, ecs110, _).

/* names of all students in ecs140a */
ecs140a_students(S) :-
	student(S, ecs140a).

/* name of all instructors who teach john's courses */
instructor_names(I) :-
	instructor(I, X),
	student(john, X).

/* names of all students who are in jim's class */
students(S) :-
	student(S, X),
	instructor(jim, X).

/* all pre-req of course */
allprereq(C, A) :-
	course(C, A, _).