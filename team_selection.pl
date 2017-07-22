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
	findall(Team, select_players(Team), Teams),
	select_team(Teams, BestTeam, BestDef),
	print("Best team: "), print(BestTeam), nl,
	print("Best def: "), print(BestDef).

/* Selects a team of 5 players (wrapper). */
select_players(Team) :-
	select_players(Team, []).

/* Selects a team of 5 players. */
select_players([Player | TeamTail], []) :-
	between(2, 3, Num),
	get_player(Num, Player),
	select_players(TeamTail, [Player]).
select_players([Player | TeamTail], CurrentTeam) :-
	length(CurrentTeam, Len),
	Len > 0, Len < 4,
	between(1, 7, Num),
	get_player(Num, Player),
	not(member(Player, CurrentTeam)),
	append(CurrentTeam, [Player], NewTeam),
	select_players(TeamTail, NewTeam).
select_players([Player | []], CurrentTeam) :-
	length(CurrentTeam, 4),
	between(1, 7, Num),
	get_player(Num, Player),
	not(member(Player, CurrentTeam)),
	append(CurrentTeam, [Player], NewTeam),
	is_valid_team(NewTeam).
	
/* wrapper */
select_team([Team | TeamTail], BestTeam, BestDef) :-
	sum_def(Team, Def).
	select_team(TeamTail, BestTeam, BestDef, Team, Def).

select_team([], BestTeam, BestDef, CurrBestTeam, CurrBestDef) :-
	BestTeam = CurrBestTeam,
	BestDef = CurrBestDef.
select_team([Team | TeamTail], BestTeam, BestDef, CurrBestTeam, CurrBestDef) :-
	sum_def(Team, Def).
	/* def better than CurrBestDef -> select_team(TeamTail, BestTeam, BestDef, Team, Def).
	def worse or equal to CurrBestDef? -> select_team(TeamTail, BestTeam, BestDef, CurrBestTeam, CurrBestDef), */

/* True if all team constraints are satisfied. */
is_valid_team(Team) :-
	length(Team, 5),
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
