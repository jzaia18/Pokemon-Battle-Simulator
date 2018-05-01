breed [allies ally]      ;Storage turtles for ally pokemon stats
breed [foes foe]         ;Storage turtles for for pokemon stats
breed [effects effect]   ;Breed for visual effects of moves, statuses, etc.
breed [pointers pointer] ;Breed for pointer that is moved in move selection
breed [moves move]       ;Storage turtles for move stats (keeps track of which team spawned it)

turtles-own [pkmnID name type1 type2 move1 move2 move3 move4 maxHP currentHP atk def spa spd spe acc ev
               skip status statusturns ministatuses ministatusesturns] ;Different stats for pokemon (note it keeps track of moves)
pointers-own [pointerpos] ;For figuring out which move the pointer is hoverring over
effects-own [effectstorage] ;Extra storage for anything an effect turtle could need
moves-own [team moveID movename movetype physical? movepower moveaccuracy priority stab critchance extrastorage owner] ;Move stats

globals [foesprite allysprite ;Which sprites are being used for the ally and foe pokemon
         weather weatherturns ;The current weather of the world, and when it will change
         turn ;What turn it is
         chosenmove alliesnextmove foesnextmove ;Which moves will be used next by each side
         effectiveness ;Storage variable for how effective a move is based on type
         background ;Current background image of the world
         gamefinished?] ;If the game is finished or not


;Initial Setups___________________________________________________________________________________________________________________________

;Just reset but resizes world and patches
to setup
  ca
  set gamefinished? false
  resize-world 0 399 0 274
  set-patch-size 1.25
  reset
end

;Resets variables, set background, sets up pokemon
to reset
  ca
  set gamefinished? false
  pickbackground random 3
  create-allies 1 [allysetup]
  create-foes 1 [foesetup]
  openingsequence
  wait .5
  setupnextturn
end

;Picks a random background
to pickbackground [num]
 set background (word "world_background" num ".png")
 import-drawing background
end

;Sets up ally pokemon (consults several lists)
to allysetup
  evaluatechoice
  setnamespriteally
  setxy 80 80
  set ministatuses 1
  hatch-moves 1 [set team 0
                  set moveID (first [move1] of allies)
                  set owner ally 0
                  movesetup]
  hatch-moves 1 [set team 0
                  set moveID (first [move2] of allies)
                  set owner ally 0
                  movesetup]
  hatch-moves 1 [set team 0
                  set moveID (first [move3] of allies)
                  set owner ally 0
                  movesetup]
  hatch-moves 1 [set team 0
                  set moveID (first [move4] of allies)
                  set owner ally 0
                  movesetup]
  hide-turtle
end

;Sets up foe pokemon (consults several lists)
to foesetup
  pickrandompokemon
  setnamespritefoe
  setxy 295 155
  set ministatuses 1
  hatch-moves 1 [set team 1
                  set moveID (first [move1] of foes)
                  set owner foe 5
                  movesetup]
  hatch-moves 1 [set team 1
                  set moveID (first [move2] of foes)
                  set owner foe 5
                  movesetup]
  hatch-moves 1 [set team 1
                  set moveID (first [move3] of foes)
                  set owner foe 5
                  movesetup]
  hatch-moves 1 [set team 1
                  set moveID (first [move4] of foes)
                  set owner foe 5
                  movesetup]
  hide-turtle
end

;Sets up moves (once again, consults a list)
to movesetup
  hide-turtle
  consultlistmoves
end

;Opening sequence & 1st turn commits______________________________________________________________________________________________________

;The opening animation
to openingsequence
  import-drawing "world_textbox_base.png"
  wait .3
  import-drawing foesprite
  wait .6
  import-drawing "text_wildpokemon.png"
  wait 1
  import-drawing "text_sendout.png"
  wait .3
  create-effects 1 [sendoutpkmn]
  wait .05
  import-drawing allysprite
end

;Makes the pokeball move as it needs to before sending out the pokemon
to sendoutpkmn
  setxy 15 100
  set shape "pokeball"
  set size 30
  set heading 0
  repeat 180
   [rt 1
    fd 1
    wait .001]
  wait .05
  die
end

;Evaluates choice of pokemon (chooser on interface)
to evaluatechoice
  ifelse Ally_Pokemon = "Random"
    [pickrandompokemon]
    [ifelse Ally_Pokemon = "Pikachu"
      [set pkmnID 1]
      [ifelse Ally_Pokemon = "Bulbasaur"
        [set pkmnID 2]
        [ifelse Ally_Pokemon = "Charmander"
          [set pkmnID 3]
          [ifelse Ally_Pokemon = "Squirtle"
            [set pkmnID 4]
            [ifelse Ally_Pokemon = "Butterfree"
              [set pkmnID 5]
              [ifelse Ally_Pokemon = "Meowth"
                [set pkmnID 6]
                [ifelse Ally_Pokemon = "Gengar"
                  [set pkmnID 7]
                  [ifelse Ally_Pokemon = "Primeape"
                    [set pkmnID 8]
                    [ifelse Ally_Pokemon = "Onix"
                      [set pkmnID 9]
                      [ifelse Ally_Pokemon = "Starmie"
                        [set pkmnID 10]
                        [ifelse Ally_Pokemon = "Pidgeot"
                          [set pkmnID 11]
                          [set pkmnID 12]
                        ]]]]]]]]]]]
end

;Picks a random pokemon (assuming one was not picked)
to pickrandompokemon
  set pkmnID (random 12 + 1)
end

;Sets the name of the pokemon, and renders its sprite (ally)
to setnamespriteally
  consultlistnames
  set allysprite (word "ally_" name "_sprite.png")
end

;Sets the name of the pokemon, and renders its sprite (foe)
to setnamespritefoe
  consultlistnames
  set foesprite (word "foe_" name "_sprite.png")
end


;Giant lists for holding data_____________________________________________________________________________________________________________

;List of pokemon names, types, moves and stats (assigns stats based on pokemon ID)
to consultlistnames
  if pkmnID = 1
    [
     set name "Pikachu"
     set type1 1
     set type2 0
     set move1 1
     set move2 2
     set move3 3
     set move4 4
     set maxHP random 48 + 95
     set currentHP maxHP
     set Atk random 64 + 54
     set Def random 62 + 40
     set Spa random 64 + 49
     set Spd random 64 + 49
     set Spe random 72 + 85
     ]
  if pkmnID = 2
    [
      set name "Bulbasaur"
      set type1 2
      set type2 3
      set move1 5
      set move2 6
      set move3 7
      set move4 8
      set maxHP random 48 + 105
      set currentHP maxHP
      set Atk random 64 + 48
      set Def random 64 + 48
      set Spa random 66 + 63
      set Spd random 66 + 63
      set Spe random 62 + 45
      ]
  if pkmnID = 3
    [
      set name "Charmander"
      set type1 4
      set type2 0
      set move1 9
      set move2 10
      set move3 11
      set move4 4
      set maxHP random 48 + 99
      set currentHP maxHP
      set Atk random 64 + 51
      set Def random 62 + 43
      set Spa random 66 + 58
      set Spd random 64 + 49
      set Spe random 66 + 63
      ]
  if pkmnID = 4
    [
      set name "Squirtle"
      set type1 5
      set type2 0
      set move1 12
      set move2 10
      set move3 13
      set move4 14
      set maxHP random 48 + 104
      set currentHP maxHP
      set Atk random 64 + 47
      set Def random 66 + 63
      set Spa random 64 + 49
      set Spd random 66 + 62
      set Spe random 62 + 43
      ]
  if pkmnID = 5
    [
      set name "Butterfree"
      set type1 6
      set type2 7
      set move1 15
      set move2 16
      set move3 7
      set move4 14
      set maxHP random 48 + 120
      set currentHP maxHP
      set Atk random 62 + 45
      set Def random 64 + 49
      set Spa random 70 + 76
      set Spd random 70 + 76
      set Spe random 68 + 67
      ]
  if pkmnID = 6
    [
      set name "Meowth"
      set type1 8
      set type2 0
      set move1 17
      set move2 10
      set move3 18
      set move4 19
      set maxHP random 48 + 100
      set currentHP maxHP
      set Atk random 62 + 45
      set Def random 60 + 36
      set Spa random 62 + 40
      set Spd random 62 + 40
      set Spe random 72 + 85
      ]
    if pkmnID = 7
    [
      set name "Gengar"
      set type1 9
      set type2 3
      set move1 15
      set move2 6
      set move3 3
      set move4 14
      set maxHP random 48 + 120
      set currentHP maxHP
      set Atk random 66 + 63
      set Def random 66 + 58
      set Spa random 80 + 121
      set Spd random 68 + 72
      set Spe random 76 + 103
    ]
    if pkmnID = 8
    [
      set name "Primeape"
      set type1 10
      set type2 0
      set move1 20
      set move2 21
      set move3 11
      set move4 22
      set maxHP random 48 + 125
      set currentHP maxHP
      set Atk random 74 + 99
      set Def random 66 + 58
      set Spa random 66 + 58
      set Spd random 68 + 67
      set Spe random 72 + 90
    ]
    if pkmnID = 9
    [
      set name "Onix"
      set type1 11
      set type2 12
      set move1 20
      set move2 23
      set move3 24
      set move4 22
      set maxHP random 48 + 95
      set currentHP maxHP
      set Atk random 62 + 45
      set Def random 86 + 148
      set Spa random 60 + 31
      set Spd random 62 + 45
      set Spe random 68 + 67
    ]
    if pkmnID = 10
    [
      set name "Starmie"
      set type1 5
      set type2 13
      set move1 12
      set move2 16
      set move3 13
      set move4 25
      set maxHP random 48 + 120
      set currentHP maxHP
      set Atk random 68 + 72
      set Def random 70 + 81
      set Spa random 74 + 94
      set Spd random 70 + 81
      set Spe random 76 + 108
    ]
    if pkmnID = 11
    [
      set name "Pidgeot"
      set type1 8
      set type2 7
      set move1 1
      set move2 21
      set move3 26
      set move4 19
      set maxHP random 48 + 143
      set currentHP maxHP
      set Atk random 70 + 76
      set Def random 68 + 72
      set Spa random 68 + 67
      set Spd random 68 + 67
      set Spe random 72 + 86
    ]
    if pkmnID = 12
    [
      set name "Dragonite"
      set type1 14
      set type2 7
      set move1 12
      set move2 21
      set move3 3
      set move4 27
      set maxHP random 48 + 151
      set currentHP maxHP
      set Atk random 80 + 125
      set Def random 72 + 90
      set Spa random 74 + 94
      set Spd random 74 + 94
      set Spe random 70 + 76
    ]
end

