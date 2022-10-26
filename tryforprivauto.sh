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
if [ -d methods/ ]; then
    rm -rf methods/
fi

# recreate the folder structure
mkdir -p methods/commands
mkdir -p methods/mdfiles

# We will use curl to get the page, and then grep to find the links that end in .md
curl https://github.com/GTFOBins/GTFOBins.github.io/tree/master/_gtfobins -o methods/gtfobins.html
# We will use grep to find the links that end in .md
grep -oP '(?<=href=")[^"]*\.md' methods/gtfobins.html >methods/gtfobins.txt
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
while read -r line; do
    file=$(echo "$line" | awk -F"/" '{print $NF}')
    if [ -f methods/mdfiles/"$file" ]; then
        echo "$file already exists, skipping download."
    else
        echo "Downloading $file"
        curl "$line" -o methods/mdfiles/"$file"
    fi
done <methods/gtfobins.txt

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
    functionname=$(basename "$file")
    # Remove the .md from the end of the file name.
    functionname="${functionname%.*}"
    # We need to remove the first line from the file, as it is not a command.
    sed -i '1d' "$file"
    # Now we need to append the commands to the correct file.
    while read -r line; do
        echo "$line" >>methods/commands/"$functionname".txt
        echo "$line" >>methods/commands/allcommands.txt
    done <"$file"
done

#Now we need to understand how the functions are structured, and how to run them.
#the different possible functions and how they appear in the .txt files are:
#Shell - "shell:"
#Command - "command:"
#Reverse shell - "reverse-shell:"
#Non-interactive reverse shell - "non-interactive-reverse-shell:"
#Bind shell - "bind-shell:"
#Non-interactive bind shell - "non-interactive-bind-shell:"
#File upload - "file-upload:"
#File download - "file-download:"
#File write - "file-write:"
#File read - "file-read:"
#Library load - "library-load:"
#SUID - "suid:"
#Sudo - "sudo:"
#Capabilities - "capabilities:"
#Limited SUID - "limited-suid:"

# We need to create a function for each of the above functions. We we have seperate directories for each type of function.
# When creating the functions, we need to ignore the allcommands.txt file.

folderarray='shell
command
reverse-shell
non-interactive-reverse-shell
bind-shell
non-interactive-bind-shell
file-upload
file-download
file-write
file-read
library-load
suid
sudo
capabilities
limited-suid'

for folder in $folderarray; do
    if [ -d methods/"$folder" ]; then
        if [ "$(ls -A methods/"$folder")" ]; then
            echo "The directory methods/$folder already exists and has files in it. Delete it if you want to recreate the files."
        fi
    else
        mkdir -p methods/"$folder"
    fi
done

# We need to create txt files for each function, and then append the commands to the correct file.
for file in methods/commands/*.txt; do
    # Get the function name from the file name.
    functionname=$(basename "$file")
    # Remove the .md from the end of the file name.
    functionname="${functionname%.*}"
    # Now we need to append the commands to the correct file.
    while read -r line; do
        echo "$line" >>methods/"$folder"/"$functionname".txt
    done <"$file"
done
