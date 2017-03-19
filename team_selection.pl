:- use_module(library(clpr)).

/* Database of all players in the team.
 * player(Num, Pos, Pass, Shot, Ret, Def). */
player(1, ['G'], 3, 3, 1, 3).
player(2, ['C'], 2, 1, 3, 2).
player(3, ['G','F'], 2, 3, 2, 2).
player(4, ['F','C'], 1, 3, 3, 1).
player(5, ['G','F'], 1, 3, 1, 2).
player(6, ['F','C'], 3, 1, 2, 3).
player(7, ['G','F'], 3, 2, 2, 1).

/* Call this predicate to start the program */
select_best_team :-
	select_best_team([], 0, BestTeam, BestDef, 1),
	print("Best team: "), print(BestTeam), nl,
	print("Best def: "), print(BestDef).

/* Selects the best team from a generated pool of 10000. */
select_best_team(CurrentBestTeam, CurrentBestDef, BestTeam, BestDef, Iteration) :-
	Iteration > 10000,
	BestTeam = CurrentBestTeam,
	BestDef = CurrentBestDef.
select_best_team(CurrentBestTeam, CurrentBestDef, BestTeam, BestDef, Iteration) :-
	not(select_team(_, _)),
	NewIteration is Iteration + 1,
	select_best_team(CurrentBestTeam, CurrentBestDef, BestTeam, BestDef, NewIteration).
select_best_team(CurrentBestTeam, CurrentBestDef, BestTeam, BestDef, Iteration) :-
	select_team(NewTeam, NewTotalDef),
	NewTotalDef > CurrentBestDef,
	NewIteration is Iteration + 1,
	select_best_team(NewTeam, NewTotalDef, BestTeam, BestDef, NewIteration);
	NewIteration is Iteration + 1,
	select_best_team(CurrentBestTeam, CurrentBestDef, BestTeam, BestDef, NewIteration).
	
/* Attempts to construct a valid team. */
select_team(Team, TotalDef) :-
	get_random_player(2, 3, FirstPlayer),
	select_players([FirstPlayer], Team), !,
	sum_def(Team, TotalDef),
	get_average_pass(Team, PassAverage),
	get_average_shot(Team, ShotAverage),
	get_average_ret(Team, ReturnAverage),
	is_valid_team(Team).

/* Selects a team of 5 players. */
select_players(CurrentTeam, FinalTeam) :-
	length(CurrentTeam, 5),
	FinalTeam = CurrentTeam.
select_players(CurrentTeam, FinalTeam) :-
	length(CurrentTeam, Len),
	Len < 5,
	get_random_player(1, 7, Player),
	not(member(Player, CurrentTeam)) -> append(CurrentTeam, [Player], NewTeam),
	select_players(NewTeam, FinalTeam);
	select_players(CurrentTeam, FinalTeam).

/* True if all team constraints are satisfied. */
is_valid_team(Team) :-
	length(Team, TeamSize),
	TeamSize = 5,
	is_valid_number_of_positions(Team),
	is_sufficent_average(Team),
	validate_players(Team).

/* True if all positions are sufficently filled. */
is_valid_number_of_positions(Team) :-
	get_players_in_team_of_pos('G', Team, GuardPlayers),
	length(GuardPlayers, NumGuards),
	NumGuards >= 3,
	get_players_in_team_of_pos('F', Team, ForwardPlayers),
	length(ForwardPlayers, NumForwards),
	NumForwards >= 2,
	get_players_in_team_of_pos('C', Team, CenterPlayers),
	length(CenterPlayers, NumCenters),
	NumCenters >= 1.
	
/* True if the team average for pass, shot and return meets the criteria. */
is_sufficent_average(Team) :-
	get_average_pass(Team, PassAverage),
	PassAverage >= 2,
	get_average_shot(Team, ShotAverage),
	ShotAverage >= 2,
	get_average_ret(Team, ReturnAverage),
	ReturnAverage >= 2.
	
/* True if no player specific conflicts arise. */
validate_players(Team) :-
	get_player(1, Player),
	member(Player, Team) -> special_rule_player1(Team) ; true,
	either_player2_or_player3(Team).
	

/* True if player 4 and player 5 are both on the team. */	
special_rule_player1(Team) :-
	get_player(4, Player4),
	member(Player4, Team),
	get_player(5, Player5),
	member(Player5, Team).
	
/* True if player 6 is not on the team. */
special_rule_player3(Team) :-
	get_player(6, Player),
	not(member(Player, Team)).
	
/* True if exactly one of player 2 and player 3 is on the team. */	
either_player2_or_player3(Team) :-
	get_player(2, Player2),
	get_player(3, Player3),
	member(Player2, Team), not(member(Player3, Team));
	get_player(2, Player2),
	get_player(3, Player3),
	member(Player3, Team), not(member(Player2, Team)) -> special_rule_player3(Team); 
	fail.
	
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
	
/* Gets sum of the defence score for all players in team. */	
sum_def([], 0).
sum_def([player(_, _, _, _, _, Def) | TailPlayers], Sum) :-
	sum_def(TailPlayers, Rest),
	Sum is Def + Rest.

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
	
/* Returns all players of position Pos in the team. (wrapper) */
get_players_in_team_of_pos(_, [], _) :-
	fail.
get_players_in_team_of_pos(Pos, Team, FinalPlayers) :-
	get_players_in_team_of_pos(Pos, Team, [], FinalPlayers).

/* Returns all players of position Pos in the team. */
get_players_in_team_of_pos(_, [], _, _) :-
	fail.
	
get_players_in_team_of_pos(Pos, [player(_, PlayerPositions, _, _, _, _) | []], CurrentPlayers, FinalPlayers) :-
	not(member(Pos, PlayerPositions)),
	FinalPlayers = CurrentPlayers.
	
get_players_in_team_of_pos(Pos, [player(Num, PlayerPositions, Pass, Shot, Ret, Def) | []], CurrentPlayers, FinalPlayers) :-
	member(Pos, PlayerPositions),
	append(CurrentPlayers, [player(Num, PlayerPositions, Pass, Shot, Ret, Def)], FinalPlayers).
	
get_players_in_team_of_pos(Pos, [player(_, PlayerPositions, _, _, _, _) | TailPlayers], CurrentPlayers, FinalPlayers) :-
	not(member(Pos, PlayerPositions)),
	get_players_in_team_of_pos(Pos, TailPlayers, CurrentPlayers, FinalPlayers).
	
get_players_in_team_of_pos(Pos, [player(Num, PlayerPositions, Pass, Shot, Ret, Def) | TailPlayers], CurrentPlayers, FinalPlayers) :-
	member(Pos, PlayerPositions),
	append(CurrentPlayers, [player(Num, PlayerPositions, Pass, Shot, Ret, Def)], NewPlayers),
	get_players_in_team_of_pos(Pos, TailPlayers, NewPlayers, FinalPlayers).
