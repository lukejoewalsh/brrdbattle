#!/bin/bash




#peck: only 5 dmg but chance for huge crit
#snowball: often misses but can freeze opponet
#ducktape: one use but full heals the duck
#slap: +1 per win

#echo $'\e[5m' 'Hello World'
#^ that makes it blink

#need larger game loop!!!
#need to generalize turns to all birds (make functions for each bird and each attack is probably the best way)
#make 3rd attack for Penguin
#Make attacks for petrol
#Make tutorial
#duck with peck, quakattack (idk), splash, ducktape (1 use heal)
#make fishing minigame and/or levels system
#~~~~~ \_/

printf '\033[8;30;57t'
#set screen size to 30x70

declare -i EHP=50
declare -i EHPMAX=50
declare -i HP=50
declare -i HPMAX=50
declare -i XP=0
declare -i LVL=1
declare -i WINS=0
declare -i WINSTRK=0
declare -i DUCKTAPE=0
declare -i RUN=0
declare WATERCOLOR=$'\e[48;5;27m'
declare STARTTIME=$(date +%s)

declare -i GAME=1

declare ENEMY=("Silly Goose" "solid" "stable" "3")
#Silly goose - misses most of the time, level 1 opponet
#Suspicious goose  - misses less, level 2
#Malicious goose - new attack?
#Definitely a duck / grey duck - spy goose rare but random
declare PLAYER=("Duck" "solid")
declare LVLS=(0 10 20 30 50 100 150 200 250 500)
declare FISH=("goldfish" "mino" "sunny" "bass" "cod" "carp" "tuna" "catfish" "crab" "rainbow trout" "blobfish")
declare DUCKDMG=(0 5 10 10)
declare PIRATE=0

declare NOTE=("Peck does low damage but has a chance for a critical hit", "Quack Attack does more damage with each win")
declare NOTET=(0, 0)

