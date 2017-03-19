:- use_module(library(clpfd)).
			
problem(1, "S", [
	[_,_,_,_,_,_,_,_,_],
	[_,_,_,_,_,3,_,8,5],
	[_,_,1,_,2,_,_,_,_],
	[_,_,_,5,_,7,_,_,_],
	[_,_,4,_,_,_,1,_,_],
	[_,9,_,_,_,_,_,_,_],
	[5,_,_,_,_,_,_,7,3],
	[_,_,2,_,1,_,_,_,_],
	[_,_,_,_,4,_,_,_,9]]).

problem(2, "S", [
	[1,_,_,8,_,4,_,_,_],
	[_,2,_,_,_,_,4,5,6],
	[_,_,3,2,_,5,_,_,_],
	[_,_,_,4,_,_,8,_,5],
	[7,8,9,_,5,_,_,_,_],
	[_,_,_,_,_,6,2,_,3],
	[8,_,1,_,_,_,7,_,_],
	[_,_,_,1,2,3,_,8,_],
	[2,_,5,_,_,_,_,_,9]]).

problem(3, "S", [
	[_,_,2,_,3,_,1,_,_],
	[_,4,_,_,_,_,_,3,_],
	[1,_,5,_,_,_,_,8,2],
	[_,_,_,2,_,_,6,5,_],
	[9,_,_,_,8,7,_,_,3],
	[_,_,_,_,4,_,_,_,_],
	[8,_,_,_,7,_,_,_,4],
	[_,9,3,1,_,_,_,6,_],
	[_,_,7,_,6,_,5,_,_]]).

problem(4, "S", [
	[1,_,_,_,_,_,_,_,_],
	[_,_,2,7,4,_,_,_,_],
	[_,_,_,5,_,_,_,_,4],
	[_,3,_,_,_,_,_,_,_],
	[7,5,_,_,_,_,_,_,_],
	[_,_,_,_,_,9,6,_,_],
	[_,4,_,_,_,6,_,_,_],
	[_,_,_,_,_,_,_,7,1],
	[_,_,_,_,_,1,_,3,_]]).

problem(5, "E", [
	[_,_,_,_,7,_,_,6,_],
	[_,_,_,_,_,_,_,_,_],
	[2,_,_,_,_,_,_,_,_],
	[_,_,_,_,_,_,_,_,_],
	[_,9,_,_,5,_,_,_,_],
	[_,_,_,_,_,_,1,_,_],
	[_,_,4,_,_,_,_,_,_],
	[_,_,_,_,_,_,_,_,_],
	[_,_,_,_,_,3,8,_,_]],	
	[
	["W", "W", "W", "B", "B", "B", "W", "B", "B"],
	["W", "W", "W", "B", "W", "B", "B", "B", "B"],
	["B", "B", "W", "B", "B", "W", "W", "W", "B"],
	["B", "B", "B", "B", "B", "W", "W", "W", "W"],
	["B", "B", "B", "W", "B", "B", "W", "W", "W"],
	["B", "B", "B", "W", "W", "B", "B", "W", "W"],
	["B", "W", "B", "W", "W", "W", "B", "B", "B"],
	["W", "B", "B", "W", "W", "W", "B", "B", "B"],
	["W", "W", "W", "B", "B", "B", "B", "B", "W"]]).

/* Solves one of the pre-generated soduko puzzles above and prints the result as a completed board. */
solve_sudoku(ProblemNR, "S") :-
	problem(ProblemNR, "S", Board),
	sudoku(Board),
	print_board(Board).
solve_sudoku(ProblemNR, "E") :-
	problem(ProblemNR, "E", Board, Colors),
	sudoku_extended(Board, Colors),
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

