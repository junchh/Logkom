:- dynamic(health/3).
:- dynamic(usespattack/1).
:- dynamic(battle/1).
:- dynamic(tokemonpos/3).
:- dynamic(encounter/1).
:- dynamic(battleid/2).
:- dynamic(enemy_fainted/1).
:- dynamic(yours_fainted/1).
:- dynamic(tokemon_fainted/1).
:- dynamic(starter/1).

init_tokemon :- init_tokemon(1), asserta(encounter(0)), asserta(battle(0)).
init_tokemon(ID) :- (ID < 10 -> ID1 is ID + 1,(inventory(L), asserta(health(ID,100,100)), \+ memberchk(ID,L) -> random_tokemonpos(ID), init_tokemon(ID1); init_tokemon(ID1));!).

random_tokemonpos(ID) :- (ID < 10 -> (randomize, width(W), height(H), random(0,W,X), random(0,H,Y),
            ((\+ block(X,Y), \+ player(X,Y), \+ gym(X,Y), \+ tokemonpos(_,X,Y)) -> asserta(tokemonpos(ID,X,Y)); random_tokemonpos(ID)))),!.

refresh_tokemonpos(ID) :- (ID < 10, inventory(L), \+ memberchk(ID,L) -> ID1 is ID + 1,tokemon(ID,_,_,X),(X == legendary -> retract(tokemonpos(ID,_,_)), random_tokemonpos(ID), refresh_tokemonpos(ID1),! ;refresh_tokemonpos(ID1),!) ; !),!.

encounter :- ((player(X,Y), tokemonpos(_,X,Y)) -> asserta(encounter(1)),retract(encounter(0)); !),!.

fight :- (encounter(1) -> write('Choose your tokemon!'),nl,nl, avail_tokemon, init_battle,! ; !).
run :- randomize, random(0, 10, RN),((RN > 4, encounter(1)) -> retract(encounter(1)), asserta(encounter(0)), write('You successfully escaped the Tokemon!') ; write('You failed to run!'),nl,fight).

avail_tokemon :- inventory(L), write('Available Tokemons: ['), avail_tokemon(L), write(']').
avail_tokemon([ID|[]]) :- (\+ tokemon_fainted(ID) -> tokemon(ID,Nama,_,_), write(Nama),! ; !).
avail_tokemon([ID|L]) :- (\+ tokemon_fainted(ID) -> tokemon(ID,Nama,_,_), write(Nama), write(', '), avail_tokemon(L) ; avail_tokemon(L)).

check_all_fainted :- inventory(L),(check_all_fainted(L) -> retract(fail(0)),asserta(fail(1)) ; fail).
check_all_fainted([]) :- !.
check_all_fainted([ID|L]) :- tokemon_fainted(ID), check_all_fainted(L). 

pick(Nama) :- (tokemon(ID, Nama, _,_) -> (inventory(L), (memberchk(ID, L) -> player(X,Y), tokemonpos(ID2,X,Y), asserta(battleid(ID,ID2)), write('You: "'), write(Nama), write(' I choose you!"'),nl,nl,battlestats ; write('You don\'t have that tokemon.'))) ; write('Tokemon doesn\'t exist')),!.



tokemon(1, groudon, fire, legendary).
tokemon(2, charizard, fire, normal).
tokemon(3, charmander, fire, normal).
tokemon(4, kyogre, water, legendary).
tokemon(5, suicune, water, legendary).
tokemon(6, squirtle, water, normal).
tokemon(7, blastoise, water, normal).
tokemon(8, venusaur, leaf, normal).
tokemon(9, bulbasaur, leaf, normal).

attackdamage(1,10).
attackdamage(2,10).
attackdamage(3,10).
attackdamage(4,10).
attackdamage(5,10).
attackdamage(6,10).
attackdamage(7,10).
attackdamage(8,10).
attackdamage(9,10).

spdamage(1,100).
spdamage(2,100).
spdamage(3,100).
spdamage(4,100).
spdamage(5,100).
spdamage(6,100).
spdamage(7,100).
spdamage(8,100).
spdamage(9,100).

init_battle :- (battle(0) -> asserta(usespattack(0)), retract(battle(0)), asserta(battle(1)), asserta(enemy_fainted(0)), asserta(yours_fainted(0))),!.
battlestats :- battleid(ID1,ID2), tokemon(ID1,Nama1,Type1,_), tokemon(ID2,Nama2,Type2,_), health(ID1,Currhealth1,_), health(ID2,Currhealth2,_),
            write(Nama2),nl, write('Health: '),write(Currhealth2),nl,write('Type: '),write(Type2),nl,nl,
            write(Nama1),nl, write('Health: '),write(Currhealth1),nl,write('Type: '),write(Type1),!.

