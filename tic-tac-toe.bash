#!/bin/bash
# Tic Tac Toe by Michał Biernat

n=3
pvp=true
first_turn=1
player=$first_turn
board=()

function fill_board 
{
    for ((i = 0 ; i < $n*$n ; i++)); do
        board+=(0)
    done
}

function start_dialog
{
    echo "Tic Tac Toe v1.0"
    
    echo ''
    echo "What do you want to do? (type 1 or 2)"
    echo "  1) Start new game"
    echo "  2) Load saved game"
    
    get_input=true
    while $get_input
    do
        echo ''
        echo -n "> "
        read input
        
        if [ $input -ge 1 ] && [ $input -le 2 ] ; then
            if [ $input -eq 1 ] ; then
                new_game=true
            else
                new_game=false
            fi
            get_input=false
        else
            echo "Input is incorrect! Try again."
        fi
    done
    
    if [ $new_game == true ] ; then 
        echo ''
        echo "Select difficulty:"
        echo "  1) Easy (3x3)"
        echo "  2) Medium (5x5)"
        echo "  3) Hard (7x7)"
        
        get_input=true
        while $get_input
        do
            echo ''
            echo -n "> "
            read input
            
            if [ $input -ge 1 ] && [ $input -le 3 ] ; then
                if [ $input -eq 1 ] ; then
                    n=3
                elif [ $input -eq 2 ] ; then
                    n=5
                else
                    n=7
                fi
                get_input=false
            else
                echo "Input is incorrect! Try again."
            fi
        done
        
        fill_board

        echo ''
        echo "Select game type:"
        echo "  1) Player vs Player"
        echo "  2) Player vs Computer"
        
        get_input=true
        while $get_input
        do
            echo ''
            echo -n "> "
            read input
            
            if [ $input -ge 1 ] && [ $input -le 2 ] ; then
                if [ $input -eq 1 ] ; then
                    pvp=true
                else
                    pvp=false
                fi
                get_input=false
            else
                echo "Input is incorrect! Try again."
            fi
        done
        
        echo ''
        echo "Who moves first?"
        echo "  1) [O]"
        echo "  2) [X]"
        
        get_input=true
        while $get_input
        do
            echo ''
            echo -n "> "
            read input
            
            if [ $input -ge 1 ] && [ $input -le 2 ] ; then
                first_turn=$input
                player=$first_turn
                get_input=false
            else
                echo "Input is incorrect! Try again."
            fi
        done
    else
        echo ''
        echo "Enter save file name:"
        get_input=true
        while $get_input
        do
            echo ''
            echo -n "> "
            read file_name
            
            if [ -f $file_name ] ; then
                load_game
                get_input=false
            else
                echo "File doesn't exist! Try again."
            fi
        done
    fi

    input_limit=$((( $n - 1 ) * 10 + $n - 1))
}

function load_game
{
    file=()
    while read line
    do    
        file+=($line)    
    done < $file_name

    n=${file[0]}
    pvp=${file[1]}
    first_turn=${file[2]}
    player=${file[3]}
    for ((i = 0 ; i < $n*$n ; i++)); do
        board+=(${file[i+4]})
    done
    
    unset file
}

start_dialog

function draw_board
{
    echo -n "#"
    for ((i = 0 ; i < n ; i++)); do
        echo -n "   $i"
    done
    echo ''
    
    echo -n "  +"
    for ((i = 0 ; i < n ; i++)); do
        echo -n " - +"
    done
    echo ''
    
    for ((i = 0 ; i < n ; i++)); do
        for ((j = 0 ; j < n ; j++)); do
            ind=$j*$n+$i
            if [ $j -eq 0 ] ; then
                echo -n $i
            fi
            echo -n " | "
            draw_symbol ${board[$ind]}
        done
        echo -n " |"
        echo ''
        echo -n "  +"
        for ((j = 0 ; j < n ; j++)); do
            echo -n " - +"
        done
        echo ''
    done
}

function draw_symbol
{
    if [ $1 -eq 1 ] ; then
        echo -n "O"
    elif [ $1 -eq 2 ] ; then
        echo -n "X"
    else
        echo -n " "
    fi
}

function save_game
{
    echo $n > $file_name
    echo $pvp >> $file_name
    echo $first_turn >> $file_name
    echo $player >> $file_name
    echo ${board[@]} >> $file_name
}

