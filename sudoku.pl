:- use_module(library(clpfd)).

/* Takes in a sudoku problem as a list of lists and solves it.
The program is started by calling the methods in this format:
problem(N, S), solve(S). where N is the index of the problem to be solved.*/
solve(Rows) :- 
	length(Rows, 9), maplist(same_length(Rows), Rows),
	append(Rows, Values), Values ins 1..9,
	maplist(all_distinct, Rows),
	transpose(Rows, Columns),
	maplist(all_distinct, Columns),
	Rows = [As, Bs, Cs, Ds, Es, Fs, Gs, Hs, Is],
	blocks(As, Bs, Cs), blocks(Ds, Es, Fs), blocks(Gs, Hs, Is).
	
/* True if there is exactly one of each number in every block */	
blocks([], [], []).
blocks([N1, N2, N3 | Ns1], [N4, N5, N6 | Ns2], [N7, N8, N9 | Ns3]) :-
		all_distinct([N1, N2, N3, N4, N5, N6, N7, N8, N9]),
		blocks(Ns1, Ns2, Ns3).
		
problem(1, [[_, _, _, _, 7, _, _, 6, _],
			[_, _, _, _, _, _, _, _, _],
			[2, _, _, _, _, _, _, _, _],
			[_, _, _, _, _, _, _, _, _],
			[_, 9, _, _, 5, _, _, _, _],
			[_, _, _, _, _, _, 1, _, _],
			[_, _, 4, _, _, _, _, _, _],
			[_, _, _, _, _, _, _, _, _],
			[_, _, _, _, _, 3, 8, _, _]]).
			
problem(2, [[_, _, _, _, _, _, _, _, _],
            [_, _, _, _, _, 3, _, 8, 5],
            [_, _, 1, _, 2, _, _, _, _],
            [_, _, _, 5, _, 7, _, _, _],
            [_, _,4 , _, _, _, 1, _, _],
            [_, 9, _, _, _, _, _, _, _],
            [5, _, _, _, _, _, _, 7, 3],
            [_, _, 2, _, 1, _, _, _, _],
            [_, _, _, _, 4, _, _, _, 9]]).