/* Takes in a sudoku problem as a list of lists and solves it. */
sudoku_extended(Rows, Colors) :-
	length(Rows, 9),
	maplist(same_length(Rows), Rows),
	append(Rows, Vs), Vs ins 1..9,
	transpose(Rows, Columns),
	maplist(all_distinct, Rows),
	maplist(all_distinct, Columns),
	all_distinct_diagonal(Rows),
	Rows = [R1, R2, R3, R4, R5, R6, R7, R8, R9],
	Colors = [C1, C2, C3, C4, C5, C6, C7, C8, C9],
	blocks(R1, R2, R3), blocks(R4, R5, R6), blocks(R7, R8, R9),
	colored_blocks(R1, R2, R3, C1, C2, C3), colored_blocks(R4, R5, R6, C4, C5, C6), colored_blocks(R7, R8, R9, C7, C8, C9).

/* True if all values in the largest diagonals in the nested list are different from each other. */
all_distinct_diagonal([]).
all_distinct_diagonal(Rows) :-
	Rows = [
		[S1, _,  _,  _,  _,  _,  _,  _,S17],
		[_, S2,  _,  _,  _,  _,  _,S16,  _],
		[_,  _, S3,  _,  _,  _,S15,  _,  _],
		[_,  _,  _, S4,  _,S14,  _,  _,  _],
		[_,  _,  _,  _, S5,  _,  _,  _,  _],
		[_,  _,  _,S13,  _, S6,  _,  _,  _],
		[_,  _,S12,  _,  _,  _, S7,  _,  _],
		[_, S11, _,  _,  _,  _,  _, S8,  _],
		[S10,_,  _,  _,  _,  _,  _,  _, S9]],
	all_distinct([S1, S2, S3, S4, S5, S6, S7, S8, S9]),
	all_distinct([S10, S11, S12, S13, S5, S14, S15, S16, S17]).

/* True if the values of all the squares in the 3x3 blocks are distinct from the others in the block. */
blocks([], [], []).
blocks([S1, S2, S3 | TailRow1], [S4, S5, S6 | TailRow2], [S7, S8, S9 | TailRow3]) :-
	all_distinct([S1, S2, S3, S4, S5, S6, S7, S8, S9]),
	blocks(TailRow1, TailRow2, TailRow3).

/* True if all colored squares does not have a bigger value than the number of colored squares in its block. */
colored_blocks([], [], [], [], [], []).
colored_blocks([S1, S2, S3 | TailRow1], [S4, S5, S6 | TailRow2], [S7, S8, S9 | TailRow3],
				[C1, C2, C3 | TailColors1], [C4, C5, C6 | TailColors2], [C7, C8, C9 | TailColors3]) :-
	Squares = [S1, S2, S3, S4, S5, S6, S7, S8, S9],
	Colors = [C1, C2, C3, C4, C5, C6, C7, C8, C9],
	num_colored_squares(Colors, NumColored),
	colored_block_limit(Squares, Colors, NumColored),
	colored_blocks(TailRow1, TailRow2, TailRow3, TailColors1, TailColors2, TailColors3).

/* Returns the number of colored squares in the list. */
num_colored_squares([], Num) :-
	Num = 0.
num_colored_squares(["W" | TailColors], Num) :-
	num_colored_squares(TailColors, Num1),
	Num is Num1.
num_colored_squares(["B" | TailColors], Num) :-
	num_colored_squares(TailColors, Num1),
	Num is Num1 + 1.

/* Checks that all squares that are colored do not have a larger value than the number of colored squares. */
colored_block_limit([], [], _).
colored_block_limit([_ | TailSquares], ["W" | TailColors], NumColored) :-
	colored_block_limit(TailSquares, TailColors,  NumColored).
colored_block_limit([S | TailSquares], ["B" | TailColors], NumColored) :-
	S #=< NumColored,
	colored_block_limit(TailSquares, TailColors, NumColored).

/* Prints a sudoku board row for row. */
print_board([]).
print_board([Row | TailBoard]) :-
	print(Row), nl,
	print_board(TailBoard).