;List of pokemon move stats & types (assigns stats based on move ID)
to consultlistmoves
  if moveID = 1
    [
     set movename "QuickAttack"
     set movetype 8
     set physical? 1
     set movepower 40
     set moveaccuracy 100
     set priority 1
     set critchance 1
  ]
  if moveID = 2
    [
     set movename "VoltTackle"
     set movetype 1
     set physical? 1
     set movepower 120
     set moveaccuracy 100
     set priority 0
     set critchance 1
]
  if moveID = 3
    [
     set movename "Thunderbolt"
     set movetype 1
     set physical? 2
     set movepower 90
     set moveaccuracy 100
     set priority 0
     set critchance 1
]
  if moveID = 4
    [
     set movename "Growl"
     set movetype 8
     set physical? 0
     set movepower 0
     set moveaccuracy 100
     set priority 0
     set critchance 1
]
  if moveID = 5
    [
     set movename "GigaDrain"
     set movetype 2
     set physical? 2
     set movepower 75
     set moveaccuracy 100
     set priority 0
     set critchance 1
]
  if moveID = 6
    [
     set movename "SludgeBomb"
     set movetype 3
     set physical? 2
     set movepower 90
     set moveaccuracy 100
     set priority 0
     set critchance 1
]
  if moveID = 7
    [
     set movename "SleepPowder"
     set movetype 2
     set physical? 0
     set movepower 0
     set moveaccuracy 75
     set priority 0
     set critchance 1
]
  if moveID = 8
    [
     set movename "LeechSeed"
     set movetype 2
     set physical? 0
     set movepower 0
     set moveaccuracy 90
     set priority 0
     set critchance 1
]
  if moveID = 9
    [
     set movename "FlameCharge"
     set movetype 4
     set physical? 1
     set movepower 50
     set moveaccuracy 100
     set priority 0
     set critchance 1
]
  if moveID = 10
    [
     set movename "Bite"
     set movetype 15
     set physical? 1
     set movepower 60
     set moveaccuracy 100
     set priority 0
     set critchance 1
]
  if moveID = 11
    [
     set movename "BrickBreak"
     set movetype 10
     set physical? 1
     set movepower 75
     set moveaccuracy 100
     set priority 0
     set critchance 1
]
  if moveID = 12
    [
     set movename "WaterPulse"
     set movetype 5
     set physical? 2
     set movepower 60
     set moveaccuracy 100
     set priority 0
     set critchance 1
]
  if moveID = 13
    [
     set movename "IceBeam"
     set movetype 16
     set physical? 2
     set movepower 90
     set moveaccuracy 100
     set priority 0
     set critchance 1
]
  if moveID = 14
    [
     set movename "Protect"
     set movetype 8
     set physical? 0
     set movepower 0
     set moveaccuracy 900
     set priority 4
     set critchance 1
]
  if moveID = 15
    [
     set movename "Psychic"
     set movetype 13
     set physical? 2
     set movepower 90
     set moveaccuracy 100
     set priority 0
     set critchance 1
]
  if moveID = 16
    [
     set movename "SignalBeam"
     set movetype 6
     set physical? 2
     set movepower 75
     set moveaccuracy 100
     set priority 0
     set critchance 1
]
  if moveID = 17
    [
     set movename "Slash"
     set movetype 8
     set physical? 1
     set movepower 70
     set moveaccuracy 100
     set priority 0
     set critchance 2
]
  if moveID = 18
    [
     set movename "ShadowClaw"
     set movetype 9
     set physical? 1
     set movepower 70
     set moveaccuracy 100
     set priority 0
     set critchance 2
]
  if moveID = 19
    [
     set movename "Rest"
     set movetype 13
     set physical? 0
     set movepower 0
     set moveaccuracy 900
     set priority 1
     set critchance 1
]
  if moveID = 20
    [
     set movename "StoneEdge"
     set movetype 11
     set physical? 1
     set movepower 100
     set moveaccuracy 80
     set priority 0
     set critchance 2
]
  if moveID = 21
    [
     set movename "AerialAce"
     set movetype 7
     set physical? 1
     set movepower 60
     set moveaccuracy 900
     set priority 0
     set critchance 1
]
  if moveID = 22
    [
     set movename "Earthquake"
     set movetype 12
     set physical? 1
     set movepower 100
     set moveaccuracy 100
     set priority 0
     set critchance 1
]
  if moveID = 23
    [
     set movename "Sandstorm"
     set movetype 11
     set physical? 0
     set movepower 0
     set moveaccuracy 900
     set priority 0
     set critchance 1
]
  if moveID = 24
    [
     set movename "RockPolish"
     set movetype 11
     set physical? 0
     set movepower 0
     set moveaccuracy 900
     set priority 0
     set critchance 1
]
  if moveID = 25
    [
     set movename "Recover"
     set movetype 8
     set physical? 0
     set movepower 0
     set moveaccuracy 900
     set priority 0
     set critchance 1
]
  if moveID = 26
    [
     set movename "GigaImpact"
     set movetype 8
     set physical? 1
     set movepower 150
     set moveaccuracy 90
     set priority 0
     set critchance 1
]
  if moveID = 27
    [
     set movename "DragonPulse"
     set movetype 14
     set physical? 2
     set movepower 85
     set moveaccuracy 100
     set priority 0
     set critchance 1
]
end

;Determines type effectiveness of move based on its type and the defending pokemon's type
to consultlisteffectiveness [atktype deftype1 deftype2]
  set effectiveness 1
  if atktype = 1
  [
    if  (deftype1 = 1) or (deftype2 = 1) [set effectiveness effectiveness * 0.5]
    if  (deftype1 = 2) or (deftype2 = 2) [set effectiveness effectiveness * 0.5]
    if  (deftype1 = 5) or (deftype2 = 5) [set effectiveness effectiveness * 2]
    if  (deftype1 = 7) or (deftype2 = 7) [set effectiveness effectiveness * 2]
    if  (deftype1 = 12) or (deftype2 = 12) [set effectiveness effectiveness * 0]
    if  (deftype1 = 14) or (deftype2 = 14) [set effectiveness effectiveness * 0.5]
    ]
  if atktype = 2
  [
    if (deftype1 = 2) or (deftype2 = 2)   [set effectiveness effectiveness * .5]
    if (deftype1 = 3) or (deftype2 = 3)   [set effectiveness effectiveness * .5]
    if (deftype1 = 4) or (deftype2 = 4)   [set effectiveness effectiveness * .5]
    if (deftype1 = 5) or (deftype2 = 5)   [set effectiveness effectiveness * 2]
    if (deftype1 = 6) or (deftype2 = 6)   [set effectiveness effectiveness * .5]
    if (deftype1 = 7) or (deftype2 = 7)   [set effectiveness effectiveness * .5]
    if (deftype1 = 11) or (deftype2 = 11)   [set effectiveness effectiveness * 2]
    if (deftype1 = 12) or (deftype2 = 12)   [set effectiveness effectiveness * 2]
    if (deftype1 = 14) or (deftype2 = 14)   [set effectiveness effectiveness * .5]
    if (deftype1 = 17) or (deftype2 = 17)   [set effectiveness effectiveness * .5]
    ]
  if atktype = 3
  [
    if (deftype1 = 2) or (deftype2 = 2) [set effectiveness effectiveness * 2]
    if (deftype1 = 3) or (deftype2 = 3) [set effectiveness effectiveness * 0.5]
    if (deftype1 = 9) or (deftype2 = 9) [set effectiveness effectiveness * 0.5]
    if (deftype1 = 11) or (deftype2 = 11) [set effectiveness effectiveness * 0.5]
    if (deftype1 = 12) or (deftype2 = 12) [set effectiveness effectiveness * 0.5]
    if (deftype1 = 17) or (deftype2 = 17) [set effectiveness effectiveness * 0]
    ]
  if atktype = 4
  [
    if (deftype1 = 2) or (deftype2 = 2) [set effectiveness effectiveness * 2]
    if (deftype1 = 4) or (deftype2 = 4) [set effectiveness effectiveness * 0.5]
    if (deftype1 = 5) or (deftype2 = 5) [set effectiveness effectiveness * 0.5]
    if (deftype1 = 6) or (deftype2 = 6) [set effectiveness effectiveness * 2]
    if (deftype1 = 11) or (deftype2 = 11) [set effectiveness effectiveness * 0.5]
    if (deftype1 = 14) or (deftype2 = 14) [set effectiveness effectiveness * 0.5]
    if (deftype1 = 16) or (deftype2 = 16) [set effectiveness effectiveness * 2]
    if (deftype1 = 17) or (deftype2 = 17) [set effectiveness effectiveness * 2]
    ]
  if atktype = 5
  [
    if (deftype1 = 2) or (deftype2 = 2) [set effectiveness effectiveness * 0.5]
    if (deftype1 = 4) or (deftype2 = 4) [set effectiveness effectiveness * 2]
    if (deftype1 = 5) or (deftype2 = 5) [set effectiveness effectiveness * 0.5]
    if (deftype1 = 11) or (deftype2 = 11) [set effectiveness effectiveness * 2]
    if (deftype1 = 12) or (deftype2 = 12) [set effectiveness effectiveness * 2]
    if (deftype1 = 14) or (deftype2 = 14) [set effectiveness effectiveness * 0.5]
    ]
  if atktype = 6
  [
    if (deftype1 = 2) or (deftype2 = 2) [set effectiveness effectiveness * 2]
    if (deftype1 = 3) or (deftype2 = 3) [set effectiveness effectiveness * 0.5]
    if (deftype1 = 4) or (deftype2 = 4) [set effectiveness effectiveness * 0.5]
    if (deftype1 = 7) or (deftype2 = 7) [set effectiveness effectiveness * 0.5]
    if (deftype1 = 9) or (deftype2 = 9) [set effectiveness effectiveness * 0.5]
    if (deftype1 = 10) or (deftype2 = 10) [set effectiveness effectiveness * 0.5]
    if (deftype1 = 13) or (deftype2 = 13) [set effectiveness effectiveness * 2]
    if (deftype1 = 15) or (deftype2 = 15) [set effectiveness effectiveness * 2]
    if (deftype1 = 17) or (deftype2 = 17) [set effectiveness effectiveness * 0.5]
    ]
  if atktype = 7
  [
    if (deftype1 = 1) or (deftype2 = 1) [set effectiveness effectiveness * 0.5]
    if (deftype1 = 2) or (deftype2 = 2) [set effectiveness effectiveness * 2]
    if (deftype1 = 6) or (deftype2 = 6) [set effectiveness effectiveness * 2]
    if (deftype1 = 10) or (deftype2 = 10) [set effectiveness effectiveness * 2]
    if (deftype1 = 11) or (deftype2 = 11) [set effectiveness effectiveness * 0.5]
    if (deftype1 = 17) or (deftype2 = 17) [set effectiveness effectiveness * 0.5]
    ]
  if atktype = 8
  [
    if (deftype1 = 9) or (deftype2 = 9) [set effectiveness effectiveness * 0]
    if (deftype1 = 11) or (deftype2 = 11) [set effectiveness effectiveness * 0.5]
    if (deftype1 = 17) or (deftype2 = 17) [set effectiveness effectiveness * 0.5]
    ]
  if atktype = 9
  [
    if (deftype1 = 8) or (deftype2 = 8) [set effectiveness effectiveness * 0]
    if (deftype1 = 9) or (deftype2 = 9) [set effectiveness effectiveness * 2]
    if (deftype1 = 13) or (deftype2 = 13) [set effectiveness effectiveness * 2]
    if (deftype1 = 15) or (deftype2 = 15) [set effectiveness effectiveness * 0.5]
    if (deftype1 = 17) or (deftype2 = 17) [set effectiveness effectiveness * 0.5]
    ]
  if atktype = 10
  [
    if (deftype1 = 3) or (deftype2 = 3) [set effectiveness effectiveness * 0.5]
    if (deftype1 = 6) or (deftype2 = 6) [set effectiveness effectiveness * 0.5]
    if (deftype1 = 7) or (deftype2 = 7) [set effectiveness effectiveness * 0.5]
    if (deftype1 = 8) or (deftype2 = 8) [set effectiveness effectiveness * 2]
    if (deftype1 = 9) or (deftype2 = 9) [set effectiveness effectiveness * 0]
    if (deftype1 = 11) or (deftype2 = 11) [set effectiveness effectiveness * 2]
    if (deftype1 = 13) or (deftype2 = 13) [set effectiveness effectiveness * 0.5]
    if (deftype1 = 15) or (deftype2 = 15) [set effectiveness effectiveness * 2]
    if (deftype1 = 16) or (deftype2 = 16) [set effectiveness effectiveness * 2]
    if (deftype1 = 17) or (deftype2 = 17) [set effectiveness effectiveness * 2]
  ]
  if atktype = 11
  [
    if (deftype1 = 4) or (deftype2 = 4) [set effectiveness effectiveness * 2]
    if (deftype1 = 6) or (deftype2 = 6) [set effectiveness effectiveness * 2]
    if (deftype1 = 7) or (deftype2 = 7) [set effectiveness effectiveness * 2]
    if (deftype1 = 10) or (deftype2 = 10) [set effectiveness effectiveness * 0.5]
    if (deftype1 = 12) or (deftype2 = 12) [set effectiveness effectiveness * 0.5]
    if (deftype1 = 16) or (deftype2 = 16) [set effectiveness effectiveness * 2]
    if (deftype1 = 17) or (deftype2 = 17) [set effectiveness effectiveness * 0.5]
  ]
  if atktype = 12
  [
    if (deftype1 = 1) or (deftype2 = 1) [set effectiveness effectiveness * 2]
    if (deftype1 = 2) or (deftype2 = 2) [set effectiveness effectiveness * 0.5]
    if (deftype1 = 3) or (deftype2 = 3) [set effectiveness effectiveness * 2]
    if (deftype1 = 4) or (deftype2 = 4) [set effectiveness effectiveness * 2]
    if (deftype1 = 6) or (deftype2 = 6) [set effectiveness effectiveness * 0.5]
    if (deftype1 = 7) or (deftype2 = 7) [set effectiveness effectiveness * 0]
    if (deftype1 = 11) or (deftype2 = 11) [set effectiveness effectiveness * 2]
    if (deftype1 = 17) or (deftype2 = 17) [set effectiveness effectiveness * 2]
  ]
  if atktype = 13
  [
    if (deftype1 = 3) or (deftype2 = 3) [set effectiveness effectiveness * 2]
    if (deftype1 = 10) or (deftype2 = 10) [set effectiveness effectiveness * 2]
    if (deftype1 = 13) or (deftype2 = 13) [set effectiveness effectiveness * 0.5]
    if (deftype1 = 15) or (deftype2 = 15) [set effectiveness effectiveness * 0]
    if (deftype1 = 17) or (deftype2 = 17) [set effectiveness effectiveness * 0.5]
  ]
  if atktype = 14
  [
    if (deftype1 = 14) or (deftype2 = 14) [set effectiveness effectiveness * 2]
    if (deftype1 = 17) or (deftype2 = 17) [set effectiveness effectiveness * 0.5]
  ]
  if atktype = 15
  [
    if (deftype1 = 9) or (deftype2 = 9) [set effectiveness effectiveness * 2]
    if (deftype1 = 10) or (deftype2 = 10) [set effectiveness effectiveness * 0.5]
    if (deftype1 = 13) or (deftype2 = 13) [set effectiveness effectiveness * 2]
    if (deftype1 = 15) or (deftype2 = 15) [set effectiveness effectiveness * 0.5]
    if (deftype1 = 17) or (deftype2 = 17) [set effectiveness effectiveness * 0.5]
  ]
  if atktype = 16
  [
    if (deftype1 = 2) or (deftype2 = 2) [set effectiveness effectiveness * 2]
    if (deftype1 = 4) or (deftype2 = 4) [set effectiveness effectiveness * 0.5]
    if (deftype1 = 5) or (deftype2 = 5) [set effectiveness effectiveness * 0.5]
    if (deftype1 = 7) or (deftype2 = 7) [set effectiveness effectiveness * 2]
    if (deftype1 = 12) or (deftype2 = 12) [set effectiveness effectiveness * 2]
    if (deftype1 = 14) or (deftype2 = 14) [set effectiveness effectiveness * 2]
    if (deftype1 = 16) or (deftype2 = 16) [set effectiveness effectiveness * 0.5]
    if (deftype1 = 17) or (deftype2 = 17) [set effectiveness effectiveness * 0.5]
  ]
  if atktype = 17
  [
    if (deftype1 = 1) or (deftype2 = 1) [set effectiveness effectiveness * 0.5]
    if (deftype1 = 4) or (deftype2 = 4) [set effectiveness effectiveness * 0.5]
    if (deftype1 = 5) or (deftype2 = 5) [set effectiveness effectiveness * 0.5]
    if (deftype1 = 11) or (deftype2 = 11) [set effectiveness effectiveness * 2]
    if (deftype1 = 16) or (deftype2 = 16) [set effectiveness effectiveness * 2]
    if (deftype1 = 17) or (deftype2 = 17) [set effectiveness effectiveness * 0.5]
  ]
