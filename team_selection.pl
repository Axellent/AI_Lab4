player(1, 'G', 3, 3, 1, 3).
player(2, 'C', 2, 1, 3, 2).
player(3, 'G, F', 2, 3, 2, 2).
player(4, 'F, C', 1, 3, 3, 1).
player(5, 'G, F', 1, 3, 1, 2).
player(6, 'F, C', 3, 1, 2, 3).
player(7, 'G, F', 3, 2, 2, 1).
/* TODO: Define all players */

select_players() :-
	select_players_start([HeadPlayer|TailPlayers]),
	print([HeadPlayer|TailPlayers]).
	
select_players_start([HeadPlayer|TailPlayers]) :-
	/*[HeadPlayer|TailPlayers] = [1],  TODO: Should append players 2 and 3 to the list instead */
	append([HeadPlayer|TailPlayers], [player(2), player(3)], [HeadPlayer|TailPlayers]),
	select_players([HeadPlayer|TailPlayers]).
	
select_players([HeadPlayer|TailPlayers]). /* TODO: Rest of selection */