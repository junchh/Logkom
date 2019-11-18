:- dynamic(health/3).
:- dynamic(tokemonpos/3).
:- dynamic(battleid/2).
:- dynamic(tokemon_fainted/1).
:- dynamic(starter/1).

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

spdamage(1,fireblast,100).
spdamage(2,flamethrower,80).
spdamage(3,ember,80).
spdamage(4,surf,100).
spdamage(5,hydropump,100).
spdamage(6,bubble,80).
spdamage(7,bubblebeam,80).
spdamage(8,solarbeam,80).
spdamage(9,razorleaf,80).

init_tokemon :- 
    (not_available(0) ->
        init_tokemon(1),
        retract(health(1,_,_)),
        retract(health(4,_,_)),
        retract(health(5,_,_)),
        asserta(health(1,160,160)),
        asserta(health(4,200,200)),
        asserta(health(5,180,180))
    ;
        write('Command not available!'),nl
    ),
    !.

init_tokemon(ID) :- 
    (not_available(0) ->
        (ID < 10 -> 
            ID1 is ID + 1,
            inventory(L), 
            asserta(health(ID,100,100)), 
            (\+ memberchk(ID,L) -> 
                random_tokemonpos(ID), 
                init_tokemon(ID1)
            ; 
                init_tokemon(ID1)
            )
        ;
            !
        )
    ;
        write('Command not available!'),nl
    ),
    !.

random_tokemonpos(ID) :- 
    (not_available(0) ->
        randomize, 
        width(W), 
        height(H), 
        random(0,W,X), 
        random(0,H,Y),
        ((\+ block(X,Y), \+ player(X,Y), \+ gym(X,Y), \+ tokemonpos(_,X,Y)) -> 
            asserta(tokemonpos(ID,X,Y))
        ; 
            random_tokemonpos(ID)
        )
    ;
        write('Command not available!'),nl
    ),
    !.

refresh_tokemonpos(ID) :- 
    (not_available(0) ->
        (ID < 10 ->
            ID1 is ID + 1,
            inventory(L), 
            (\+ memberchk(ID,L) -> 
                tokemon(ID,_,_,_),
                (\+ tokemon_fainted(ID) -> 
                    retract(tokemonpos(ID,_,_)), 
                    random_tokemonpos(ID), 
                    refresh_tokemonpos(ID1) 
                ;
                    !
                ) 
            ;   
                !
            ),
            refresh_tokemonpos(ID1)
        ;
            !
        )
    ;
        write('Command not available!'),nl
    ),
    !.

encounter :- 
    (not_available(0) ->
        retract(encounter(0)),
        asserta(encounter(1))
    ;
        write('Command not available!'),nl
    ),
    !.

init_battle :- 
    (not_available(0) ->
        retract(spattack_used(_)),
        asserta(spattack_used(0)),
        (enemy_spattack_used(0) ->
            retract(enemy_spattack_used(_)), 
            asserta(enemy_spattack_used(0))
         ;
            !
        ),
        retract(battle(0)), 
        asserta(battle(1))
    ;
        write('Command not available')
    ),
    !.

write_info(ID) :- 
    tokemon(ID,Name,Type,_), 
    health(ID,Currhealth,_),
    write(Name),nl,
    write('Health: '), write(Currhealth), nl,
    write('Type: '), write(Type),nl.

battlestats :- 
    (not_available(0) ->
        battleid(ID1,ID2), 
        write_info(ID1),nl,
        write_info(ID2)
    ;
        write('Command not available!'),nl
    ),
    !.

fight :- 
    (encounter(1), battle(0) -> 
        retract(not_available(1)),
        asserta(not_available(0)),
        write('Choose your tokemon!'), nl, nl, 
        avail_tokemon, 
        init_battle,
        retract(not_available(0)),
        asserta(not_available(1))
    ; 
        write('Command not available!'),nl
    ),
    !.

run :-
    (encounter(1), battle(0) ->
        randomize, 
        random(0, 10, RN),
        (RN > 4 -> 
            retract(encounter(1)), 
            asserta(encounter(0)), 
            write('You successfully escaped the Tokemon!') 
        ; 
            write('You failed to run!'), nl,
            fight
        )
    ;
        write('Command not available!'),nl
    ),
    !.

avail_tokemon :-
    (not_available(0) ->
        inventory(L), 
        write('Available Tokemons: ['), 
        avail_tokemon(L), 
        write(']')
    ;
        write('Command not available!'),nl
    ),
    !.

avail_tokemon([ID|[]]) :-
    (not_available(0) ->
        tokemon(ID,Name,_,_),
        write(Name) 
    ;  
        write('Command not available!'),nl    
    )
    .

avail_tokemon([ID|L]) :-
    (not_available(0) -> 
        tokemon(ID,Name,_,_), 
        write(Name), 
        write(', '), 
        avail_tokemon(L) 
    ;
        write('Command not available!'),nl
    )
    .

