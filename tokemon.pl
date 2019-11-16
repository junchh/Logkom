:- dynamic(health/3).
:- dynamic(usespattack/1).
:- dynamic(battle/1).
:- dynamic(tokemonpos/3).
:- dynamic(encounter/1).
:- dynamic(battleid/2).

init_tokemon :- init_tokemon(1), asserta(encounter(0)), asserta(battle(0)).
init_tokemon(ID) :- (ID < 10 -> (randomize, width(W), height(H), random(0,W,X), random(0,H,Y), 
            ((\+ block(X,Y), \+ player(X,Y), \+ gym(X,Y), \+ tokemonpos(_,X,Y)) -> asserta(health(ID,100,100)),asserta(tokemonpos(ID,X,Y)), ID1 is ID + 1, init_tokemon(ID1); init_tokemon(ID)));
            !).

encounter :- ((player(X,Y), tokemonpos(_,X,Y)) -> asserta(encounter(1)),retract(encounter(0)); !),!.

fight :- (encounter(1) -> write('Choose your tokemon!'),nl,nl, avail_tokemon, init_battle,! ; !).
flee :- randomize, random(0, 10, RN),((RN > 4, encounter(1)) -> retract(encounter(1)), asserta(encounter(0)), write('You successfully escaped the Tokemon!') ; write('You failed to run!'),nl,fight).

avail_tokemon :- inventory(L), write('Available Tokemons: ['), avail_tokemon(L), write(']').
avail_tokemon([ID|[]]) :- tokemon(ID,Nama,_,_), write(Nama),!.
avail_tokemon([ID|L]) :- tokemon(ID,Nama,_,_), write(Nama), write(', '), avail_tokemon(L).


pick(Nama) :- (tokemon(ID, Nama, _,_) -> (inventory(L), (memberchk(ID, L) -> player(X,Y), tokemonpos(ID2,X,Y), asserta(battleid(ID,ID2)), write('You: "'), write(Nama), write(' I choose you!"') ; write('You don\'t have that tokemon.'))) ; write('Tokemon doesn\'t exist')).

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

init_battle :- (battle(0) -> asserta(usespattack(0)), retract(battle(0)), asserta(battle(1)) ; !).

attack(ID1,ID2) :- battle(X),(X = 1 -> (attackdamage(ID1,Dmg), health(ID2,Currhealth,Maxhealth), 
            (Currhealth =< Dmg -> Newhealth is 0 ; Newhealth is Currhealth - Dmg),
            asserta(health(ID2, Newhealth, Maxhealth)),retract(health(ID2, Currhealth, Maxhealth))) ;
            write('Command tidak dapat digunakan'),nl).

spattack(ID1,ID2) :- battle(X), usespattack(Y), (X = 1 -> (Y = 0 -> (spdamage(ID1,Dmg), health(ID2,Currhealth,Maxhealth), tokemon(ID1,_,type1,_), tokemon(ID2,_,type2,_),
            ((type1 == type2 -> CalcDmg is Dmg) ;
            ((type1 == fire, type2 == leaf) -> CalcDmg is Dmg * 1.5 ; ((type1 == fire, type2 == water) -> CalcDmg is Dmg * 0.5 ; CalcDmg is Dmg)) ;
            ((type1 == water, type2 == fire) -> CalcDmg is Dmg * 1.5 ; ((type1 == water, type2 == leaf) -> CalcDmg is Dmg * 0.5 ; CalcDmg is Dmg)) ;
            ((type1 == leaf, type2 == water) -> CalcDmg is Dmg * 1.5 ; ((type1 == fire, type2 == fire) -> CalcDmg is Dmg * 0.5 ; CalcDmg is Dmg))),
            (Currhealth =< CalcDmg -> Newhealth is 0 ; Newhealth is Currhealth - CalcDmg),
            asserta(health(ID2, Newhealth, Maxhealth)), retract(health(ID2, Currhealth, Maxhealth)), retract(usespattack(0)), asserta(usespattack(1))) ;
            write('Special Attack sudah digunakan'),nl) ;
            write('Command tidak dapat dugunakan'),nl).