end

;Creates visual effects of moves based on move ID
to consultlistmovegraphics [attacker defender graphicmoveID]
  if graphicmoveID = 1 or graphicmoveID = 17
    [create-effects 1 [
      setxy ([xcor] of defender - 10) ([ycor] of defender + 20)
      set shape "footprint other"
      set color black
      set size 20
      wait .2
      set size 40
      wait .2
      set size 20
      wait .2
      die
]]
  if graphicmoveID = 2
    [create-effects 1 [
      setxy [xcor] of attacker [ycor] of attacker
      set shape "volttackle"
      set size 45
      repeat 1440 [rt 1 wait .0005]
      set heading towards defender
      repeat 228 [fd 1 wait .002]
      wait 0.1
      die
]]
  if graphicmoveID = 3
    [create-effects 12 [
      setxy ([xcor] of attacker + random 40 - 20) [ycor] of attacker
      set shape "lightning"
      set color yellow
      set size 30
      set heading towards defender]
      repeat 228 [ask effects [fd 1] wait .005]
      ask effects [wait 0.01
        die
]]
  if graphicmoveID = 4
    [create-effects 1 [
      setxy [xcor] of attacker [ycor] of attacker
      set heading towards defender
      set shape "growl"
      set color red
      set size 80
      wait 0.4
      die
]]
  if graphicmoveID = 5
    [seedeffect attacker defender]

  if graphicmoveID = 6
    [create-effects 1 [
      setxy [xcor] of attacker [ycor] of attacker
      set shape "drop"
      set color violet
      set size 70
      set heading towards defender
      repeat 228 [fd 1 wait .002]
      wait 0.1
      die
]]
  if graphicmoveID = 7
    [create-effects 5 [
      setxy ([xcor] of defender + random 40 - 20) ([ycor] of defender + 45)
      set shape "dot"
      set color green
      set size 20
      set heading 180]
    repeat 30 [ask effects [lt 30 fd 0.5 rt 30 fd 0.5] wait .05]
    wait 0.1
    ask effects [die]
]
  if graphicmoveID = 8
    [create-effects 3 [
      setxy ([xcor] of attacker + random 40 - 20) [ycor] of attacker
      set shape "dot"
      set color green
      set size 10
      set heading towards defender]
  repeat 228 [ask effects [fd 1] wait .005]
  ask effects [hide-turtle]
  ask effects [wait 0.2
    set shape "plant small"
    set size 30
    show-turtle
    wait 0.1
    die]
  import-drawing "text_leechseed.png"
  wait 1
]
  if graphicmoveID = 9
    [create-effects 1 [
      setxy [xcor] of attacker ([ycor] of attacker + 10)
      set size 50
      repeat 4 [set shape "flamecharge1" wait .2 set shape "flamecharge2" wait .2]
      set heading towards defender
      repeat 228 [fd 1 wait .002]
      wait .2
      die
]]
  if graphicmoveID = 10
    [create-effects 1 [
      setxy [xcor] of defender ([ycor] of defender + 10)
      set shape "bite3"
      set size 100
      wait .2
      set shape "bite2"
      wait .2
      set shape "bite1"
      wait .2
      die
]]
  if graphicmoveID = 11
    [create-effects 1 [
      setxy ([xcor] of defender - 10) ([ycor] of defender + 60)
      set shape "brickbreak"
      set size 50
      set color 11.5
      set heading 180
      repeat 80 [fd 1 wait .003]
      wait .1
      die
]]
  if graphicmoveID = 12
    [create-effects 12 [
      setxy ([xcor] of attacker + random 40 - 20) [ycor] of attacker
      set shape "drop"
      set color 97
      set size 30
      set heading towards defender]
  repeat 228 [ask effects [fd 1] wait .005]
  ask effects [wait 0.01
    die
]]
  if graphicmoveID = 13
    [create-effects 1 [
      setxy 200 130
      set shape "beam"
      set color 89
      set size 200
      set heading 70
      wait 2
      die
]]
  if graphicmoveID = 14
    [create-effects 1 [
      setxy [xcor] of attacker ([ycor] of attacker + 10)
      set shape "protect"
      set color 87
      set size 20
      repeat 150 [set size (size + 1) wait .01]
      die
]]
  if graphicmoveID = 15
    [create-effects 1 [
      setxy [xcor] of defender ([ycor] of defender) + 10
      set shape "orbit 6"
      set color magenta
      repeat 10 [set size (random 60) + 60 set heading random 361 wait .2]
      die
]]
  if graphicmoveID = 16
    [create-effects 1 [
      setxy 200 130
      set shape "beam"
      set color 44
      set size 200
      set heading 70
      wait 2
      die
]]
  if graphicmoveID = 18
    [create-effects 1 [
      setxy ([xcor] of defender - 10) ([ycor] of defender + 20)
      set shape "footprint other"
      set color 114
      set size 10
      wait .2
      set size 20
      wait .2
      set size 10
      wait 0.2
      die
]]
  if graphicmoveID = 19
    [sleepeffect attacker
]
  if graphicmoveID = 20
    [create-effects 1 [
      setxy [xcor] of defender [ycor] of defender
      set shape "stoneedge"
      set color 36
      set size 60
      set heading 0
      repeat 50 [fd 1 wait .02]
      die
]]
  if graphicmoveID = 21
    [create-effects 1 [
      setxy ([xcor] of defender - 20) ([ycor] of defender - 10)
      set shape "moon"
      set color 49
      set size 50
      set heading 60
      repeat 40 [fd 1 wait .02]
      set heading 200
      repeat 30 [fd 1 wait .02]
      die
]]
  if graphicmoveID = 22
    [create-effects 1 [
      setxy ([xcor] of defender + 20) ([ycor] of defender + 20)
      set shape "tile stones"
      set color 37
      set size 100]
    repeat 15 [ask effects [set xcor (xcor - 40) wait .05 set xcor (xcor + 40) wait .05]]
    ask effects [die]
]
  if graphicmoveID = 23
    [set weather 1
     set weatherturns 5
     sandstormeffect]
  if graphicmoveID = 24
    [create-effects 1 [
      setxy [xcor] of attacker ([ycor] of attacker + 20)
      set shape "rockpolish"
      set color gray
      set size 50
      wait .2
      set color white
      wait .2
      set color gray
      wait .2
      set color white
      wait .2
      die
]]
  if graphicmoveID = 25
    [create-effects 1 [
      setxy [xcor] of attacker ([ycor] of attacker + 10)
      set shape "star"
      set color white
      set size 20
      repeat 100 [set size (size + 1) wait .01]
      die
]]
  if graphicmoveID = 26
    [create-effects 1 [
      setxy [xcor] of attacker ([ycor] of attacker + 10)
      set shape "gigaimpact"
      set color white
      set size 20
      repeat 100 [set size (size + .5) wait .005]
      set heading towards defender
      repeat 228 [fd 1 wait .002]
      wait 0.1
      die
]]
  if graphicmoveID = 27
    [create-effects 3 [
      setxy [xcor] of attacker [ycor] of attacker
      set shape "dragonpulse"
      set color 114
      set size 50
      set heading towards defender
      repeat 228 [fd 1 wait .002]
      die
]]
end

