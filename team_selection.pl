:- use_module(library(clpr)).
/* Database of all players in the team.
 * player(Num, Pos, Pass, Shot, Ret, Def). TODO: Change positions to a list. */
player(1, ['G'], 3, 3, 1, 3).
player(2, ['C'], 2, 1, 3, 2).
player(3, ['G','F'], 2, 3, 2, 2).
player(4, ['F','C'], 1, 3, 3, 1).
player(5, ['G','F'], 1, 3, 1, 2).
player(6, ['F','C'], 3, 1, 2, 3).
player(7, ['G','F'], 3, 2, 2, 1).

/* Main team selection entry point. */
select_players() :-
	/* get_random_player(2, 3, FirstPlayer), Random player selection, disabled for testing. */
	FirstPlayer = player(2, ['C'], 2, 1, 3, 2),
	select_players([FirstPlayer], FinalTeam),
	print(FinalTeam).

/* Selects a team of 5 players with the best defence. */
select_players(CurrentTeam, FinalTeam) :-
	length(CurrentTeam, 5),
	FinalTeam = CurrentTeam.

select_players(CurrentTeam, FinalTeam) :-
	length(CurrentTeam, Len),
	Len < 5,
	get_random_player(1, 7, Player),  /* TODO: Make sure constraints are followed. */
	not(member(Player, CurrentTeam)) -> append(CurrentTeam, [Player], NewTeam), 
	select_players(NewTeam, FinalTeam); 
	select_players(CurrentTeam, FinalTeam).

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
	Len > 0,
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

/* Returns average passing score of all players in team. */	
get_average_pass(Team, Average) :-
	sum_pass(Team, Sum),
	length(Team, Length),
	Length > 0,
	Average is Sum / Length.

/* Gets sum of the passing score for all players in team. */	
sum_pass([], 0).
sum_pass([player(_, _, Pass, _, _, _) | TailPlayers], Sum) :-
	sum_pass(TailPlayers, Rest),
	Sum is Pass + Rest.
	
/* Returns average shooting score of all players in team. */
get_average_shot(Team, Average) :-
	sum_shot(Team, Sum),
	length(Team, Length),
	Length > 0,
	Average is Sum / Length.
	
/* Gets sum of the shooting score for all players in team. */	
sum_shot([], 0).
sum_shot([player(_, _, _, Shot, _, _) | TailPlayers], Sum) :-
	sum_shot(TailPlayers, Rest),
	Sum is Shot + Rest.
	
/* Returns average return score of all players in team. */
get_average_ret(Team, Average) :-
	sum_ret(Team, Sum),
	length(Team, Length),
	Length > 0,
	Average is Sum / Length.
	
/* Gets sum of the return score for all players in team. */	
sum_ret([], 0).
sum_ret([player(_, _, _, _, Ret, _) | TailPlayers], Sum) :-
	sum_ret(TailPlayers, Rest),
	Sum is Ret + Rest.

/* Returns list of all players with position Pos (wrapper). */
get_players(Pos, Players) :-
	get_players(Pos, 1, [], Players).

/* Returns list of all players with position Pos. */
get_players(Pos, Num, CurrentPlayers, Players) :-
	Num = 7,
	get_player(Num, player(Num, PlayerPositions, _, _, _, _)),
	not(member(Pos, PlayerPositions)),
	Players = CurrentPlayers.
get_players(Pos, Num, CurrentPlayers, Players) :-
	Num = 7,
	get_player(Num, player(Num, PlayerPositions, Pass, Shot, Ret, Def)),
	member(Pos, PlayerPositions),
	append(CurrentPlayers, [player(Num, PlayerPositions, Pass, Shot, Ret, Def)], Players).
get_players(Pos, Num, CurrentPlayers, Players) :-
	Num < 7,
	get_player(Num, player(_, PlayerPositions, _, _, _, _)),
	not(member(Pos, PlayerPositions)),
	NewNum is Num + 1,
	get_players(Pos, NewNum, CurrentPlayers, Players).
get_players(Pos, Num, CurrentPlayers, Players) :-
	Num < 7,
	get_player(Num, player(Num, PlayerPositions, Pass, Shot, Ret, Def)),
	member(Pos, PlayerPositions),
	append(CurrentPlayers, [player(Num, PlayerPositions, Pass, Shot, Ret, Def)], NewCurrentPlayers),
	NewNum is Num + 1,
	get_players(Pos, NewNum, NewCurrentPlayers, Players).
