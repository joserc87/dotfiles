#!/usr/bin/env bash

todo=$HOME/Scripts/todo
edtodo=$HOME/Scripts/edtodo
todo_iter_file=$HOME/Scripts/i3blocks/todo_iter.txt
todo_selected=$(cat $todo_iter_file || echo 1)
num_todos=$($todo | wc -l)

if [ $todo_selected -lt 1 ]; then
    todo_selected=1
elif [ $todo_selected -gt $num_todos ]; then
    todo_selected=$num_todos
fi

if [[ "$BLOCK_BUTTON" ]] ; then
    if [[ "$BLOCK_BUTTON" == 1 ]] ; then
        $HOME/Scripts/showtodo
    elif [[ "$BLOCK_BUTTON" == 3 ]] ; then
        EDITOR=editi3 $edtodo
    elif [[ "$BLOCK_BUTTON" == 4 ]] ; then # Mouse wheel up
        ((todo_selected-=1))
        echo $todo_selected > $todo_iter_file
    elif [[ "$BLOCK_BUTTON" == 5 ]] ; then # Mouse wheel up
        ((todo_selected+=1))
        echo $todo_selected > $todo_iter_file
    else
        notify-send "Error" "Unrecognized button $BLOCK_BUTTON"
    fi
fi

if [ $todo_selected -lt 1 ]; then
    todo_selected=1
elif [ $todo_selected -gt $num_todos ]; then
    todo_selected=$num_todos
fi


# Show the first ToDo
$HOME/Scripts/todo \
    | sed -n "${todo_selected}p" \
    | sed 's/^.*- \[ \] //g'

# echo "<span color=\"#88CCFF\"><sub> $first_todo</sub></span>"