;Creates visual effect for sandstorm
to sandstormeffect
  repeat 1500 [
      create-effects 1 [
        setxy 399 random-ycor
        set shape "dot"
        set color (random 41 / 10 + 41)
        set size 10
        set heading 270]
    ask effects [ifelse xcor <= 1
      [die]
      [fd 1]]
    wait .0005]
    ask effects [die]
end

;Creates visual effect for leech seed
to seedeffect [attacker defender]
  create-effects 10 [
      setxy ([xcor] of defender + random 20 - 10) ([ycor] of defender + random 20 - 10)
      set shape "dot"
      set size 10
      set color green]
    repeat 10 [ask one-of effects [set heading towards attacker
      repeat 228 [fd 1 wait .001]
      die
]]
end

;Displays visual effects of paralysis
to paralyzeeffect [onto]
  create-effects 1 [
      setxy [xcor] of onto [ycor] of onto
      set shape "volttackle"
      set size 45
      repeat 360 [rt 1 wait .005]
      die
]
end

;Displays visual effects of frfeezing
to freezeeffect [onto]
  create-effects 1 [
    setxy [xcor] of onto [ycor] of onto
    set shape "box"
    set size 80
    set color 88
    repeat 3 [
      set color white
      wait .2
      set color 88
      wait .2]
    die
  ]
end

;Displays visual effects of sleeping
to sleepeffect [onto]
  repeat 3
    [create-effects 1 [
       setxy ([xcor] of onto + 20) ([ycor] of onto + 30)
       set shape "rest"
       set color pink
       set size 40
       set heading 45
       repeat 20 [fd 1 set size (size + 2) wait .04]
       die
]]
end

;Displays visual effects of poison
to poisoneffect [onto]
  create-effects 1 [
    setxy [xcor] of onto [ycor] of onto
    set shape "poison"
    set color 122
    set size 80
    repeat 50 [
      set size size + 20
      set ycor ycor + 1
      set size size - 20
      wait .015]
    die
]
end

;Displays visual effects of confusion
to confuseeffect [onto]
  create-effects 1 [
    setxy [xcor] of onto + 20 [ycor] of onto + 30
    set shape "bird side"
    set color 46
    set size 30
    repeat 3 [
      repeat 2 [
        set xcor xcor - 20
        wait .1]
      repeat 2 [
        set xcor xcor + 20
        wait .1]]
    die]

end

;A giant list of the status ailments/buff caused by different moves, based on ID
to consultliststatusmove [usedby usedon damagedelton statusmoveID]
  if statusmoveID = 2
    [ask usedby [set currentHP currentHP - (.33 * damagedelton)]
     checkfainting
     import-drawing "text_recoil.png"]
  if statusmoveID = 3
    [if ([status] of usedon = 0) and (random 10 = 0) and ([type1] of usedon != 1) and ([type2] of usedon != 1)
      [ask usedon [set status 3]]
       paralyzeeffect usedon
       import-drawing "text_paralysis.png"]
  if statusmoveID = 4
    [ask usedon [set atk (round atk * .67)]
     import-drawing "text_lowatk.png"]
  if statusmoveID = 5
    [ifelse [maxHP] of usedby <= ([currentHP] of usedby + (damagedelton * .5))
      [ask usedby [set currentHP maxHP]]
      [ask usedby [set currentHP (currentHP + (damagedelton * .5))]]
      import-drawing "text_HPdrain.png"]
  if statusmoveID = 6
    [if ([status] of usedon = 0) and (random 10 < 3) and ([type1] of usedon != 3) and ([type1] of usedon != 17) and
        ([type2] of usedon != 3) and ([type2] of usedon != 17)
      [ask usedon [set status 2]
       poisoneffect usedon
       import-drawing "text_poison.png"]]
  if statusmoveID = 7
    [if ([status] of usedon = 0) and ([type1] of usedon != 2) and ([type2] of usedon != 2)
      [ask usedon [set status 1 set statusturns (random 4 + 1)]
       sleepeffect usedon
       import-drawing "text_sleep.png"]]
  if statusmoveID = 8
    [if ([ministatuses] of usedon mod 5 != 0) and ([type1] of usedon != 12) and ([type2] of usedon != 12)
      [ask usedon [set ministatuses ministatuses * 5]
       import-drawing "text_leechseed.png"]]
  if statusmoveID = 9
    [ask usedby [set spe spe * 1.5]
     import-drawing "text_speedraise.png"]
  if statusmoveID = 10
    [if random 10 < 3
      [ask usedon
        [set ministatuses ministatuses * 2
         set ministatusesturns (random 4 + 1)]]]
  if statusmoveID = 12
    [if ([ministatuses] of usedon mod 3 != 0) and random 10 < 2
      [ask usedon [set ministatuses ministatuses * 3]
       import-drawing "text_confuse.png"]]
  if statusmoveID = 13
    [if ([status] of usedon = 0) and (random 10 = 0) and ([type1] of usedon != 16) and ([type2] of usedon != 16)
      [ask usedon [set status 4]
       freezeeffect usedon
       import-drawing "text_frozen.png"]]
  ifelse statusmoveID = 14
    [ask usedon [set skip 1]
     ask moves with [moveID = 14 and owner = usedby] [set extrastorage extrastorage + 1]
     import-drawing "text_protect.png"]
    [ask moves with [moveID = 14 and owner = usedby] [set extrastorage 0]]
  if statusmoveID = 15
    [if (random 10 = 0)
     [ask usedon [set spd spd * .67]
      import-drawing "text_lowspd.png"]]
  if statusmoveID = 16
    [if ([ministatuses] of usedon mod 3 != 0) and random 10 < 0
      [ask usedon [set ministatuses ministatuses * 3]
       import-drawing "text_confused.png"]]
  if statusmoveID = 19
    [ask usedby
      [set currentHP maxHP
       set status 1
       set statusturns (random 4 + 1)]
       import-drawing "text_sleep.png"]
  if statusmoveID = 23
    [set weather 1
     set weatherturns 5
     import-drawing "text_sandstorm.png"]
  if statusmoveID = 24
    [ask usedby [set spe spe * 2]
     import-drawing "text_speedraise.png"]
  if statusmoveID = 25
    [ifelse [currentHP] of usedby > ([maxHP] of usedby * .5)
      [ask usedby [set currentHP maxHP]]
      [ask usedby [set currentHP (currentHP + maxHP * .5)]]
     import-drawing "text_heal.png"]
  if statusmoveID = 26
    [ask usedby [set skip 2]
     import-drawing "text_recharge.png"]
  wait 1
end

;Applies status conditions that work before a turn
to consultliststatusconditionsbefore [onto]
  ifelse [status] of onto = 4
    [import-drawing "text_frozen.png"
     freezeeffect onto
     ifelse random 10 = 0
      [ask onto
         [set status 0
          set skip 0]
       import-drawing "text_thaw.png"
       wait 1]
      [ask onto [set skip 1]]]
    [ifelse [status] of onto = 3
      [import-drawing "text_paralysis.png"
       paralyzeeffect onto
       if random 10 < 3
        [ask onto [set skip 1]
         import-drawing "text_isparalyzed.png"
         wait 1]]
      [if [status] of onto = 1
         [import-drawing "text_issleep.png"
          sleepeffect onto
          ifelse [statusturns] of onto <= 0
           [ask onto [set status 0]
            import-drawing "text_wakeup.png"
            wait 1]
           [ask onto
             [set skip 1
              set statusturns statusturns - 1]]]]]
end

;Applies status conditions that work after a turn
to consultliststatusconditionsafter [onto]
  if [status] of onto = 2
    [ask onto [set currentHP (currentHP - (.125 * maxHP))]
     import-drawing "text_ispoison.png"
     poisoneffect onto
     wait .5]
end

;Applies volatile status conditions that work before a turn
to consultlistministatusbefore [onto]
  if [ministatuses] of onto mod 2 = 0
    [ask onto [set skip 1]
     import-drawing "text_flinch.png"
     wait 1]
  if [ministatuses] of onto mod 3 = 0
    [import-drawing "text_isconfused.png"
     confuseeffect onto
     ifelse [ministatusesturns] of onto <= 0
      [ask onto [set ministatuses ministatuses / 3]
       import-drawing "text_confusedsnap.png"
       wait 1]
      [if random 2 = 0
        [ask onto
          [set skip 1
           set currentHP (currentHP - (40 * atk * 110 * (random 16 / 10 + .85) / 250 / def))]]
       ask onto [set ministatusesturns ministatusesturns - 1]]]
end

;Applies volatile status conditions that work after a turn
to consultlistministatusafter [from onto]
  if [ministatuses] of onto mod 5 = 0
    [import-drawing "text_isleechseed.png"
     seedeffect from onto
     ask onto [set currentHP (currentHP - (.0625 * maxHP))]
     ask from [set currentHP (currentHP + (.0625 * maxHP))]
     ]
end

;Turn-by-turn code________________________________________________________________________________________________________________________

;Delegates order for which processes occur in a turn
to runturn
  checkfainting
  ifelse gamefinished?
    [ask pointers [die]
     stop]
    [updatemoves
     allymovepick
     if chosenmove > 0
       [foemovepick
        statuseffectsbefore
        carryout
        statuseffectsafter
        weathereffects
        setupnextturn
        ask turtles
          [if ministatuses mod 2 = 0
            [set ministatuses ministatuses / 2]
           if skip > 0
            [set skip skip - 1]]]]
end

