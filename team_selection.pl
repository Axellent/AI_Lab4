:- use_module(library(clpr)).
/* Database of all players in the team.
 * player(Num, Pos, Pass, Shot, Ret, Def). */
player(1, 'G', 3, 3, 1, 3).
player(2, 'C', 2, 1, 3, 2).
player(3, 'G,F', 2, 3, 2, 2).
player(4, 'F,C', 1, 3, 3, 1).
player(5, 'G,F', 1, 3, 1, 2).
player(6, 'F,C', 3, 1, 2, 3).
player(7, 'G,F', 3, 2, 2, 1).

/* Binds the Player variable to the player with the associated number. */
get_player(Num, Player) :-
	player(Num, Pos, Pass, Shot, Ret, Def),
	Player = player(Num, Pos, Pass, Shot, Ret, Def).

/* Main team selection entry point. */
select_players() :-
	select_players_start(FinalTeam),
	print(FinalTeam).

/* Initial team selection. */
select_players_start(FinalTeam) :-
	get_player(2, Player2),
	get_player(3, Player3),
	append([], [Player2, Player3], CurrentTeam), /* TODO: Should append either player 2 or 3 to the current team instead (and display the result of both selections)*/
	select_players(CurrentTeam, FinalTeam).

select_players(CurrentTeam, FinalTeam) :- /* TODO: Rest of selection */
	FinalTeam = CurrentTeam.