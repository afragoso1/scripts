#!/bin/bash

if [ $# -gt 2 ]
then
        echo "Invalid option"
        exit 1
fi

findFiles()
{
        #gets all text files from current directory
        textFiles=$(find . -type f -exec grep -Iq . {} \; -print)
        for i in $textFiles; do
                if [ $1 == "m" ]
                then
                        #get month as search criteria
                        search=$(ls -lt --time=birth $i | awk '{print $6}')
                        search="${search^^}" #use ^^ to convert month to upper case
                elif [ $1 == "o" ]
                then
                        #get owner as search criteria
                        search=$(stat -c '%U' $i)
                fi

                #if file meets search criteria
                if [ $search == $2 ]
                then
                        lines=$(wc -l $i | awk '{print $1}')
                        echo "File: "$i", Lines: "$lines
                fi
        done
}

while getopts "o:m:" option; do
        case ${option} in
        m)
                echo "Looking for files where the month is: $OPTARG"
                findFiles ${option} "${OPTARG^^}" #use ^^ to send month to upper case
                ;;
        o)
                echo "Looking for files where the owner is: $OPTARG"
                findFiles ${option} $OPTARG
                ;;
        \?)
                echo "Invalid option"
                ;;
        esac
done