;Updates stats of moves based on stats of pokemon
to updatemoves
  ask moves with [team = 0] [
    set atk [atk] of ally 0
    set def [def] of ally 0
    set spa [spa] of ally 0
    set spd [spd] of ally 0
    set spe [spe] of ally 0]
  ask moves with [team = 1] [
    set atk [atk] of foe 5
    set def [def] of foe 5
    set spa [spa] of foe 5
    set spd [spd] of foe 5
    set spe [spe] of foe 5]
 checkstab
end

;Checks if a move gains Same Type Attack Bonus
to checkstab
  ask moves with [team = 0] [
    ifelse (movetype = [type1] of ally 0) or (movetype = [type2] of ally 0)
      [set stab 1.5]
      [set stab 1]]
  ask moves with [team = 1] [
    ifelse (movetype = [type1] of foe 5) or (movetype = [type2] of foe 5)
      [set stab 1.5]
      [set stab 1]]
end

;Sets up next turn
to setupnextturn
  checkfainting
  if not gamefinished?
    [moveselectimages
     set turn turn + 1
     set chosenmove 0
     pointersetup]
end

;Waits for the user to pick a move
to allymovepick
  if chosenmove > 0
    [ask move chosenmove [set alliesnextmove who]]
end

;Displays images for moves in textbox
to moveselectimages
  import-drawing "world_textbox_base.png"
  import-drawing (word "text_move_" ([movename] of move 1) ".png")
  import-drawing (word "text_move_" ([movename] of move 2) ".png")
  import-drawing (word "text_move_" ([movename] of move 3) ".png")
  import-drawing (word "text_move_" ([movename] of move 4) ".png")
end

;Picks a random move for foe (could be replaced with an AI, given we had more time)
to foemovepick
  ask move (6 + random 4) [set foesnextmove who]
end

;Carries out moves in the order of which they should be
to carryout
  ifelse [priority] of move alliesnextmove = [priority] of move foesnextmove
    [ifelse [spe] of move alliesnextmove > [spe] of move foesnextmove
      [attackfoe
       checkfainting
       if not gamefinished?
         [getattacked]]
      [getattacked
       checkfainting
       if not gamefinished?
         [attackfoe]]]
    [ifelse [priority] of move alliesnextmove > [priority] of move foesnextmove
      [attackfoe
       checkfainting
       if not gamefinished?
         [getattacked]]
      [getattacked
       checkfainting
       if not gamefinished?
         [attackfoe]]]
end

;Asks ally to attack foe
to attackfoe
  usemove (move alliesnextmove) (move foesnextmove) ([type1] of foe 5) ([type2] of foe 5) ([atk] of move alliesnextmove)
    ([spa] of move alliesnextmove) ([def] of move foesnextmove)([spd] of move foesnextmove) ([movepower] of move alliesnextmove)
    ([moveaccuracy] of move alliesnextmove) ([physical?] of move alliesnextmove) ([movetype] of move alliesnextmove)
    ([critchance] of move alliesnextmove) ([stab] of move alliesnextmove) ([moveID] of move alliesnextmove)
end

;Asks foe to attack ally
to getattacked
  usemove (move foesnextmove) (move alliesnextmove) ([type1] of ally 0) ([type2] of ally 0) ([atk] of move foesnextmove)
    ([spa] of move foesnextmove) ([def] of move alliesnextmove) ([spd] of move alliesnextmove) ([movepower] of move foesnextmove)
    ([moveaccuracy] of move foesnextmove) ([physical?] of move foesnextmove) ([movetype] of move foesnextmove) ([critchance] of move foesnextmove)
    ([stab] of move foesnextmove) ([moveID] of move foesnextmove)
end

;Designates where moves go, and displays messages
to usemove [attacker defender deftype1 deftype2 attack spatk defense spdef pow accuracy phys? movetyp crit stab? statusmoveID]
  consultlistministatusbefore foe 5
  consultlistministatusbefore ally 0
  if [skip] of ([owner] of attacker) <= 0
    [ifelse statusmoveID = 14
      [ifelse random 100 < (100 / ([extrastorage] of attacker + 1))
        [displaydamagemessagesbefore ([team] of defender)
         consultlistmovegraphics [owner] of attacker [owner] of defender statusmoveID
         consultliststatusmove [owner] of attacker [owner] of defender 0 statusmoveID]
        [displaydamagemessagesbefore ([team] of defender)
         import-drawing "text_itfailed.png"
         wait 1]]
      [ifelse random 100 < accuracy
        [ifelse phys? = 0
          [displaydamagemessagesbefore ([team] of defender)
            consultlistmovegraphics [owner] of attacker [owner] of defender statusmoveID
            consultliststatusmove [owner] of attacker [owner] of defender 0 statusmoveID]
          [consultlisteffectiveness movetyp deftype1 deftype2
            let crit? 1
            if random (16 / crit) = 0
              [set crit? 2]
            ifelse phys? = 1
              [damage attacker defender (attack * pow * 110) (defense * 250)  effectiveness crit? (stab? * (((random 16) / 100) + .85)) statusmoveID]
              [damage attacker defender (spatk * pow * 110) (spdef * 250)  effectiveness crit? (stab? * (((random 16) / 100) + .85)) statusmoveID]]]
        [displaydamagemessagesbefore ([team] of defender)
         import-drawing "text_itmissed.png"
         wait 1]]]
end

;Deals damage onto pokemon "onto" based on move stats
to damage [attacker onto atkpwr defpwr effective crit? modifier statusmoveID]
  let damagedelttempvar ((atkpwr / defpwr + 2) * effective * crit? * modifier)
  displaydamagemessagesbefore ([team] of onto)
  consultlistmovegraphics ([owner] of attacker) ([owner] of onto) statusmoveID
    ask turtle (5 * [team] of onto)
      [set currentHP currentHP - damagedelttempvar]
  checkfainting
  displaydamagemessagesafter effective crit?
  consultliststatusmove ([owner] of attacker) ([owner] of onto) damagedelttempvar statusmoveID
end

;Displays battle messages before attacks
to displaydamagemessagesbefore [onto]
  ifelse onto = 1
    [import-drawing "text_allyattack.png"]
    [import-drawing "text_foeattack.png"]
  wait 1
end

;Displays battle messages after attacks
to displaydamagemessagesafter [effective crit?]
  if effective != 1
    [ifelse effective >= 2
      [import-drawing "text_supereffect.png"]
      [ifelse effective = 0
        [import-drawing "text_noeffect.png"]
        [if effective < 1
          [import-drawing "text_notveryeffect.png"]]]
     wait 1]
  if crit? = 2
    [import-drawing "text_crithit.png"
     wait 1]
end

;Applies statuses before attacking
to statuseffectsbefore
  consultliststatusconditionsbefore foe 5
  consultliststatusconditionsbefore ally 0
end

;Applies statuses after attacking
to statuseffectsafter
  consultliststatusconditionsafter foe 5
  consultliststatusconditionsafter ally 0
  consultlistministatusafter ally 0 foe 5
  consultlistministatusafter foe 5 ally 0
end

;Checks and displays weather effects
to weathereffects
  if weather = 1
    [ifelse weatherturns = 0
      [set weather 0]
      [import-drawing "text_issandstorm.png"
       sandstormeffect
       ask foes [sandstormdamage]
       ask allies [sandstormdamage]
       set weatherturns weatherturns - 1]]
end

;Deals damage if weather is sandstorm
to sandstormdamage
  if (type1 != 11) and (type1 != 12) and (type1 != 17) and (type2 != 11) and (type2 != 12) and (type2 != 17)
    [set currentHP (currentHP - (.0625 * maxHP))]
end

;Checks if any pokemon have fainted
to checkfainting
 if (any? allies with [currentHP <= 0]) or (any? foes with [currentHP <= 0])
   [ifelse ((count (allies with [currentHP <= 0])) + (count (foes with [currentHP <= 0]))) >= 2
     [removepokemon allies 1]
     [ifelse any? (allies with [currentHP <= 0])
       [removepokemon allies 0]
       [removepokemon foes 0]]]
end

;Removes fainted pokemon and ends game
to removepokemon [breedtoremove both?]
  import-drawing background
  ifelse both? = 1
    [import-pcolors "text_draw.png"]
    [ifelse breedtoremove = allies
      [ask allies [set currentHP 0]
       import-drawing foesprite
       import-drawing "text_allyfaint.png"]
      [import-drawing allysprite
       ask foes [set currentHP 0]
       import-drawing "text_foefaint.png"]]
    ask pointers [die]
  set gamefinished? true
end

;Pointer code_____________________________________________________________________________________________________________________________

;Sets up pointer
to pointersetup
  create-pointers 1 [
    set color black
    set shape "pointer"
    set size 50
    set pointerpos 1
    setxy 25 58]
end

;Moves pointer up
to pointerup
  ask pointers [
  ifelse pointerpos = 3 or pointerpos = 4
    [set pointerpos pointerpos - 2]
    [set pointerpos pointerpos + 2]
  pointeralign]
end

;Moves pointer down
to pointerdown
  ask pointers [
  ifelse pointerpos = 1 or pointerpos = 2
    [set pointerpos pointerpos + 2]
    [set pointerpos pointerpos - 2]
  pointeralign]
end

;Moves pointer left
to pointerleft
  ask pointers [
  ifelse pointerpos = 2 or pointerpos = 4
    [set pointerpos pointerpos - 1]
    [set pointerpos pointerpos + 1]
  pointeralign]
end

;Moves pointer right
to pointerright
  ask pointers [
  ifelse pointerpos = 1 or pointerpos = 3
    [set pointerpos pointerpos + 1]
    [set pointerpos pointerpos - 1]
  pointeralign]
end

;Akigns pointer with its position
to pointeralign
  if pointerpos = 1
    [setxy 23 58]
  if pointerpos = 2
    [setxy 208 58]
  if pointerpos = 3
    [setxy 23 32]
  if pointerpos = 4
    [setxy 208 32]
end

;Asks pokemon to use the move that the pointer is on
to use
  ask pointers [
    set chosenmove pointerpos
    die]
end

;Reporters________________________________________________________________________________________________________________________________

;Name of the foe
to-report #foename
  report (first [name] of foes)
end