pick(Name) :- 
    (\+ battleid(_,_), battle(1) ->
        (tokemon(ID, Name, _,_) -> 
            inventory(L), 
            (memberchk(ID, L) -> 
                retract(not_available(1)),
                asserta(not_available(0)),
                player(X,Y), 
                tokemonpos(ID2,X,Y), 
                asserta(battleid(ID,ID2)), 
                write('You: "'), 
                write(Name), 
                write(' I choose you!"'), nl, nl,
                battlestats,
                retract(not_available(0)),
                asserta(not_available(1))
            ; 
                write('You don\'t have that tokemon.'),nl
            ) 
        ; 
            write('Tokemon doesn\'t exist'),nl
        )
    ;
        write('Command not available!'),nl
    ),
    !.

enemy_random_attack :-
    (not_available(0) ->
        randomize, 
        random(0,10,RN), 
        battleid(_,ID2), 
        tokemon(ID2,Name2,_,_), 
        (RN < 4 -> 
            nl, 
            enemy_spattack 
        ; 
            nl, 
            write(Name2), 
            write(' attacks!'), nl, 
            enemy_attack
        )
    ;
        write('Command not available!'),nl
    ),
    !.

attack :- 
    (battleid(_,_), battle(1) ->
        retract(not_available(1)),
        asserta(not_available(0)),
        battleid(ID1,ID2),
        attack(ID1,ID2,1),
        nl,
        (can_capture(0) ->
            enemy_random_attack
        ;
            !
        ),
        retract(not_available(0)),
        asserta(not_available(1))
    ;
        write('Command not available!'),nl
    ),
    !.

enemy_attack :- 
    (not_available(0) ->
        battleid(ID1,ID2),
        attack(ID2,ID1,0)
    ;
        write('Command not available!'),nl
    ),
    !.

spattack :- 
    (battleid(_,_),battle(1) ->
        retract(not_available(1)),
        asserta(not_available(0)),
        battleid(ID1,ID2),
        spattack(ID1,ID2,1),
        nl,
        (can_capture(0) ->
            enemy_random_attack
        ;
            !
        ),
        retract(not_available(0)),
        asserta(not_available(1))
    ;
        write('Command not available!'),nl
    ),
    !.

enemy_spattack :- 
    (not_available(0) ->
        battleid(ID1,ID2),
        spattack(ID2,ID1,0)
    ;
        write('Command not available!'),nl
    ),
    !.

attack(ID1,ID2,Attacker) :- 
    (battle(1), not_available(0) -> 
        attackdamage(ID1,Dmg), 
        health(ID2,Currhealth,Maxhealth), 
        tokemon(ID2,Name2,_,_), 
        (Currhealth =< Dmg -> 
            Newhealth is 0,
            asserta(health(ID2, Newhealth, Maxhealth)),
            retract(health(ID2, Currhealth, Maxhealth)),
            (Attacker = 1 ->
                enemy_fainted
            ;
                yours_fainted
            ) 
        ; 
            Newhealth is Currhealth - Dmg,
            (Attacker = 1 -> 
                write('You') 
            ; 
                write('It')
            ),
            write(' dealt '), 
            write(Dmg),
            write(' damage to '), 
            write(Name2), nl, nl,

            asserta(health(ID2, Newhealth, Maxhealth)),
            retract(health(ID2, Currhealth, Maxhealth)),
            battlestats
        )   
    ;
        write('Command not available'), nl
    ),
    !.

spattack(ID1,ID2,Attacker) :- 
    (battle(1), not_available(0) -> 
        ((Attacker = 1 -> spattack_used(0) ; enemy_spattack_used(0)) -> 
            spdamage(ID1,SpName,Dmg), 
            health(ID2,Currhealth,Maxhealth), 
            tokemon(ID1,Name1,Type1,_), 
            tokemon(ID2,Name2,Type2,_),
            write(Name1), write(' uses '), write(SpName), write('!'), nl,
            ((Type1 == fire,
                ((Type2 == leaf,
                CalcDmg is round(Dmg * 1.5), 
                write('It\'s super effective!'), nl  
                );
                (Type2 == water,
                CalcDmg is round(Dmg * 0.5), 
                write('It\'s not very effective...'), nl
                ))
            );
            (Type1 == water,
                ((Type2 == fire,
                CalcDmg is round(Dmg * 1.5), 
                write('It\'s super effective!'), nl
                );
                (Type2 == leaf,
                CalcDmg is round(Dmg * 0.5), 
                write('It\'s not very effective...'), nl
                ))
            );
            (Type1 == leaf,
                ((Type2 == water,
                CalcDmg is round(Dmg * 1.5), 
                write('It\'s super effective!'), nl
                );
                (Type2 == fire,
                CalcDmg is round(Dmg * 0.5), 
                write('It\'s not very effective...'), nl
                ))
            );
            (Type1 == Type2,
                CalcDmg is Dmg)
            ),
            (Currhealth =< CalcDmg -> 
                Newhealth is 0,
                asserta(health(ID2, Newhealth, Maxhealth)), 
                retract(health(ID2, Currhealth, Maxhealth)),
                (Attacker = 1 ->
                    enemy_fainted
                ;
                    yours_fainted
                )
            ; 
                (Newhealth is Currhealth - CalcDmg,
                (Attacker = 1 -> 
                    write('You') 
                ; 
                    write('It')
                ),
                write(' dealt '), 
                write(CalcDmg), 
                write(' damage to '), 
                write(Name2),nl,nl),

                asserta(health(ID2, Newhealth, Maxhealth)), 
                retract(health(ID2, Currhealth, Maxhealth)),
                battlestats
            ), 
            (Attacker = 1 ->
                retract(spattack_used(0)), 
                asserta(spattack_used(1))
            ;
                retract(enemy_spattack_used(0)),
                asserta(enemy_spattack_used(1))
            )
        ;
            tokemon(ID1,Name1,_,_),
            spdamage(ID1,SpName,_),
            write(Name1), write(' uses '), write(SpName), write('!'), nl,
            write('Special attacks can only be used once per battle!'), nl,
            nl,battlestats
        )
    ;
        write('Command not available!'), nl
    ),
    !.

