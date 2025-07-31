#!/bin/bash

NOTES_FILE=~/project2/simple_notes.txt
touch "$NOTES_FILE"

add_notes() {
    echo "---- Add a New Note ----"
    read -p "Enter Title: " title
    read -p "Enter Note: " note
    id=$(date +%s%N)
    timestamp=$(date +"%Y-%m-%d %H:%M:%S")
    echo "$id|$timestamp|$title|$note" >> "$NOTES_FILE"
    echo "Note added!"
}

view_notes() {
	echo "---- All Notes ----"
        while IFS="|" read -r id timestamp title note; do
		echo "ID: $id"
                echo "Time: $timestamp"
                echo "Title: $title"
                echo "Note: $note"
                echo "------------------------"
                done < "$NOTES_FILE"                                                  
}                              

delete_note() {
	echo "---- Delete a Note ----"
    if [[ ! -s "$NOTES_FILE" ]]; then
        echo "No notes found to delete."
        return
    fi

    # Display all notes with index
    i=1
    declare -A id_map
    while IFS="|" read -r id timestamp title note; do
        echo "$i. Title: $title | Time: $timestamp"
        id_map[$i]=$id
        ((i++))
    done < "$NOTES_FILE"

    read -p "Enter the number of the note to delete: " num

    if [[ -n "${id_map[$num]}" ]]; then
        id_to_delete="${id_map[$num]}"
        grep -v "^$id_to_delete|" "$NOTES_FILE" > temp.txt && mv temp.txt "$NOTES_FILE"
        echo "Note deleted!"
    else
        echo "Invalid selection."
    fi
}

search_notes() {
	echo "---- Search Notes ----"
        read -p "Enter keyword: " keyword
        grep -i "$keyword" "$NOTES_FILE" | while IFS="|" read -r id timestamp title note; do
	   echo "ID: $id"
           echo "Time: $timestamp"
           echo "Title: $title"
           echo "Note: $note"
        done
}
while true; do
	echo ""
        echo "=== Simple Notes CLI ==="
        echo "1. Add a Note"
        echo "2. View All Notes"
        echo "3. Search Notes"
        echo "4. Delete a Note"
        echo "5. Exit"
        read -p "Choose [1-5]: " choice 
	case "$choice" in
		1) add_notes ;;
		2) view_notes ;;
		3) search_notes ;;
		4) delete_note ;;
		5) echo "GOODBYE"; exit ;;
		*) echo "INVALID OPTION" ;;
	esac
done

