solve:- 
  go(state(left,left,left,left),state(right,right,right,right)).

go(A,B):-
  go_helper(A,B,[A]).



/***************** PART 3 ******************/

/* [Farmer, Wolf, Goat, Cabbage] */

unsafe(state(A, B, B, C)) :-
  opposite(A, B).
unsafe(state(A, B, C, C)) :-
  opposite(A, C).

safe(A):-
  \+ unsafe(A).

opposite(left,right).
opposite(right,left).

arc(take(wolf, X, Y), state(X, X, C, D), state(Y, Y, C, D)):-
  opposite(X, Y).
arc(take(goat, X, Y), state(X, B, X, D), state(Y, B, Y, D)):-
  opposite(X, Y).
arc(take(cabbage, X, Y), state(X, B, C, X), state(Y, B, C, Y)):-
  opposite(X, Y).
arc(take(farmer, X, Y), state(X, B, C, D), state(Y, B, C, D)):-
  opposite(X, Y).

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
  !.

/* Print solution */
print_solution([]).
print_solution([H|L]):-
  print_state(H),
  nl,
  print_solution(L).

print_state(state(A,B,C,D)):-
  write(['farmer =', A, ' wolf =', B, ' goat =', C, ' cabbage =', D]).

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

