:- use_module(library(clpfd)).

problem(1, [[_,_,_,_,7,_,_,6,_],
			[_,_,_,_,_,_,_,_,_],
			[2,_,_,_,_,_,_,_,_],
			[_,_,_,_,_,_,_,_,_],
			[_,9,_,_,5,_,_,_,_],
			[_,_,_,_,_,_,1,_,_],
			[_,_,4,_,_,_,_,_,_],
			[_,_,_,_,_,_,_,_,_],
			[_,_,_,_,_,3,8,_,_]]).
			
problem(2, [[_,_,_,_,_,_,_,_,_],
			[_,_,_,_,_,3,_,8,5],
			[_,_,1,_,2,_,_,_,_],
			[_,_,_,5,_,7,_,_,_],
			[_,_,4,_,_,_,1,_,_],
			[_,9,_,_,_,_,_,_,_],
			[5,_,_,_,_,_,_,7,3],
			[_,_,2,_,1,_,_,_,_],
			[_,_,_,_,4,_,_,_,9]]).

problem(3, [[1,_,_,8,_,4,_,_,_],
			[_,2,_,_,_,_,4,5,6],
			[_,_,3,2,_,5,_,_,_],
			[_,_,_,4,_,_,8,_,5],
			[7,8,9,_,5,_,_,_,_],
			[_,_,_,_,_,6,2,_,3],
			[8,_,1,_,_,_,7,_,_],
			[_,_,_,1,2,3,_,8,_],
			[2,_,5,_,_,_,_,_,9]]).

problem(4, [[_,_,2,_,3,_,1,_,_],
			[_,4,_,_,_,_,_,3,_],
			[1,_,5,_,_,_,_,8,2],
			[_,_,_,2,_,_,6,5,_],
			[9,_,_,_,8,7,_,_,3],
			[_,_,_,_,4,_,_,_,_],
			[8,_,_,_,7,_,_,_,4],
			[_,9,3,1,_,_,_,6,_],
			[_,_,7,_,6,_,5,_,_]]).

problem(5, [[1,_,_,_,_,_,_,_,_],
			[_,_,2,7,4,_,_,_,_],
			[_,_,_,5,_,_,_,_,4],
			[_,3,_,_,_,_,_,_,_],
			[7,5,_,_,_,_,_,_,_],
			[_,_,_,_,_,9,6,_,_],
			[_,4,_,_,_,6,_,_,_],
			[_,_,_,_,_,_,_,7,1],
			[_,_,_,_,_,1,_,3,_]]).

/* Solves one of the pre-generated soduko puzzles above and prints the result as a completed board. */
solve_sudoku(ProblemNR) :-
	problem(ProblemNR, Board),
	sudoku(Board),
	print_board(Board).
	
/* Takes in a sudoku problem as a list of lists and solves it. */
sudoku(Rows) :-
	length(Rows, 9),
	maplist(same_length(Rows), Rows),
	append(Rows, Vs), Vs ins 1..9,
	transpose(Rows, Columns),
	maplist(all_distinct, Rows),
	maplist(all_distinct, Columns),
	Rows = [S1, S2, S3, S4, S5, S6, S7, S8, S9],
	blocks(S1, S2, S3), blocks(S4, S5, S6), blocks(S7, S8, S9).

/* True if the values of all the squares are distinct from each other. */
blocks([], [], []).
blocks([S1, S2, S3 | TailBlock1], [S4, S5, S6 | TailBlock2], [S7, S8, S9 | TailBlock3]) :-
	all_distinct([S1, S2, S3, S4, S5, S6, S7, S8, S9]),
	blocks(TailBlock1, TailBlock2, TailBlock3).

/* Prints a sudoku board row for row. */
print_board([]).
print_board([Row | TailBoard]) :-
	print(Row), nl,
	print_board(TailBoard).