drawBrrds (){
  clear
  if [ "$EHP" -gt "0" ]; then
    tput cup 0 $((57 - ${#ENEMY}))
    echo $'\e[1;31m'$ENEMY
    LINETWO="$EHP / $EHPMAX"
    tput cup 1 $((57 - ${#LINETWO}))
    echo $EHP / $EHPMAX
    echo

    printf $WATERCOLOR
    echo "                                                         "

    drawEGoose
  else
    tput cup 0 $((57 - ${#ENEMY}))
    echo $'\e[1;31m'$ENEMY
    LINETWO="0 / $EHPMAX"
    tput cup 1 $((57 - ${#LINETWO}))
    echo 0 / $EHPMAX
    echo

    printf $WATERCOLOR
    echo "                                                         "

    drawEmpty
  fi

  echo "                                                         "

  if [ "$RUN" == "0" ]; then
    drawDuck
  elif [ "$RUN" == "1" ]; then
    drawDFleei
  elif [ "$RUN" == "2" ]; then
    drawDFleeii
  fi

  echo "                                                         "
  echo $'\e[0m'

  echo $'\e[1;32m'$PLAYER
  echo $HP / $HPMAX
  tput cup 20 $((${#PLAYER} + 1))
  echo $'\e[21;90m'"lvl.$LVL"
  tput cup 22 0
  echo $'\e[0m'
}
drawAdelie (){
  echo "     _____       "
  echo "    |   o |-_    "
  echo "    |  __ |_-'   "
  echo "   /  /   \      "
  echo "  | \|     |\    "
  echo "  |  \     |_\   "
  echo "  |__|_____|     "
}
drawEAdelie (){
  echo "                                               _____     "
  echo "                                            _-| o   |    "
  echo "                                           '-_| __  |    "
  echo "                                              /   \  \   "
  echo "                                            /|     |/ |  "
  echo "                                           /_|     /  |  "
  echo "                                             |_____|__|  "
}
drawEPetrol (){
  echo "                                           ____          "
  echo "                                       __-- .  -_        "
  echo "                                      /__        ----_   "
  echo "                                          |   ____     \ "
  echo "                                          |  (_____\   | "
  echo "                                           \___________/ "
}
drawEmpty (){
  echo "                                                         "
  echo "                                                         "
  echo "                                                         "
  echo "                                                         "
  echo "                                                         "
  echo "                                                         "
}
drawDFleei (){
  echo "                                                         "
  echo "                                                         "
  echo "                                                         "
  echo "                                                         "
  echo "                                                         "
  echo "                                                         "
  echo "                                                         "
  printf $'\e[48;5;189m'
  tput cup 12 7
  echo "     "
  tput cup 13 5
  echo "         "
  tput cup 14 5
  echo "         "
  tput cup 15 7
  echo "     "
  tput cup 18 0
  printf $'\e[0m'
  printf $WATERCOLOR
}
drawDFleeii (){
  echo "                                                         "
  echo "                                                         "
  echo "                                                         "
  echo "                                                         "
  echo "                                                         "
  echo "                                                         "
  echo "                                                         "

}
drawEGoose (){
  if [ "${ENEMY[1]}" == "blink" ]; then
    printf $'\e[5m'
    ENEMY[1]="solid"
  fi
  printf  $'\e[1;97m' '\e[K'
  echo "                                          ,,-'-,         "
  echo "                                     ,--''      '-_      "
  echo "                                  ,'( O    ,-'-,   ''----"
  echo "                                   ''\,,-''     |  ,-''''"
  echo "                                                \  \___--"
  echo "                                                 '~~~~~~~"
  printf $'\e[25m' #turn off blinking
}
drawDuck (){
  if [ "${PLAYER[1]}" == "blink" ]; then
    printf $'\e[5m'
    PLAYER[1]="solid"
  fi
  printf $'\e[1;33m' '\e[K'
  echo "         .----,                                          "
  echo "       ,'    O /'-_                                      "
  echo "       ',     (---'                                      "
  echo "    ,..'      '_                                         "
  echo "   /  _______   \                                        "
  echo "  |   \______)   |                                       "
  echo "  '~~~~~~~~~~~~~~'                                       "
  if [ "$PIRATE" == "1" ]; then
    drawPirate
  fi
  printf $'\e[25m' #turn off blinking

}

drawFishi (){

  printf $'\e[1;33m'
  printf $'\e[48;5;75m'
  echo "                                                         "
  echo "             <3    <3                                    "
  echo "      ,--,___|_____|____                                 "
  echo "       ',               \                                "

  printf $WATERCOLOR
  echo "         |              |                                "
  echo "          \           _/                                 "
  echo "           ''',      ,                                   "
  echo "              ,'     (---_                               "
  echo "              ',    O \,-'                               "
  echo "                '----'                                   "
  echo "                                                         "
  echo "                                                         "
  echo "                                                         "
  echo "                                                         "
  echo "                                                         "
  echo "                                                         "
  echo "                                                         "
  echo "                                                         "
  echo "                                                         "

  #tput cup 4 0
  #echo "~~~~~~~~~"
  #tput cup 4 10
  #echo "~~~~~~~~~~~~~~"
  #tput cup 4 25
  #echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
  #tput cup 20 0

  #sun
  #printf $'\e[48;5;226m'
  #tput cup 0 53
  #echo "    "
  #tput cup 1 53
  #echo "    "


  printf $'\e[48;5;189m'
  tput cup 1 32
  echo "      "
  tput cup 2 30
  echo "          "
  tput cup 0 0
  echo "  "
  tput cup 20 0
  echo $'\e[0m'
}
drawFishii (){

  printf $'\e[1;33m'
  printf $'\e[48;5;75m'
  echo "                                                         "
  echo "             <3    <3                                    "
  echo "      ,--,___|_____|____                                 "
  echo "       ',               \                                "

  printf $WATERCOLOR
  echo "         |              |                                "
  echo "          \           _/                                 "
  echo "           ''',      ,                                   "
  echo "              ,'     (---_                               "
  echo "              ',    O \,-'                               "
  echo "                '----'                                   "
  echo "                                                         "
  echo "                                                         "
  echo "                                                         "
  echo "                                                         "
  echo "                                                         "
  echo "                                                         "
  echo "                                                         "
  echo "                                                         "
  echo "                                                         "

  printf $'\e[48;5;189m'
  tput cup 1 33
  echo "      "
  tput cup 2 31
  echo "          "
  tput cup 0 0
  echo "   "
  tput cup 20 0
  echo $'\e[0m'
}
drawFishiii (){

  printf $'\e[1;33m'
  printf $'\e[48;5;75m'
  echo "                                                         "
  echo "             <3    <3                                    "
  echo "      ,--,___|_____|____                                 "
  echo "       ',               \                                "

  printf $WATERCOLOR
  echo "         |              |                                "
  echo "          \           _/                                 "
  echo "           ''',      ,                                   "
  echo "              ,'     (---_                               "
  echo "              ',    O \,-'                               "
  echo "                '----'                                   "
  echo "                                                         "
  echo "                                                         "
  echo "                                                         "
  echo "                                                         "
  echo "                                                         "
  echo "                                                         "
  echo "                                                         "
  echo "                                                         "
  echo "                                                         "

  printf $'\e[48;5;189m'
  tput cup 1 34
  echo "      "
  tput cup 2 32
  echo "          "
  tput cup 0 0
  echo "    "
  tput cup 20 0
  echo $'\e[0m'
}

battleLoop(){
  while [ "$EHP" -gt "0" ]
  do
    if [ "$HP" -gt "0" ]; then
      drawBrrds
      playerTurn
    else
      ((GAME-=1))
      drawBrrds
      echo "$PLAYER Fainted :/"
      wait
      break 2
    fi
    if [ "$EHP" -gt "0" ]; then
      drawBrrds
      enemyTurn
    else
      ((WINS+=1))
      ((WINSTRK+=1))
      ((DUCKDMG[2]+=1))
      drawBrrds
      echo "$ENEMY Fainted! You won the battle!"
      ACTION=0
      wait
      ((XP+=10))
      if [ "$XP" -ge "${LVLS[$LVL]}" ]; then
        levelUp
      fi
    fi
  done
}
fishLoop(){
  clear
  drawFishi
  sleep 1
  clear
  drawFishii
  sleep 1
  clear
  drawFishiii

  ROLL=$((1 + $RANDOM % 6))
  if [ "$ROLL" -lt "5" ]; then
    HEAL=$(($ROLL + $LVL - 1))
    ((HEAL*=5))
    ((HP+=$HEAL))
    echo $PLAYER caught a ${FISH[$(($ROLL + $LVL - 1))]} and gained $HEAL health!
    if [ "$HP" -gt "$HPMAX" ]; then
      HP=$HPMAX
    fi
    wait
  else
    FLIP=$((1 + $RANDOM % 2))
    if [ "$LVL" -ge "3" ]; then
      ((FLIP+=1))
      if [ "$LVL" -ge "5" ]; then
      ((FLIP+=1))
      fi
    fi
    if [ "$FLIP" == "1" ]; then
      echo "$PLAYER caught a boot!"
      echo "Better luck next time."
    elif [ "$FLIP" == "2" ]; then
      HP=$HPMAX
      echo "$PLAYER caught a goldfish!"
      echo "Yum!"
    elif [ "$FLIP" == "3" ]; then
      echo "$PLAYER found a message in a bottle!"
      echo "I wonder what it says..."
      wait
      message
    elif [ "$FLIP" == "4" ]; then
      ((DUCKTAPE+=1))
      echo "$PLAYER found duck tape!"
      echo "Duck tape fixes everything!"
    fi

    wait
    #goldfish, boot, ducktape, snapping turtle, message in a bottle/cheat codes
  fi
}
wait(){
  tput cup 28 16
  #printf $'\e[5m'
  read -p "PRESS "$'\e[1m'"[ENTER]"$'\e[0m'" TO CONTINUE"
  #printf $'\e[0m'
}

drawPirate(){
  printf $'\e[1;30m'
  tput cup 10 0
  #echo "     |-----------| "
  tput cup 11 0
  #echo "      \_________/ "
  tput cup 12 8
  echo "'---- '"
  tput cup 12 13
  echo $'\e[48;5;232m'" "
  tput cup 18 0
  printf $'\e[0m' $WATERCOLOR
}

message (){
  clear

  printf $'\e[48;5;180m'
  printf $'\e[38;5;94m'
  tput cup 3 0
  echo "                                                         "
  echo "~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~"
  echo "                                                         "
  echo "                                                         "
  echo "                                                         "
  echo "                                                         "
  echo "~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~"
  echo "                                                         "

  PICK=$((1 + $RANDOM % 4))
  if [ "$PICK" == 1 ]; then
    messagei
  elif [ "$PICK" == 2 ]; then
    messageii
  elif [ "$PICK" == 3 ]; then
    messageiii
  elif [ "$PICK" == 4 ]; then
    messageiiii
  fi


  printf $'\e[0m'
}
messagei(){
  tput cup 6 22
  echo "SECRET CODE:"
  tput cup 7 24
  echo "pirate"
}
messageii(){
  tput cup 6 22
  echo "SECRET CODE:"
  tput cup 7 28
  echo "yp"
}
messageiii(){
  tput cup 6 10
  echo "What do you call a duck that steals?"
  printf $'\e[0m'
  wait
  printf $'\e[48;5;180m'
  printf $'\e[38;5;94m'
  tput cup 7 21
  echo "A Robber Ducky"
}
messageiiii(){
  tput cup 6 10
  echo "What did the duck say to the waiter?"
  printf $'\e[0m'
  wait
  printf $'\e[48;5;180m'
  printf $'\e[38;5;94m'
  tput cup 7 20
  echo "Put it on my bill"
}


arcticLoop(){
  while [ "$EHP" -gt "0" ]
  do
    drawArctic
  done
}
drawArctic(){
  clear
  tput cup 0 $((57 - ${#ENEMY}))
  echo $'\e[1;31m'$ENEMY
  LINETWO="$EHP / $EHPMAX"
  tput cup 1 $((57 - ${#LINETWO}))
  echo $EHP / $EHPMAX
  echo

  echo "                                                         "
  drawEPetrol
  echo "                                                         "
  drawAdelie
  echo "                                                         "

  echo
  echo $'\e[1;32m'"Adelie Penguin"
  echo $HP / $HPMAX
  echo
}

playerTurn(){

    echo 1. Peck
    echo 2. Quack Attack
    RUNOPT=3
    if [ "$LVL" -ge "3" ]; then
      echo 3. Splash
      ((RUNOPT+=1))
    fi
    if [ "$LVL" -ge "5" ]; then
      echo 4. Duck Tape [$DUCKTAPE]
      ((RUNOPT+=1))
    fi
    echo $RUNOPT". Run"
    echo
    read ACTION

    if [ "$ACTION" == "1" ]; then
      ROLL=$((1 + $RANDOM % 6))
      if [ "$ROLL" == "1" ]; then
        drawBrrds
        echo "$PLAYER's attack missed!"
      elif [ "$ROLL" == "2" ]; then
        ((EHP-=35))
        ENEMY[1]="blink"
        drawBrrds
        echo "Critical hit! $PLAYER pecked $ENEMY for 35 damage!"
      else
        ((EHP-=${DUCKDMG[$ACTION]}))
        ENEMY[1]="blink"
        drawBrrds
        echo $PLAYER pecked $ENEMY for ${DUCKDMG[$ACTION]} damage!
      fi
    elif [ "$ACTION" == "2" ]; then
      ROLL=$((1 + $RANDOM % 6))
      if [ "$ROLL" == "1" ]; then
        drawBrrds
        echo "$PLAYER's attack missed!"
      else
        ((EHP-=${DUCKDMG[$ACTION]}))
        ENEMY[1]="blink"
        drawBrrds
        echo Quack! Quack!
        echo $PLAYER attacked $ENEMY for ${DUCKDMG[$ACTION]} damage!
      fi
    elif [[ "$ACTION" == "3" && "$LVL" -ge "3" ]]; then
      ROLL=$((1 + $RANDOM % 6))
      if [ "$ROLL" -le "2" ]; then
        drawBrrds
        echo "$PLAYER's attack missed!"
      else
        ((EHP-=${DUCKDMG[$ACTION]}))
        ENEMY[1]="blink"
        ENEMY[2]="disoriented"
        drawBrrds
        echo Splash! $PLAYER splashed $ENEMY for ${DUCKDMG[$ACTION]} damage!
        echo $ENEMY is disoriented.
      fi
    elif [[ "$ACTION" == "4" && "$LVL" -ge "5" && "$DUCKTAPE" -gt "0" ]]; then
      HP=$HPMAX
      ((DUCKTAPE-=1))
      drawBrrds
      echo $PLAYER used Duck Tape to heal.
    elif [ "$ACTION" == "$RUNOPT" ]; then
      ((DUCKDMG[2]-=WINSTRK))
      WINSTRK=0

      drawBrrds
      echo "$PLAYER fled the battle"
      sleep .5
      RUN=1
      drawBrrds
      echo "$PLAYER fled the battle"
      sleep .5
      RUN=2
      drawBrrds
      echo "$PLAYER fled the battle"
      wait
      break
    fi
    wait
  }
enemyTurn (){
    ROLL=$((1 + $RANDOM % 6))
    if [ "$ROLL" -le "${ENEMY[3]}" ]; then
      echo $ENEMY missed its attack!
    else
      if [ "${ENEMY[2]}" == "disoriented" ]; then
        echo $ENEMY missed its attack!
      else
        if [[ "${ENEMY[0]}" == "Malicious Goose" && "$ROLL" == "2" ]]; then
          ((HP-=30))
          PLAYER[1]="blink"
          drawBrrds
          echo $ENEMY stabbed $PLAYER with a knife for 30 damage!
        else
          ((HP-=10))
          PLAYER[1]="blink"
          drawBrrds
          echo $ENEMY pecked for 10 damage!
        fi
      fi
    fi
    wait

    ENEMY[2]="stable"
}

levelUp (){
  clear
  ((LVL+=1))
  ((EHPMAX+=5))
  echo "$PLAYER leveled up and is now level $LVL!"
  echo
  echo "What would you like to upgrade?"
  echo
  echo "1. Max Health (+5)"
  echo "2. Peck (+1)"
  echo "3. Quack Attack (+1)"
  if [ "$LVL" -ge "3" ]; then
    echo "4. Splash (+1)"
  fi
  echo
  read ACTION

  if [ "$ACTION" == "1" ]; then
    ((HPMAX+=5))
  elif [ "$ACTION" == "2" ]; then
    ((DUCKDMG[1]+=1))
  elif [ "$ACTION" == "3" ]; then
    ((DUCKDMG[2]+=1))
  elif [[ "$ACTION" == "4" && "$LVL" -ge "3" ]]; then
    ((DUCKDMG[3]+=1))
  fi

  if [ "$LVL" == "3" ]; then
    ENEMY[0]="Suspicious Goose"
    ENEMY[3]="1"
  fi

  if [[ "$LVL" == "5" ]]; then
    ENEMY[0]="Malicious Goose"
    ((DUCKTAPE+=1))
    clear
    echo $PLAYER unlocked Duck Tape!
    echo Remember Duck Tape is a one-use item.

    ACTION=0
    wait
  fi
}

startScreen (){
  echo "                                                         "
  echo "                                                         "
  echo "          ######    ######    ######    ######           "
  echo "          ##   ##   ##   ##   ##   ##   ##   ##          "
  echo "          ##   ##   ##   ##   ##   ##   ##   ##          "
  echo "          ######    #####     #####     ##   ##          "
  echo "          ##   ##   ##   ##   ##   ##   ##   ##          "
  echo "          ##   ##   ##   ##   ##   ##   ##   ##          "
  echo "          ######    ##   ##   ##   ##   ######           "
  echo "                                                         "
  echo "                                                         "
  echo "                       B A T T L E                       "
  echo "                                                         "
  tput cup 13 0
  echo "                           ___                           "
  echo "                          /   \                          "
  echo "                         |     |                         "
  echo "                         |     |                         "
  echo "                          \___/                          "

  wait

  clear
  tput cup 13 0
  echo "                           ___                           "
  echo "                          /   \                          "
  echo "                         |     |                         "
  echo "                         |     |                         "
  echo "                          \___/                          "

  sleep 1
  tput cup 13 0
  echo "                           ___                           "
  echo "                *crack*   /\  \                          "
  echo "                         |     |                         "
  echo "                         |     |                         "
  echo "                          \___/                          "

  sleep 1
  tput cup 13 0
  echo "                           ___                           "
  echo "                          /\  \                          "
  echo "               *crack*   | 7\  |                         "
  echo "                         |     |                         "
  echo "                          \___/                          "

  sleep 1
  clear
  tput cup 12 0
  echo "                           ___                           "
  echo "                          /\  \                          "
  printf $'\e[1;33m'
  echo "                          |o o|                          "
  printf $'\e[0m'
  echo "                         | 7\  |                         "
  echo "              quack!     |     |                         "
  echo "                          \___/                          "

  sleep 1
  tput cup 0 0
  echo Welcome to brrd battle!
  echo Please name your duck.
  read -p 'Name: ' NAME
  PLAYER=$NAME
}
#start
clear
startScreen
open ./assets/instructions.rtf      #MacOS
xdg-open ./assets/instructions.rtf  #Linux
start ./assets/instructions.rtf     #Windows
battleLoop

while [ "$GAME" -eq "1" ]
do

  clear
  if [ "$HP" -lt "$HPMAX" ]; then
    echo "$PLAYER is injured from battle and only has $HP / $HPMAX health."
    echo "Catching fish is a great way to replenish health."
  else
    echo $PLAYER has $HP / $HPMAX health and is ready for battle!
  fi
  echo
  echo 1. Fight next foe
  echo 2. Go fish
  echo
  read ACTION

  if [ "$ACTION" == "1" ]; then
    EHP=$EHPMAX
    ENEMY[1]="solid"
    RUN=0
    battleLoop
  elif [ "$ACTION" == "2" ]; then
    fishLoop
  elif [ "$ACTION" == "yp" ]; then
    WATERCOLOR=$'\e[48;5;93m'
  elif [ "$ACTION" == "pirate" ]; then
    PLAYER="Captain $PLAYER"
    PIRATE=1
  elif [ "$ACTION" == "up" ]; then
    levelUp
    XP=${LVLS[$LVL - 1]}
  fi
done
ENDTIME=$(date +%s)
TIMEELAPSED=$(($ENDTIME-$STARTTIME))
clear
echo
echo GAME OVER
echo
echo Wins:
tput cup 3 20
echo $WINS
echo Level:
tput cup 4 20
echo $LVL
echo Time:
tput cup 5 20
echo $TIMEELAPSED Seconds
echo
