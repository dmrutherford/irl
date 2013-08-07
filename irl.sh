#!/bin/bash


    ##############################
    ##                          ##
    ##  interwebs reading list  ##
    ##  ======================  ##
    ##                          ##
    ##      tpo-a001-1.0.0      ##
    ##      d m rutherford      ##
    ##                          ##
    ##############################


# GLOBAL VARIABLES

progname=${0##*/}
dropbox=$HOME/Dropbox
irl=$dropbox/.irl
list=$irl/irl.txt
temp=$list.tmp
archive=$irl/archive.txt


# FUNCTIONS

help() {
    cat <<EO

irl: interwebs reading list
===========================

A simple script for managing a reading-list of URLs in Dropbox.

Usage:
    $progname [command] [url / item no.]

Commands:
EO
    cat <<EO | column -s\& -t
    -i              & initialise irl
    -l              & show current reading list (default)
    -o [item no.]   & open specified item in browser
    -a [url]        & add an item to the reading list
    -r [item no.]   & remove specified item from the reading list
    -y              & show the archive
    -v [item no.]   & open the specified archived item
    -p              & purge archive
    -h              & show available commands
EO
    echo ""
}

gtg() {
    if ! [ -f $list ]
    then
        cat <<EO

Couldn't locate irl.txt. Please initialise irl:

    'irl -i'

EO
        exit
    fi
}

gtga() {
    if ! [ -s $archive ]
    then
        echo -e "\nNothing in the archive.\n"
        exit
    fi
}

initirl() {
    if ! [ -f $list ]
    then
        echo -e "\nInitialising irl..."
        if ! [ -d $irl ]
        then
            mkdir $irl
        fi
        touch $list
        sleep 0.25
    fi
    if ! [ -f $archive ]
    then
        touch $archive
    fi
    echo -e "\nirl is ready.\n"
}

tidyup() {
    sed '/^$/d' $list > $temp
    mv $temp $list
}

countlines() {
    lines=$(wc $1 | awk {'print $1'})
}

printcount() {
    countlines $1
    echo ""
    if (( $lines == 1 ))
    then
        echo "$lines item:"
    else
        echo "$lines items:"
    fi
    echo ""
}

printlist() {
    printcount $1
    cat -n $1
    echo ""
}

printirl() {
    gtg
    tidyup
    if [ -s $list ]
    then
        printlist $list
    else
        echo -e "\nYou've read everything!\n"
    fi
}

printarchive() {
    gtga
    printlist $archive
}

getlink() {
    link=$(awk -v n=$1 "NR == n { print }" $2)
}

isblank() {
    getlink $1 $2
    if [ -z $link ]
    then
        blanklink=true
    else
        blanklink=false
    fi
}

checklink() {
    countlines $2
    if [ $1 -gt $lines ]
    then
        echo -e "\nNo such item."
        echo -e "Set your sights lower.\n"
        exit
    fi
    isblank $1 $2
    if $blanklink
    then
        echo -e "\nItem $1 has been removed."
        echo -e "Run 'irl -l' to tidy up the list.\n"
        exit
    fi
}

openlink() {
    getlink $1 $2
    if ! type xdg-open &> /dev/null
    then
        open $link
    else
        xdg-open $link
    fi
}

openirl() {
    gtg
    checklink $1 $list
    openlink $1 $list
}

openarchive() {
    gtga
    checklink $1 $archive
    openlink $1 $archive
}

pastelink() {
    if type pbpaste &> /dev/null
    then
        link=$(pbpaste)
    elif type xclip &> /dev/null
    then
        link=$(xclip -o)
    elif type xsel &> /dev/null
    then
        link=$(xsel --clipboard --output)
    else
        echo -e "\nUnable to access clipboard and no URL given."
        echo -e "Please specify a URL.\n"
        exit
    fi
    if [ -z $link ]
    then
        echo -e "\nClipboard empty and no URL given."
        echo -e "Please specify a URL.\n"
        exit
    else
        echo -e "\nNo URL specified."
        echo -e "Using clipboard contents..."
        sleep 0.25
    fi
}

linkexists() {
    if grep -Fxq "$1" $2
    then
        exists=true
    else
        exists=false
    fi
}

addlink() {
    gtg
    if [ -z $1 ]
    then
        pastelink
    else
        link=$1
    fi
    linkexists $link $list
    if $exists
    then
        echo -e "\nThe given URL is already in the list.\n"
        exit
    fi
    echo "$link" >> $list
    echo -e "\n$link added to irl.txt.\n"
}

archivelink() {
    getlink $1 $list
    linkexists $link $archive
    if ! $exists
    then
        echo "$link" >> $archive
    fi
}

removelink() {
    gtg
    checklink $1 $list
    archivelink $1
    awk -v n=$1 -v l="" "NR == n { print l; next } { print }" $list > $temp
    mv $temp $list
    echo -e "\nItem $1 removed.\n"
}

purge() {
    if [ -f $archive ]
    then
        rm $archive
    fi
    touch $archive
    echo -e "\nArchive purged.\n"
}

callforhelp() {
    echo -e "Use 'irl -h' for help.\n"
}


# COMMANDS

opts=":ilo:ar:yv:ph"

while getopts $opts opt; do
    case "$opt" in
        i)
            initirl
            exit
            ;;
        l)
            printirl
            exit
            ;;
        o)
            openirl $2
            exit
            ;;
        a)
            addlink $2
            exit
            ;;
        r)
            removelink $2
            exit
            ;;
        y)
            printarchive
            exit
            ;;
        v)
            openarchive $2
            exit
            ;;
        p)
            purge
            exit
            ;;
        h)
            help
            exit
            ;;
        \?)
            echo -e "\nThe command '$progname -$OPTARG' is invalid."
            callforhelp
            exit
            ;;
        :)
            echo -e "\nThe command '$progname -$OPTARG' requires an argument."
            callforhelp
            exit
            ;;
    esac
done


# FALLBACK

printirl
exit