battle_end :- 
    (not_available(0) ->
        retract(battle(1)),
        asserta(battle(0)),
        retract(encounter(1)),
        asserta(encounter(0)),
        retract(enemy_spattack_used(_)),
        retract(spattack_used(_)),
        asserta(enemy_spattack_used(0)),
        asserta(spattack_used(0))
    ;
        write('Command not available!'),nl
    ),
    !.

enemy_fainted :-
    (not_available(0) ->
        battleid(_,ID2),
        tokemon(ID2,Name2,_,_),
        asserta(tokemon_fainted(ID2)),
        retract(can_capture(0)),
        asserta(can_capture(1)),
        retract(tokemonpos(ID2,_,_)),
        battle_end,
        check_win,
        (win(0) ->
            nl, write(Name2), write(' faints! Do you want to capture '), write(Name2), write('?'), write(' (capture/0 to capture '), write(Name2), write(', otherwise move away.')
        ;
            !
        )
    ;
        write('Command not available!'),nl

    ),
    !.

yours_fainted :-
    (not_available(0) ->
        nl,write('Your tokemon fainted!'),nl,nl,
        battleid(ID1,_),
        asserta(tokemon_fainted(ID1)),
        inventory(L),
        delete(L,ID1,L2), 
        retract(inventory(L)), 
        asserta(inventory(L2)),
        check_all_fainted,
        (lose(0) ->
            retract(battle(1)),
            asserta(battle(0)),
            retract(battleid(_,_)),
            write('Choose your tokemon!'), nl, nl, 
            avail_tokemon, 
            init_battle
        ;
            battle_end
        )
    ;
        write('Command not available!'),nl
    ),
    !.

check_win :- 
    (not_available(0) ->
        (forall(tokemon(ID,_,_,legendary), (inventory(L),(tokemon_fainted(ID) ; memberchk(ID,L)))) ->
            retract(win(0)),
            asserta(win(1)),
            nl,
            write('Aril: Congratulation!!! You have helped me in defeating or capturing the 2 Legendary Tokemons. As promised, I won’t kill you and you’re free!'),nl,nl,
            write('Congratulation! You won the game.'),
            retract(battleid(_,_)),
            end_game
        ; 
            !
        )
    ;
        write('Command not available!'),nl
    ),
    !.

check_all_fainted :-
    (not_available(0) ->
        inventory(L),
        (L = [] -> 
            retract(lose(0)),
            asserta(lose(1)),
            write('Aril: Ho ho ho. You have failed to complete the missions. As for now, meet your fate and disappear from this world!'),nl,
            end_game
        ;
            !
        )
    ;
        write('Command not available!'),nl
    ),
    !.

capture :- 
    (can_capture(1) ->
        battleid(_,ID2),
        inventory(L), 
        length(L, N), 
        ( N < 6 ->
            retract(not_available(1)),
            asserta(not_available(0)),
            heal(ID2),
            retract(tokemon_fainted(ID2)),
            asserta(inventory([ID2|L])),
            retract(inventory(L)),
            retract(can_capture(1)),
            asserta(can_capture(0)),
            retract(not_available(0)),
            asserta(not_available(1)),
            retract(battleid(_,_))
        ; 
            write('You cannot capture another Tokemon! You have to drop one first.'), nl
        )
    ;
        write('Command not available!'),nl
    ),
    !.

drop(Name) :- 
    (battle(0) ->
        tokemon(ID,Name,_,_), 
        inventory(L),
        (length(L,N), N \= 1 -> 
            (memberchk(ID,L) -> 
                delete(L,ID,L2),
                asserta(tokemon_fainted(ID)),
                retract(inventory(L)), 
                asserta(inventory(L2)), 
                write('You have dropped '), write(Name),nl
            ; 
                write('You don\'t have that tokemon'),nl
            )
        ;
            write('Can\'t drop tokemon!')
        )
    ;
        write('Command not available!'),nl
    ),
    !.
