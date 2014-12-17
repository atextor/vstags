#!/bin/bash
# vstags.sh - To use, add the following to your ~/.bashrc: source /path/to/vstags.sh
# More information at https://github.com/atextor/vstags

TAGDIR=~/tags

# tag_add <file> <tag>
# Adds a tag for the file
function tag_add() { ln -s "`readlink -f \"$1\"`" "$TAGDIR"/"`uuidgen`;tag:$2"; }

# tag_remove <file> <tag>
# Removes a tag for the file
function tag_remove() { find -L "$TAGDIR" -samefile "$1" -name "*tag:$2" -exec rm -f "{}" \;; }

# tag_remove_from_any <tag>
# Removes all occurrences of tag from any file
function tag_remove_from_any() { rm -f "$TAGDIR"/*tag:$1*; }

# tag_show_for_file <file>
# Shows all tags for file
function tag_show_tags_for_file() { find -L "$TAGDIR" -samefile "$1" | cut -d\; -f2; }

# tag_find_files_by_tag <tag>
# Lists all files with the tag
function tag_find_files_by_tag() { find "$TAGDIR" -name "*tag:$1*" -exec readlink -f "{}" \;; }

# tag_list_tags
# Lists all known tags
function tag_list_tags() { find "$TAGDIR" -type l -name "*tag:*" | cut -d\: -f2 | sort | uniq; }