;Foe's HP (as a percentage)
to-report #foeHP%
  report (word (#foeHP - (#foeHP mod 1)) "%")
end

;Foe's HP (as a number)
to-report #foeHP
  report (100 * first [currentHP] of foes) / (first [maxHP] of foes)
end

;Name of the ally
to-report #allyname
  report (first [name] of allies)
end

;Ally's HP (as a percentage)
to-report #allyHP%
  report (word (#allyHP - (#allyHP mod 1)) "%")
end

;Ally's HP (as a number)
to-report #allyHP
  report (100 * first [currentHP] of allies) / (first [maxHP] of allies)
end
@#$#@#$#@
GRAPHICS-WINDOW
224
10
734
384
-1
-1
1.25
1
10
1
1
1
0
0
0
1
0
399
0
274
0
0
1
ticks
30.0

BUTTON
12
43
76
76
NIL
setup
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

TEXTBOX
13
10
81
41
For 1st time\n    setup:
12
0.0
1

TEXTBOX
121
10
197
46
For clearing of the field:
12
0.0
1

BUTTON
121
43
184
76
NIL
reset
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

MONITOR
230
35
310
80
Enemy:
#foename
17
1
11

MONITOR
308
35
358
80
HP:
#foeHP%
0
1
11

MONITOR
601
240
681
285
Ally:
#allyname
17
1
11

MONITOR
680
240
730
285
HP:
#allyHP%
17
1
11

CHOOSER
5
183
147
228
Ally_Pokemon
Ally_Pokemon
"Pikachu" "Bulbasaur" "Charmander" "Squirtle" "Butterfree" "Meowth" "Gengar" "Primeape" "Onix" "Starmie" "Pidgeot" "Dragonite" "Random"
12

MONITOR
680
35
730
80
Turn:
turn
17
1
11

BUTTON
74
281
129
314
Up
pointerup
NIL
1
T
OBSERVER
NIL
W
NIL
NIL
1

BUTTON
22
312
77
345
Left
pointerleft
NIL
1
T
OBSERVER
NIL
A
NIL
NIL
1

BUTTON
127
312
182
345
Right
pointerright
NIL
1
T
OBSERVER
NIL
D
NIL
NIL
1

BUTTON
74
343
129
376
Down
pointerdown
NIL
1
T
OBSERVER
NIL
S
NIL
NIL
1

BUTTON
74
312
129
345
NIL
Use
NIL
1
T
OBSERVER
NIL
F
NIL
NIL
1

BUTTON
66
116
129
149
Run
runturn
T
1
T
OBSERVER
NIL
R
NIL
NIL
1

TEXTBOX
70
86
131
116
 Runs the\nSimulation:
12
0.0
1

TEXTBOX
10
163
128
181
Pick your pokemon:
12
0.0
1

TEXTBOX
48
258
171
276
For selecting a move:
12
0.0
1

@#$#@#$#@
## WHAT IS IT?

This is a Pokemon battle simulator. It includes twelve different pokemon along with twenty seven different moves. Grpahically, it has twenty four different sprites, three different backgrounds, and over thirty different move and effect graphics and over 50 custom text boxes. This version fully accounts for the correct stats, type effectiveness, physical special split, critical hits, volatile and non-volatile status conditions.

## HOW IT WORKS

The pokemon sprites that are appearing are drawings on the world called by the "import-drawing" function, and do nothing but look great graphically. The code uses turtles to store the variables for the moves and pokemon themselves. Each pokemon turtle has all of its corresponding stats as variables and its team alignment as its breed. Moves are hatched from the inital turtle and have all of the corresponding move stats as well as the pokemon they belong to AND the stats of the pokemon they belong to.
When running turns, it uses ask turtles to break up the order of operations and it consults a lot of lists (see list section of code) to get the information that it needs. Then based on that information, it runs the damage calculations and/or consults the list of status effects, and applies effects accordingly (graphic effects are run during this process). After that, it checks all of the global variables, tells the pokemon not to skip their next turn, and checks for fainting. Then, it increases the turn counter by one and runs the process again, and repeats this unti at least one pokemon faints, in which case everything stops, and a victory/defeat/tie message is displayed.

## HOW TO USE IT

Use the chooser to pick your pokemon. Use setup or reset to clear the field. Use run to run the game. Use the directional buttons and the use button to pick moves and adjust the pointer. (WASD and F can be used instead if preffered)

Note: Using the run function without using setup or reset once first will cause the code to break.

## THINGS TO NOTICE

Pokemon sprites are not turtles. Invisible turtles lie at the center of the bottom of the sprites, holding the variables for moves and pokemon.


## EXTENDING THE MODEL

This model is essentially a massive proof of concept. Given the time, you could theoretically add an infinite number of pokemon and moves without changing any of the code other than the lists of pokemon and moves.


## CREDITS AND REFERENCES
- Marie-Michelle Ivantechenko & Jake Zaia (obviously)
- Ms. Genkina for being a great CS teacher for the 1st semester
- Nintendo's graphic design team for the sprites
- Shoutout to the developers of GIMP for creating such a useful program for free!
- Pokemon Showdown (http://www.play.pokemonshowdown.com) for being a major inspiration
- Edmond Wong for betatesting, debugging help, and overall support
- Piotr Milewski and Nick Pustilnik for being a worthy competition and great sports!
- Shoutout to all the classmates for the support and testing!
@#$#@#$#@
default
true
0
Polygon -7500403 true true 150 5 40 250 150 205 260 250

airplane
true
0
Polygon -7500403 true true 150 0 135 15 120 60 120 105 15 165 15 195 120 180 135 240 105 270 120 285 150 270 180 285 210 270 165 240 180 180 285 195 285 165 180 105 180 60 165 15

arrow
true
0
Polygon -7500403 true true 150 0 0 150 105 150 105 293 195 293 195 150 300 150

beam
true
0
Rectangle -7500403 true true 135 0 150 300

bird side
false
0
Polygon -7500403 true true 0 120 45 90 75 90 105 120 150 120 240 135 285 120 285 135 300 150 240 150 195 165 255 195 210 195 150 210 90 195 60 180 45 135
Circle -16777216 true false 38 98 14

bite1
false
0
Polygon -1 true false 150 165 105 255 195 255
Polygon -1 true false 150 150 105 60 195 60
Polygon -1 true false 75 165 45 240 105 240
Polygon -1 true false 225 165 195 240 255 240
Polygon -1 true false 75 150 45 75 105 75
Polygon -1 true false 225 150 195 75 255 75
Polygon -1 true false 30 150 15 210 45 210
Polygon -1 true false 270 150 255 210 285 210
Polygon -1 true false 270 150 255 90 285 90
Polygon -1 true false 30 150 15 90 45 90

bite2
false
0
Polygon -1 true false 150 195 105 285 195 285
Polygon -1 true false 150 120 105 30 195 30
Polygon -1 true false 75 180 45 255 105 255
Polygon -1 true false 225 180 195 255 255 255
Polygon -1 true false 75 135 45 60 105 60
Polygon -1 true false 225 135 195 60 255 60
Polygon -1 true false 30 165 15 225 45 225
Polygon -1 true false 270 165 255 225 285 225
Polygon -1 true false 270 135 255 75 285 75
Polygon -1 true false 30 135 15 75 45 75

bite3
false
0
Polygon -1 true false 150 225 105 315 195 315
Polygon -1 true false 150 90 105 0 195 0
Polygon -1 true false 75 210 45 285 105 285
Polygon -1 true false 225 210 195 285 255 285
Polygon -1 true false 75 105 45 30 105 30
Polygon -1 true false 225 105 195 30 255 30
Polygon -1 true false 30 195 15 255 45 255
Polygon -1 true false 270 195 255 255 285 255
Polygon -1 true false 270 105 255 45 285 45
Polygon -1 true false 30 105 15 45 45 45

box
false
0
Polygon -7500403 true true 150 285 285 225 285 75 150 135
Polygon -7500403 true true 150 135 15 75 150 15 285 75
Polygon -7500403 true true 15 75 15 225 150 285 150 135
Line -16777216 false 150 285 150 135
Line -16777216 false 150 135 15 75
Line -16777216 false 150 135 285 75

brickbreak
false
0
Line -7500403 true 90 105 150 60
Line -7500403 true 150 60 165 60
Line -7500403 true 165 60 165 75
Line -7500403 true 75 135 105 165
Line -7500403 true 90 105 75 120
Line -7500403 true 210 105 225 135
Line -7500403 true 225 135 210 165
Line -7500403 true 210 165 120 180
Line -7500403 true 120 180 75 165
Line -7500403 true 210 105 135 105
Line -7500403 true 120 90 120 165
Line -7500403 true 135 75 135 165
Line -7500403 true 210 150 135 150
Polygon -7500403 true true 150 60 165 60 165 75 135 105 210 105 225 135 210 165 120 180 75 165 75 120 150 60
Line -16777216 false 210 120 135 120
Line -16777216 false 225 135 135 135
Line -16777216 false 210 150 135 150

bug
true
0
Circle -7500403 true true 96 182 108
Circle -7500403 true true 110 127 80
Circle -7500403 true true 110 75 80
Line -7500403 true 150 100 80 30
Line -7500403 true 150 100 220 30

butterfly
true
0
Polygon -7500403 true true 150 165 209 199 225 225 225 255 195 270 165 255 150 240
Polygon -7500403 true true 150 165 89 198 75 225 75 255 105 270 135 255 150 240
Polygon -7500403 true true 139 148 100 105 55 90 25 90 10 105 10 135 25 180 40 195 85 194 139 163
Polygon -7500403 true true 162 150 200 105 245 90 275 90 290 105 290 135 275 180 260 195 215 195 162 165
Polygon -16777216 true false 150 255 135 225 120 150 135 120 150 105 165 120 180 150 165 225
Circle -16777216 true false 135 90 30
Line -16777216 false 150 105 195 60
Line -16777216 false 150 105 105 60

car
false
0
Polygon -7500403 true true 300 180 279 164 261 144 240 135 226 132 213 106 203 84 185 63 159 50 135 50 75 60 0 150 0 165 0 225 300 225 300 180
Circle -16777216 true false 180 180 90
Circle -16777216 true false 30 180 90
Polygon -16777216 true false 162 80 132 78 134 135 209 135 194 105 189 96 180 89
Circle -7500403 true true 47 195 58
Circle -7500403 true true 195 195 58

circle
false
0
Circle -7500403 true true 0 0 300

circle 2
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240

cow
false
0
Polygon -7500403 true true 200 193 197 249 179 249 177 196 166 187 140 189 93 191 78 179 72 211 49 209 48 181 37 149 25 120 25 89 45 72 103 84 179 75 198 76 252 64 272 81 293 103 285 121 255 121 242 118 224 167
Polygon -7500403 true true 73 210 86 251 62 249 48 208
Polygon -7500403 true true 25 114 16 195 9 204 23 213 25 200 39 123

cylinder
false
0
Circle -7500403 true true 0 0 300

dot
false
0
Circle -7500403 true true 90 90 120

dragonpulse
true
0
Polygon -7500403 true true 151 421 134 417 103 417 59 383 40 345 32 292 37 243 68 281 71 244 83 207 111 162 127 190 148 146 167 176 180 247 195 192 217 226 226 261 227 338 256 291 256 336 238 398 213 413 183 416
Polygon -1 true false 155 419 172 403 172 378 162 359 148 336 130 368 131 395 135 417
Polygon -7500403 true true 151 211 134 207 103 207 59 173 40 135 32 82 37 33 68 71 71 34 83 -3 111 -48 127 -20 148 -64 167 -34 180 37 195 -18 217 16 226 51 227 128 256 81 256 126 238 188 213 203 183 206
Polygon -1 true false 155 209 172 193 172 168 162 149 148 126 130 158 131 185 135 207
Polygon -7500403 true true 151 31 134 27 103 27 59 -7 40 -45 32 -98 37 -147 68 -109 71 -146 83 -183 111 -228 127 -200 148 -244 167 -214 180 -143 195 -198 217 -164 226 -129 227 -52 256 -99 256 -54 238 8 213 23 183 26
Polygon -1 true false 155 29 172 13 172 -12 162 -31 148 -54 130 -22 131 5 135 27

drop
true
0
Circle -7500403 true true 73 15 152
Polygon -7500403 true true 219 119 205 148 185 180 174 205 163 236 156 263 149 293 147 134
Polygon -7500403 true true 79 118 95 148 115 180 126 205 137 236 144 263 150 294 154 135

egg
false
0
Circle -7500403 true true 96 76 108
Circle -7500403 true true 72 104 156
Polygon -7500403 true true 221 149 195 101 106 99 80 148

face happy
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 255 90 239 62 213 47 191 67 179 90 203 109 218 150 225 192 218 210 203 227 181 251 194 236 217 212 240

face neutral
false
0
Circle -7500403 true true 8 7 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Rectangle -16777216 true false 60 195 240 225

face sad
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 168 90 184 62 210 47 232 67 244 90 220 109 205 150 198 192 205 210 220 227 242 251 229 236 206 212 183

fire
false
0
Polygon -7500403 true true 151 286 134 282 103 282 59 248 40 210 32 157 37 108 68 146 71 109 83 72 111 27 127 55 148 11 167 41 180 112 195 57 217 91 226 126 227 203 256 156 256 201 238 263 213 278 183 281
Polygon -955883 true false 126 284 91 251 85 212 91 168 103 132 118 153 125 181 135 141 151 96 185 161 195 203 193 253 164 286
Polygon -2674135 true false 155 284 172 268 172 243 162 224 148 201 130 233 131 260 135 282

fish
false
0
Polygon -1 true false 44 131 21 87 15 86 0 120 15 150 0 180 13 214 20 212 45 166
Polygon -1 true false 135 195 119 235 95 218 76 210 46 204 60 165
Polygon -1 true false 75 45 83 77 71 103 86 114 166 78 135 60
Polygon -7500403 true true 30 136 151 77 226 81 280 119 292 146 292 160 287 170 270 195 195 210 151 212 30 166
Circle -16777216 true false 215 106 30

flag
false
0
Rectangle -7500403 true true 60 15 75 300
Polygon -7500403 true true 90 150 270 90 90 30
Line -7500403 true 75 135 90 135
Line -7500403 true 75 45 90 45

flamecharge1
false
0
Polygon -955883 true false 151 31 134 27 103 27 59 -7 40 -45 32 -98 37 -147 68 -109 71 -146 83 -183 111 -228 127 -200 148 -244 167 -214 180 -143 195 -198 217 -164 226 -129 227 -52 256 -99 256 -54 238 8 213 23 183 26
Polygon -955883 true false 151 526 134 522 103 522 59 488 40 450 32 397 37 348 68 386 71 349 83 312 111 267 127 295 148 251 167 281 180 352 195 297 217 331 226 366 227 443 256 396 256 441 238 503 213 518 183 521
Polygon -955883 true false -74 256 -91 252 -122 252 -166 218 -185 180 -193 127 -188 78 -157 116 -154 79 -142 42 -114 -3 -98 25 -77 -19 -58 11 -45 82 -30 27 -8 61 1 96 2 173 31 126 31 171 13 233 -12 248 -42 251
Polygon -955883 true false 391 301 374 297 343 297 299 263 280 225 272 172 277 123 308 161 311 124 323 87 351 42 367 70 388 26 407 56 420 127 435 72 457 106 466 141 467 218 496 171 496 216 478 278 453 293 423 296

flamecharge2
false
0
Polygon -955883 true false 331 31 314 27 283 27 239 -7 220 -45 212 -98 217 -147 248 -109 251 -146 263 -183 291 -228 307 -200 328 -244 347 -214 360 -143 375 -198 397 -164 406 -129 407 -52 436 -99 436 -54 418 8 393 23 363 26
Polygon -955883 true false 16 541 -1 537 -32 537 -76 503 -95 465 -103 412 -98 363 -67 401 -64 364 -52 327 -24 282 -8 310 13 266 32 296 45 367 60 312 82 346 91 381 92 458 121 411 121 456 103 518 78 533 48 536
Polygon -955883 true false -29 31 -46 27 -77 27 -121 -7 -140 -45 -148 -98 -143 -147 -112 -109 -109 -146 -97 -183 -69 -228 -53 -200 -32 -244 -13 -214 0 -143 15 -198 37 -164 46 -129 47 -52 76 -99 76 -54 58 8 33 23 3 26
Polygon -955883 true false 331 526 314 522 283 522 239 488 220 450 212 397 217 348 248 386 251 349 263 312 291 267 307 295 328 251 347 281 360 352 375 297 397 331 406 366 407 443 436 396 436 441 418 503 393 518 363 521

flower
false
0
Polygon -10899396 true false 135 120 165 165 180 210 180 240 150 300 165 300 195 240 195 195 165 135
Circle -7500403 true true 85 132 38
Circle -7500403 true true 130 147 38
Circle -7500403 true true 192 85 38
Circle -7500403 true true 85 40 38
Circle -7500403 true true 177 40 38
Circle -7500403 true true 177 132 38
Circle -7500403 true true 70 85 38
Circle -7500403 true true 130 25 38
Circle -7500403 true true 96 51 108
Circle -16777216 true false 113 68 74
Polygon -10899396 true false 189 233 219 188 249 173 279 188 234 218
Polygon -10899396 true false 180 255 150 210 105 210 75 240 135 240

footprint human
true
0
Polygon -7500403 true true 111 244 115 272 130 286 151 288 168 277 176 257 177 234 175 195 174 172 170 135 177 104 188 79 188 55 179 45 181 32 185 17 176 1 159 2 154 17 161 32 158 44 146 47 144 35 145 21 135 7 124 9 120 23 129 36 133 49 121 47 100 56 89 73 73 94 74 121 86 140 99 163 110 191
Polygon -7500403 true true 97 37 101 44 111 43 118 35 111 23 100 20 95 25
Polygon -7500403 true true 77 52 81 59 91 58 96 50 88 39 82 37 76 42
Polygon -7500403 true true 63 72 67 79 77 78 79 70 73 63 68 60 63 65

footprint other
true
0
Polygon -7500403 true true 75 195 90 240 135 270 165 270 195 255 225 195 225 180 195 165 177 154 167 139 150 135 132 138 124 151 105 165 76 172
Polygon -7500403 true true 250 136 225 165 210 135 210 120 227 100 241 99
Polygon -7500403 true true 75 135 90 135 105 120 105 75 90 75 60 105
Polygon -7500403 true true 120 122 155 121 161 62 148 40 136 40 118 70
Polygon -7500403 true true 176 126 200 121 206 89 198 61 186 57 166 106
Polygon -7500403 true true 93 69 103 68 102 50
Polygon -7500403 true true 146 34 136 33 137 15
Polygon -7500403 true true 198 55 188 52 189 34
Polygon -7500403 true true 238 92 228 94 229 76

gigaimpact
false
0
Polygon -7500403 true true 151 271 185 378 298 378 207 445 242 552 151 486 59 552 94 445 3 378 116 378
Polygon -7500403 true true 151 -254 185 -147 298 -147 207 -80 242 27 151 -39 59 27 94 -80 3 -147 116 -147
Polygon -7500403 true true -104 -14 -70 93 43 93 -48 160 -13 267 -104 201 -196 267 -161 160 -252 93 -139 93
Polygon -7500403 true true 406 -14 440 93 553 93 462 160 497 267 406 201 314 267 349 160 258 93 371 93

growl
true
0
Line -7500403 true -90 -30 30 60
Line -7500403 true -15 -90 30 30
Line -7500403 true 60 30 90 -120

house
false
0
Rectangle -7500403 true true 45 120 255 285
Rectangle -16777216 true false 120 210 180 285
Polygon -7500403 true true 15 120 150 15 285 120
Line -16777216 false 30 120 270 120

leaf
false
0
Polygon -7500403 true true 150 210 135 195 120 210 60 210 30 195 60 180 60 165 15 135 30 120 15 105 40 104 45 90 60 90 90 105 105 120 120 120 105 60 120 60 135 30 150 15 165 30 180 60 195 60 180 120 195 120 210 105 240 90 255 90 263 104 285 105 270 120 285 135 240 165 240 180 270 195 240 210 180 210 165 195
Polygon -7500403 true true 135 195 135 240 120 255 105 255 105 285 135 285 165 240 165 195

leaf 2
false
0
Rectangle -7500403 true true 144 218 156 298
Polygon -7500403 true true 150 263 133 276 102 276 58 242 35 176 33 139 43 114 54 123 62 87 75 53 94 30 104 39 120 9 155 31 180 68 191 56 216 85 235 125 240 173 250 165 248 205 225 247 200 271 176 275

lightning
false
0
Polygon -7500403 true true 120 135 90 195 135 195 105 300 225 165 180 165 210 105 165 105 195 0 75 135

line
true
0
Line -7500403 true 150 0 150 300

moon
true
0
Polygon -7500403 true true 293 175 264 83 192 25 114 27 50 79 29 134 26 205 61 281 67 207 84 152 115 113 168 104 223 110 249 132

orbit 1
true
0
Circle -7500403 true true 116 11 67
Circle -7500403 false true 41 41 218

orbit 2
true
0
Circle -7500403 true true 116 221 67
Circle -7500403 true true 116 11 67
Circle -7500403 false true 44 44 212

orbit 3
true
0
Circle -7500403 true true 116 11 67
Circle -7500403 true true 26 176 67
Circle -7500403 true true 206 176 67
Circle -7500403 false true 45 45 210

orbit 4
true
0
Circle -7500403 true true 116 11 67
Circle -7500403 true true 116 221 67
Circle -7500403 true true 221 116 67
Circle -7500403 false true 45 45 210
Circle -7500403 true true 11 116 67

orbit 5
true
0
Circle -7500403 true true 116 11 67
Circle -7500403 true true 13 89 67
Circle -7500403 true true 178 206 67
Circle -7500403 true true 53 204 67
Circle -7500403 true true 220 91 67
Circle -7500403 false true 45 45 210

orbit 6
true
0
Circle -7500403 true true 116 11 67
Circle -7500403 true true 26 176 67
Circle -7500403 true true 206 176 67
Circle -7500403 false true 45 45 210
Circle -7500403 true true 26 58 67
Circle -7500403 true true 206 58 67
Circle -7500403 true true 116 221 67

pentagon
false
0
Polygon -7500403 true true 150 15 15 120 60 285 240 285 285 120

person
false
0
Circle -7500403 true true 110 5 80
Polygon -7500403 true true 105 90 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285 180 195 195 90
Rectangle -7500403 true true 127 79 172 94
Polygon -7500403 true true 195 90 240 150 225 180 165 105
Polygon -7500403 true true 105 90 60 150 75 180 135 105

plant
false
0
Rectangle -7500403 true true 135 90 165 300
Polygon -7500403 true true 135 255 90 210 45 195 75 255 135 285
Polygon -7500403 true true 165 255 210 210 255 195 225 255 165 285
Polygon -7500403 true true 135 180 90 135 45 120 75 180 135 210
Polygon -7500403 true true 165 180 165 210 225 180 255 120 210 135
Polygon -7500403 true true 135 105 90 60 45 45 75 105 135 135
Polygon -7500403 true true 165 105 165 135 225 105 255 45 210 60
Polygon -7500403 true true 135 90 120 45 150 15 180 45 165 90

plant small
false
0
Rectangle -7500403 true true 135 240 165 300
Polygon -7500403 true true 135 255 90 210 45 195 75 255 135 285
Polygon -7500403 true true 165 255 210 210 255 195 225 255 165 285
Polygon -7500403 true true 135 240 120 195 150 165 180 195 165 240

pointer
false
0
Polygon -7500403 true true 135 120 135 195 150 195 150 180 165 180 165 165 180 165 180 150 165 150 165 135 150 135 150 120 135 120

poison
false
0
Circle -7500403 true true 45 -45 30
Circle -7500403 true true 210 -15 60
Circle -7500403 true true 45 15 60
Circle -7500403 true true 120 60 118
Circle -7500403 true true -30 150 120
Circle -7500403 true true 198 228 85
Circle -7500403 true true 150 0 30
Circle -7500403 true true 15 90 30
Circle -7500403 true true 120 210 30
Circle -7500403 true true 255 165 30
Circle -7500403 true true -30 -15 30

pokeball
true
0
Circle -2674135 true false 15 15 270
Polygon -1 true false 15 150 15 165 30 210 60 255 90 270 120 285 180 285 240 255 270 210 285 165 285 150
Circle -16777216 true false 120 120 60

protect
true
0
Circle -7500403 false true 65 65 170

rest
false
0
Rectangle -7500403 true true 90 60 165 75
Rectangle -7500403 true true 150 75 165 90
Rectangle -7500403 true true 135 90 150 105
Rectangle -7500403 true true 120 105 135 120
Rectangle -7500403 true true 105 120 120 135
Rectangle -7500403 true true 90 135 105 150
Rectangle -7500403 true true 90 150 165 165

rockpolish
false
0
Polygon -7500403 true true 346 -134 380 -27 493 -27 402 40 437 147 346 81 254 147 289 40 198 -27 311 -27
Polygon -7500403 true true -44 -224 -10 -117 103 -117 12 -50 47 57 -44 -9 -136 57 -101 -50 -192 -117 -79 -117
Polygon -7500403 true true -44 151 -10 258 103 258 12 325 47 432 -44 366 -136 432 -101 325 -192 258 -79 258
Polygon -7500403 true true 361 196 395 303 508 303 417 370 452 477 361 411 269 477 304 370 213 303 326 303

sheep
false
15
Circle -1 true true 203 65 88
Circle -1 true true 70 65 162
Circle -1 true true 150 105 120
Polygon -7500403 true false 218 120 240 165 255 165 278 120
Circle -7500403 true false 214 72 67
Rectangle -1 true true 164 223 179 298
Polygon -1 true true 45 285 30 285 30 240 15 195 45 210
Circle -1 true true 3 83 150
Rectangle -1 true true 65 221 80 296
Polygon -1 true true 195 285 210 285 210 240 240 210 195 210
Polygon -7500403 true false 276 85 285 105 302 99 294 83
Polygon -7500403 true false 219 85 210 105 193 99 201 83

square
false
0
Rectangle -7500403 true true 30 30 270 270

square 2
false
0
Rectangle -7500403 true true 30 30 270 270
Rectangle -16777216 true false 60 60 240 240

star
false
0
Polygon -7500403 true true 151 1 185 108 298 108 207 175 242 282 151 216 59 282 94 175 3 108 116 108

stoneedge
false
0
Polygon -7500403 true true 90 90 105 75 120 90 135 135 135 150 120 165 105 165 75 135 75 120 90 90 75 120 75 135 105 165 120 165 135 150 135 135 120 90 105 75 90 90 75 120
Polygon -7500403 true true 45 -60 30 -45 15 -15 15 0 45 30 60 30 75 15 75 0 60 -45 45 -60
Polygon -7500403 true true 180 -30 165 -15 150 15 150 30 180 60 195 60 210 45 210 30 195 -15 180 -30
Polygon -7500403 true true 300 60 285 75 270 105 270 120 300 150 315 150 330 135 330 120 315 75 300 60
Polygon -7500403 true true 75 60 60 75 45 105 45 120 75 150 90 150 105 135 105 120 90 75 75 60
Polygon -7500403 true true 210 105 195 120 180 150 180 165 210 195 225 195 240 180 240 165 225 120 210 105
Polygon -7500403 true true 195 270 180 285 165 315 165 330 195 360 210 360 225 345 225 330 210 285 195 270
Polygon -7500403 true true 15 240 0 255 -15 285 -15 300 15 330 30 330 45 315 45 300 30 255 15 240
Line -7500403 true 105 0 105 180
Line -7500403 true 255 60 255 240
Line -7500403 true 60 225 60 405
Line -7500403 true 0 75 0 255
Line -7500403 true 195 -90 195 90

suit heart
false
0
Circle -7500403 true true 135 43 122
Circle -7500403 true true 43 43 122
Polygon -7500403 true true 255 120 240 150 210 180 180 210 150 240 146 135
Line -7500403 true 150 209 151 80
Polygon -7500403 true true 45 120 60 150 90 180 120 210 150 240 154 135

target
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240
Circle -7500403 true true 60 60 180
Circle -16777216 true false 90 90 120
Circle -7500403 true true 120 120 60

tile stones
false
0
Polygon -7500403 true true 0 240 45 195 75 180 90 165 90 135 45 120 0 135
Polygon -7500403 true true 300 240 285 210 270 180 270 150 300 135 300 225
Polygon -7500403 true true 225 300 240 270 270 255 285 255 300 285 300 300
Polygon -7500403 true true 0 285 30 300 0 300
Polygon -7500403 true true 225 0 210 15 210 30 255 60 285 45 300 30 300 0
Polygon -7500403 true true 0 30 30 0 0 0
Polygon -7500403 true true 15 30 75 0 180 0 195 30 225 60 210 90 135 60 45 60
Polygon -7500403 true true 0 105 30 105 75 120 105 105 90 75 45 75 0 60
Polygon -7500403 true true 300 60 240 75 255 105 285 120 300 105
Polygon -7500403 true true 120 75 120 105 105 135 105 165 165 150 240 150 255 135 240 105 210 105 180 90 150 75
Polygon -7500403 true true 75 300 135 285 195 300
Polygon -7500403 true true 30 285 75 285 120 270 150 270 150 210 90 195 60 210 15 255
Polygon -7500403 true true 180 285 240 255 255 225 255 195 240 165 195 165 150 165 135 195 165 210 165 255

tooth
false
0
Polygon -7500403 true true 75 30 60 45 45 75 45 90 60 135 73 156 75 170 60 240 60 270 75 285 90 285 105 255 135 180 150 165 165 165 180 185 195 270 210 285 240 270 245 209 244 179 237 154 237 143 255 90 255 60 225 30 210 30 180 45 135 45 90 30
Polygon -7500403 false true 75 30 60 45 45 75 45 90 60 135 73 158 74 170 60 240 60 270 75 285 90 285 105 255 135 180 150 165 165 165 177 183 195 270 210 285 240 270 245 210 244 179 236 153 236 144 255 90 255 60 225 30 210 30 180 45 135 45 90 30 75 30

tree
false
0
Circle -7500403 true true 118 3 94
Rectangle -6459832 true false 120 195 180 300
Circle -7500403 true true 65 21 108
Circle -7500403 true true 116 41 127
Circle -7500403 true true 45 90 120
Circle -7500403 true true 104 74 152

triangle 2
false
0
Polygon -7500403 true true 150 30 15 255 285 255
Polygon -16777216 true false 151 99 225 223 75 224

truck
false
0
Rectangle -7500403 true true 4 45 195 187
Polygon -7500403 true true 296 193 296 150 259 134 244 104 208 104 207 194
Rectangle -1 true false 195 60 195 105
Polygon -16777216 true false 238 112 252 141 219 141 218 112
Circle -16777216 true false 234 174 42
Rectangle -7500403 true true 181 185 214 194
Circle -16777216 true false 144 174 42
Circle -16777216 true false 24 174 42
Circle -7500403 false true 24 174 42
Circle -7500403 false true 144 174 42
Circle -7500403 false true 234 174 42

turtle
true
0
Polygon -10899396 true false 215 204 240 233 246 254 228 266 215 252 193 210
Polygon -10899396 true false 195 90 225 75 245 75 260 89 269 108 261 124 240 105 225 105 210 105
Polygon -10899396 true false 105 90 75 75 55 75 40 89 31 108 39 124 60 105 75 105 90 105
Polygon -10899396 true false 132 85 134 64 107 51 108 17 150 2 192 18 192 52 169 65 172 87
Polygon -10899396 true false 85 204 60 233 54 254 72 266 85 252 107 210
Polygon -7500403 true true 119 75 179 75 209 101 224 135 220 225 175 261 128 261 81 224 74 135 88 99

volttackle
true
0
Polygon -1184463 true false 135 -120 105 -60 150 -60 120 45 240 -90 195 -90 225 -150 180 -150 210 -255 90 -120
Polygon -1184463 true false 165 420 195 360 150 360 180 255 60 390 105 390 75 450 120 450 90 555 210 420
Polygon -1184463 true false 420 135 360 105 360 150 255 120 390 240 390 195 450 225 450 180 555 210 420 90
Polygon -1184463 true false -120 105 -60 135 -60 90 45 120 -90 0 -90 45 -150 15 -150 60 -255 30 -120 150

wheel
false
0
Circle -7500403 true true 3 3 294
Circle -16777216 true false 30 30 240
Line -7500403 true 150 285 150 15
Line -7500403 true 15 150 285 150
Circle -7500403 true true 120 120 60
Line -7500403 true 216 40 79 269
Line -7500403 true 40 84 269 221
Line -7500403 true 40 216 269 79
Line -7500403 true 84 40 221 269

wolf
false
0
Polygon -16777216 true false 253 133 245 131 245 133
Polygon -7500403 true true 2 194 13 197 30 191 38 193 38 205 20 226 20 257 27 265 38 266 40 260 31 253 31 230 60 206 68 198 75 209 66 228 65 243 82 261 84 268 100 267 103 261 77 239 79 231 100 207 98 196 119 201 143 202 160 195 166 210 172 213 173 238 167 251 160 248 154 265 169 264 178 247 186 240 198 260 200 271 217 271 219 262 207 258 195 230 192 198 210 184 227 164 242 144 259 145 284 151 277 141 293 140 299 134 297 127 273 119 270 105
Polygon -7500403 true true -1 195 14 180 36 166 40 153 53 140 82 131 134 133 159 126 188 115 227 108 236 102 238 98 268 86 269 92 281 87 269 103 269 113

x
false
0
Polygon -7500403 true true 270 75 225 30 30 225 75 270
Polygon -7500403 true true 30 75 75 30 270 225 225 270

@#$#@#$#@
NetLogo 5.2.1
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
default
0.0
-0.2 0 0.0 1.0
0.0 1 1.0 0.0
0.2 0 0.0 1.0
link direction
true
0
Line -7500403 true 150 150 90 180
Line -7500403 true 150 150 210 180

@#$#@#$#@
0
@#$#@#$#@