function decode_input
{
    if [ $input == "exit" ] ; then
        echo ''
        echo "Would you like to save current game? (y/n)"
        echo ''
        echo -n "> "
        read input
        if [ $input == 'y' ] ; then
            echo ''
            echo "Enter name for save file:"
            echo ''
            echo -n "> "
            read file_name
            save_game
        fi
        exit 0
    elif [ $input == "reset" ] ; then
        get_input=false
        game_in_progress=false
        reset=true
    elif [ ${#input} -eq 2 ] ; then
        if [ $input -ge 0 ] && [ $input -le $input_limit ] ; then
            i=${input:0:1}
            j=${input:1:1}
            input=$(($j * n + $i))
            if [ ${board[$input]} -eq 0 ] ; then
                board[$input]=$player
                get_input=false
            else
                echo "You must select an empty field."
            fi
        else
            echo "Input number must fit into the board [00; $input_limit]."
        fi
    else
        echo "Input must be a number (xy) or a phrase (reset or exit)."
    fi
}

function get_correct_input 
{
    get_input=true
    
    echo ''
    echo -n "Player ["
    draw_symbol $player
    echo "]'s turn"
    
    while $get_input
    do  
        echo ''
        echo -n "> "
        read input
        decode_input
    done    
}

function switch_players
{
    if [ $player -eq 1 ] ; then
        player=2
    else
        player=1
    fi
}

function check_game_progress
{
    for ((i = 0 ; i < $n ; i++)); do
        counter=0
        for ((j = 0 ; j < $n ; j++)); do
            ind=$(($j * $n + $i))
            if [ ${board[$ind]} -eq $player ] ; then
                ((counter++))
            fi
        done
        if [ $counter -eq $n ] ; then
            game_in_progress=false
            return 0
        fi
    done
    
    for ((i = 0 ; i < $n ; i++)); do
        counter=0
        for ((j = 0 ; j < $n ; j++)); do
            ind=$(($i * $n + $j))
            if [ ${board[$ind]} -eq $player ] ; then
                ((counter++))
            fi
        done
        if [ $counter -eq $n ] ; then
            game_in_progress=false
            return 0
        fi
    done
    
    counter=0
    for ((i = 0 ; i < $n ; i++)); do
        ind=$(($i * $n + $i))
        if [ ${board[$ind]} -eq $player ] ; then
            ((counter++))
        fi
    done
    if [ $counter -eq $n ] ; then
        game_in_progress=false
        return 0
    fi
    
    counter=0
    for ((i = 0 ; i < $n ; i++)); do
        ind=$(( ( $i + 1 ) * ( $n - 1 ) ))
        if [ ${board[$ind]} -eq $player ] ; then
            ((counter++))
        fi
    done
    if [ $counter -eq $n ] ; then
        game_in_progress=false
        return 0
    fi
}

function get_computer_input
{
    echo ''
    echo -n "Player ["
    draw_symbol $player
    echo "]'s turn"
    
    echo ''
    echo "Computer is thinking..."
    
    get_input=true
    while $get_input
    do
        ind=$(( 0 + $RANDOM % ( $n * $n - 1 ) ))
        if [ ${board[$ind]} -eq 0 ] ; then
            board[$ind]=$player
            get_input=false
        fi
    done
    
    delay=$((1 + $RANDOM % 2))
    sleep $delay
}

function game_loop
{
    game_in_progress=true
    while $game_in_progress
    do
        clear
        draw_board
        if [ $pvp == false ] && [ $player -eq 2 ] ; then
            get_computer_input
        else
            get_correct_input
        fi
        check_game_progress
        if [ $game_in_progress == true ] ; then
            switch_players
        else
            clear
            draw_board
        fi
    done
    
    echo ''
    echo -n "Player ["
    draw_symbol $player
    echo "] wins!"
    echo ''
}

function try_again
{
    if [ $reset == true ] ; then
        clear
    fi
    
    echo "Do you want to try again? (y/n)"
    echo -n "> "
    read input
    if [ $input == 'y' ] ; then
        unset board
        fill_board
        player=$first_turn
    else
        exit 0
    fi
}

while true
do
    reset=false
    game_loop
    try_again
done

