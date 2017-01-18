player(1, 'G', 3, 3, 1, 3).
/* TODO: Define all players */

select_players() :-
	select_players_start([HeadPlayer|TailPlayers]),
	print([HeadPlayer|TailPlayers]).
	
select_players_start([HeadPlayer|TailPlayers]) :-
	[HeadPlayer|TailPlayers] = [1], /* TODO: Should append players 2 and 3 to the list instead */
	select_players([HeadPlayer|TailPlayers]).
	
select_players([HeadPlayer|TailPlayers]). /* TODO: Rest of selection */