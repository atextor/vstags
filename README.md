vstags - Very Simple Tags
=========================

A flexible and powerful, yet very simple to understand file tagging system.

Basic idea - tl;dr
------------------

You have one directory, `~/tags`, which contains symbolic links. The name of each symbolic link contains the tag name, the link target is the tagged file.
This way, standard file system tools are used to create, remove and query tags.


Overview
--------

A file tagging system must fulfil a number of requirements, which vary depending on who you ask. My list of requirements is the following: 
* It should be virtually impossible to lose your tags (e.g., when a database is corrupted).
* Tags should not be limited to a single application or framework (e.g., KDE, Gnome or $PHOTO_LIBRARY_TOOL).
* Adding, removing and querying tags should be easily doable from the command line, including from scripts for automation.
* Tags should be easy to backup.
* Tags should not depend on some OS-feature that is not well supported or unavailable on some systems
(e.g., extended file attributes are [badly supported](http://www.lesbonscomptes.com/pages/extattrs.html) tool-wise).
* Tags should not alter the original files in any way.
* The tagging system should be transparently usable on multi-user systems (e.g., a tag in extended file attribute would be visible for all users, unless you devise a schema for managing access).
* Not only the tagging system but also the way it stores tags, should be easily understandable.

So, vstags makes use of standard file system tools.
For each tag assertion, a symbolic link is created in a global tag directory (by default: ~/tags), which links to the tagged file. The tag value is part of the link file name.
To avoid name clashes, the link file name is prefixed with a UUID. To enable extensibility for other metadata (such as, e.g., *rating*), the actual tag is prefixed with `tag:`. So, it could
look like the following:

```sh
$ ls -l ~/tags
total 12
lrwxrwxrwx 1 user group 63 Dec 16 14:58 8670bf91-d66d-42fd-b9dd-8e62691d7ebb;tag:family -> /home/user/photos/dscn001.jpg
lrwxrwxrwx 1 user group 67 Dec 16 14:58 fd2cf74c-11cf-4baa-8c51-00f976ab2260;tag:work -> /home/user/documents/important.doc
lrwxrwxrwx 1 user group 63 Dec 16 14:57 fec42204-72c9-4d36-ba6b-fd44ac0e5bc2;tag:work -> /home/user/documents/chart.xls
```

* To add a tag, a corresponding symlink is created.
* To remove a tag, the corresponding symlink is deleted.
* To show all tags for a file, you can use `find` to list all symbolic links from the tag directory that point to that file:

	find -L ~/tags -samefile somefile.txt | cut -d\; -f2
* To list all files that have a certain tag, you can use `readlink` to follow the symbolic links with the right name:

	find ~/tags -name "*tag:sometag*" -exec readlink -f "{}" \;
* To list all known tags, you just list the links and `uniq` them:

	find ~/tags -type l -name "*tag:*" | cut -d\: -f2 | sort | uniq
* And so on, you get the point.

All we need now is a collection of aliases or shell functions for the above commands, and this is provided by vstags.sh.

Installation
------------

Add the following line to your `.bashrc` (or equivalent):
	source /path/to/vstags.sh

Create the tags directory:
	mkdir ~/tags 
(Or change the TAGDIR variable in vstags.sh, and create the according directory)

Run the following to check that you have the necessary tools installed:
	for cmd in readlink uuidgen find cut uniq; do which $cmd 2>&1 >/dev/null || echo “You don’t have $cmd installed”; done
(If nothing is output, then you are set)

Usage
-----

```sh
# Adds a tag for the file
tag_add somefile.txt tag

# Removes a tag for the file
tag_remove somefile.txt tag

# Removes all occurrences of tag from any file
tag_remove_from_any tag

# Shows all tags for file
tag_show_for_file somefile.txt

# Lists all files with the tag
tag_find_files_by_tag tag

# Lists all known tags
tag_list_tags
```

Todo
----

Things that are not implemented:
* Tracking changing files. Could be implemented using `inotifywait`.
* Queries with AND or OR predicates. This is left as an exercise for the reader ;-)

Author
------

vstags was written by Andreas Textor <textor.andreas@googlemail.com>.


