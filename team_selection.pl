:- use_module(library(clpr)).
/* Database of all players in the team.
 * player(Num, Pos, Pass, Shot, Ret, Def). TODO: Change positions to a list. */
player(1, 'G', 3, 3, 1, 3).
player(2, 'C', 2, 1, 3, 2).
player(3, 'G,F', 2, 3, 2, 2).
player(4, 'F,C', 1, 3, 3, 1).
player(5, 'G,F', 1, 3, 1, 2).
player(6, 'F,C', 3, 1, 2, 3).
player(7, 'G,F', 3, 2, 2, 1).

/* Main team selection entry point. */
select_players() :-
	/* get_random_player(2, 3, FirstPlayer), Random player selection, disabled for testing. */
	FirstPlayer = player(2, 'C', 2, 1, 3, 2),
	select_players([FirstPlayer], FinalTeam),
	print(FinalTeam).

/* Selects a team of 5 players with the best defence. */
select_players(CurrentTeam, _) :-
	length(CurrentTeam, Len),
	Len > 5,
	fail.
select_players(CurrentTeam, FinalTeam) :-
	length(CurrentTeam, 5),
	FinalTeam = CurrentTeam.
select_players(CurrentTeam, FinalTeam) :-
	get_random_player(1, 7, Player),  /* TODO: Make sure constraints are followed. */
	append(CurrentTeam, [Player], NewTeam), 
	select_players(NewTeam, FinalTeam).

/* Returns the player with the associated number. */
get_player(Num, Player) :-
	player(Num, Pos, Pass, Shot, Ret, Def),
	Player = player(Num, Pos, Pass, Shot, Ret, Def).

/* Randomly returns any of the 7 players. */
get_random_player(Low, High, Player) :-
	Low >= 1,
	High =< 7,
	random_between(Low, High, Num),
	get_player(Num, Player).
	
/* Randomly returns any player with the given position. */
get_random_player(Pos, Player) :-
	get_players(Pos, Players),
	length(Players, Len),
	random_between(0, Len, Index),
	nth0(Index, Players, Player).
	
/* Returns the player with the best Def (wrapper). */
get_best_def_player([], _) :-
	fail.
get_best_def_player([HeadPlayer | []], BestDefPlayer) :-
	BestDefPlayer = HeadPlayer.
get_best_def_player([HeadPlayer | TailPlayers], BestDefPlayer) :-
	get_best_def_player(TailPlayers, HeadPlayer, BestDefPlayer).

/* Returns the player with the best Def. */
get_best_def_player([], _, _) :-
	fail.
get_best_def_player([player(Num, Pos, Pass, Shot, Ret, Def) | []], player(_, _, _, _, _, Def2), BestDefPlayer) :-
	Def > Def2,
	BestDefPlayer = player(Num, Pos, Pass, Shot, Ret, Def).
get_best_def_player([player(_, _, _, _, _, Def) | []], player(Num2, Pos2, Pass2, Shot2, Ret2, Def2), BestDefPlayer) :-
	Def =< Def2,
	BestDefPlayer = player(Num2, Pos2, Pass2, Shot2, Ret2, Def2).
get_best_def_player([player(Num, Pos, Pass, Shot, Ret, Def) | TailPlayers], player(_, _, _, _, _, Def2), BestDefPlayer) :-
	Def > Def2,
	get_best_def_player(TailPlayers, player(Num, Pos, Pass, Shot, Ret, Def), BestDefPlayer).
get_best_def_player([player(_, _, _, _, _, Def) | TailPlayers], player(Num2, Pos2, Pass2, Shot2, Ret2, Def2), BestDefPlayer) :-
	Def =< Def2,
	get_best_def_player(TailPlayers, player(Num2, Pos2, Pass2, Shot2, Ret2, Def2), BestDefPlayer).

/* Returns list of all players with position Pos (wrapper). */
get_players(Pos, Players) :-
	get_players(Pos, 1, [], Players).
/* Returns list of all players with position Pos. */
get_players(_, Num, _) :-
	Num > 7,
	fail.
get_players(Pos, 7, CurrentPlayers, Players) :-
	get_player(7, player(_, PlayerPositions, _, _, _, _)),
	/* TODO: ignore player 7 if Pos is not a member of PlayerPositions. */
	Players = CurrentPlayers.
get_players(Pos, 7, CurrentPlayers, Players) :-
	get_player(7, player(_, PlayerPositions, _, _, _, _)),
	/* TODO: append player 7 to CurrentPlayers if Pos is a member of PlayerPositions. */
	Players = CurrentPlayers.
get_players(Pos, Num, Players) :-
	get_player(Num, player(_, PlayerPositions, _, _, _, _)),
	/* TODO: append player Num to CurrentPlayers if Pos is a member of PlayerPositions. */
	get_players(Pos, Num + 1, Players).
