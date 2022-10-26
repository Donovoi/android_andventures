#!/bin/sh
# This script will use all methods on https://gtfobins.github.io/ to try and escalate privileges. 
# It will state the method it is trying, and then let the user know if the method failed or succeeded and why.
# It will also let the user know if the method is not available on the system.
# We need to parse and run the commands from the gtfobins page, so we need to use curl to get the page, and then grep to find the commands.
# and make each command an object so it is easy to run and work with.
#this script will only ever be run by an unpriivleged user, so we can assume that the user is not root.
# We will also assume that the user has curl and grep installed, as they are required for this script to work.
# this script will have an offline mode, where it will use a local copy of the gtfobins page, and not use curl to get the page.


# We first need to download all *.md files from the gtfobins github page, and then grep for the commands.
# Download the files to a directory called methods. Create the directory if it does not exist.
mkdir -p methods

#First we need to get a list of all the files we need to download.
# The md files are listed on this page https://github.com/GTFOBins/GTFOBins.github.io/tree/master/_gtfobins
#First check to make sure methods/gtfobins.html doesnt already exist, if it does, then delete it.
if [ -f methods/gtfobins.html ]; then
    rm methods/gtfobins.html
fi

if [ -f methods/gtfobins.txt ]; then
    rm methods/gtfobins.txt
fi

# if [ -f methods/mdfiles/ ]; then
#     rm -rf methods/mdfiles/
# fi
# We will use curl to get the page, and then grep to find the links that end in .md
curl https://github.com/GTFOBins/GTFOBins.github.io/tree/master/_gtfobins -o methods/gtfobins.html
# We will use grep to find the links that end in .md
grep -oP '(?<=href=")[^"]*\.md' methods/gtfobins.html > methods/gtfobins.txt
#we need to prepend https://raw.githubusercontent.com to the links so they are valid.
sed -i 's/^/https:\/\/raw.githubusercontent.com/g' methods/gtfobins.txt
# now remove "blob/" from the links
sed -i 's/blob\///g' methods/gtfobins.txt
# now we need to download the files to a directory called methods/mdfiles
#Check if mdfiles exist if it doesnt then create it. if it does and it has files in it, then let the user know.
if [ -d methods/mdfiles ]; then
    if [ "$(ls -A methods/mdfiles)" ]; then
        echo "The directory methods/mdfiles already exists and has files in it. Delete it if you want to redownload all methods again, takes about 4mins on my internet."
    fi
else
    mkdir -p methods/mdfiles
fi
# now we need to download the files only if they havent already been downloaded.
while read line
do
    file=$(echo $line | awk -F"/" '{print $NF}')
    if [ -f methods/mdfiles/$file ]; then
        echo "$file already exists, skipping download."
    else
        echo "Downloading $file"
        curl $line -o methods/mdfiles/$file
    fi
done < methods/gtfobins.txt

# The md files are sorted by function, sp we need to collect all the commands for each function into a single file.
# We will create a directory called methods/commands, and then create a file for each function.
# We will also create a file called methods/commands/allcommands.txt, which will contain all the commands from all the functions.
# MAke sure the directory exists, if it doesnt then create it.
if [ -d methods/commands ]; then
    if [ "$(ls -A methods/commands)" ]; then
        echo "The directory methods/commands already exists and has files in it. Delete it if you want to recreate the files."
    fi
else
    mkdir -p methods/commands
fi

# Now we need to grep each md file for the commands, and append them to the correct file.
# We will use grep to find the commands, and then append them to the correct file.
# We will also append them to the allcommands.txt file.
for file in methods/mdfiles/*.md; do
    # Get the function name from the file name.
    functionname=$(basename $file)
    # Remove the .md from the end of the file name.
    functionname="${functionname%.*}"
    # We need to remove the first line from the file, as it is not a command.
    sed -i '1d' $file
    # Now we need to append the commands to the correct file.
    while read -r line; do
        echo $line >> methods/commands/$functionname.txt
        echo $line >> methods/commands/allcommands.txt
    done < $file
done

# touch methods/commands/allcommands.txt

# # We will loop through each file in methods/mdfiles, and grep for the commands.
# for file in methods/mdfiles/*; do
#     # get the function name from the file name.
#     function=$(basename $file)
#     # remove the .md from the function name
#     function=${function%.*}
#     # create a file for the function
#     touch methods/commands/$function.txt
#     # grep for the commands
#     grep -oP '(?<=```).*(?=```)' $file >> methods/commands/$function.txt
#     # append the commands to the allcommands.txt file
#     cat methods/commands/$function.txt >> methods/commands/allcommands.txt
# done