enemy_random_attack :- randomize, random(0,10,RN), battleid(_,ID2), tokemon(ID2,Nama2,_,_), (RN < 4 -> nl,enemy_spattack ; nl,write(Nama2), write(' attacks!'),nl, enemy_attack),!.

attack :- battleid(ID1,ID2),attack(ID1,ID2,1),(enemy_fainted(0) -> battlestats,nl; !), enemy_random_attack,!.
enemy_attack :- battleid(ID1,ID2),attack(ID2,ID1,0),(yours_fainted(0) -> battlestats,nl ; !),!.

spattack :- battleid(ID1,ID2),spattack(ID1,ID2,1),(enemy_fainted(0) -> battlestats,nl ; !), enemy_random_attack,!.
enemy_spattack :- battleid(ID1,ID2),spattack(ID2,ID1,0),(yours_fainted(0) -> battlestats,nl ; !),!.

attack(ID1,ID2,Attacker) :- (battle(1) -> (attackdamage(ID1,Dmg), health(ID2,Currhealth,Maxhealth), tokemon(ID2,Nama2,_,_), 
            (Currhealth =< Dmg -> Newhealth is 0, fainted(Attacker) ; Newhealth is Currhealth - Dmg,(Attacker = 1 -> write('You') ; write('It')),
            write(' dealt '), write(Dmg), write(' damage to '), write(Nama2),nl,nl),
            asserta(health(ID2, Newhealth, Maxhealth)),retract(health(ID2, Currhealth, Maxhealth))) ;
            write('Command tidak dapat digunakan'),nl),!.

spattack(ID1,ID2,Attacker) :- (battle(1) -> (usespattack(0) -> (spdamage(ID1,Dmg), health(ID2,Currhealth,Maxhealth), tokemon(ID1,Nama1,Type1,_), tokemon(ID2,Nama2,Type2,_),
            write(Nama1), write(' uses '),write('_____'), write('!'),nl,
            ((Type1 == Type2 -> CalcDmg is Dmg) ;
            ((Type1 == fire, Type2 == leaf) -> CalcDmg is round(Dmg * 1.5), write('It\'s super effective!'),nl ; ((Type1 == fire, Type2 == water) -> CalcDmg is round(Dmg * 0.5), write('It\'s not very effective...'),nl ; CalcDmg is Dmg)) ;
            ((Type1 == water, Type2 == fire) -> CalcDmg is round(Dmg * 1.5), write('It\'s super effective!'),nl ; ((Type1 == water, Type2 == leaf) -> CalcDmg is round(Dmg * 0.5), write('It\'s not very effective...'),nl ; CalcDmg is Dmg)) ;
            ((Type1 == leaf, Type2 == water) -> CalcDmg is round(Dmg * 1.5), write('It\'s super effective!'),nl ; ((Type1 == leaf, Type2 == fire) -> CalcDmg is round(Dmg * 0.5), write('It\'s not very effective...'),nl ; CalcDmg is Dmg))),
            (Currhealth =< CalcDmg -> (Newhealth is 0, fainted(Attacker)),! ; (Newhealth is Currhealth - CalcDmg,
            (Attacker = 1 -> write('You') ; write('It')),
            write(' dealt '), write(CalcDmg), write(' damage to '), write(Nama2),nl,nl)),
            asserta(health(ID2, Newhealth, Maxhealth)), retract(health(ID2, Currhealth, Maxhealth)), retract(usespattack(0)), asserta(usespattack(1)),!) ;
            write('Special attacks can only be used once per battle!'),nl,!) ;
            write('Command tidak dapat digunakan'),nl),!.

fainted(Attacker) :- battleid(ID1,ID2), (Attacker = 1 -> tokemon(ID2,Nama2,_,_), retract(enemy_fainted(0)), asserta(enemy_fainted(1)), asserta(tokemon_fainted(ID2)),
            write(Nama2), write(' faints! Do you want to capture '), write(Nama2), write('?'), write(' (capture/0 to capture '), write(Nama2), write(', otherwise move away.') ;
            retract(yours_fainted(0)), asserta(yours_fainted(1)), asserta(tokemon_fainted(ID1)),nl,write('Your Tokemon fainted!'),nl),!.

capture :- battleid(_,ID2), inventory(L), length(L, N), ( N < 6 -> heal(ID2),retract(tokemonpos(ID2,_,_)),asserta(inventory([ID2|L])),retract(inventory(L)) ; write('You cannot capture another Tokemon! You have to drop one first.'),nl).

drop(Nama) :- tokemon(ID,Nama,_,_), inventory(L), (memberchk(ID,L) -> delete(L,ID,L2), retract(inventory(L)), asserta(inventory(L2)) ; write('You don\'t have that tokemon'),nl).
