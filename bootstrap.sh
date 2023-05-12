#!/bin/bash
# bootstrap.sh
# author: peterm
# created: 2023-04-20
#############################################################

#change to correct directory to run these commands from
cd "$(dirname "$0")" || exit

pwd

# source pablo.sh a bash script helper
source ./scripts/PABLO.sh

backupDir=${outputDir}/${dateStamp}_${timeStamp}_backup

ignore=(
	.git
	.gitignore
	.gitmodules
	.README
	bootstrap.sh
	.config
)

#############################################################

pStart

dotDir=$(pwd -P)
pLog "getting dot files from location: ${dotDir}"

#git pull origin main
#pCheckError $? "git pull"

for file in * .[!.]*; do
	if [[ ${ignore[*]} =~ ${file} ]]
	then
		pLog "ignoring ${file}"
		continue
	fi

	filePath=${dotDir}/${file}
	dstPath=${HOME}/${file}

	if [ -f "$dstPath" ] || [ -d "$dstPath" ] || [ -L "$dstPath" ]; then
		pLog "backing up ${file} in ${backupDir}"
	
		mkdir -p "${backupDir}"
		mv "${dstPath}" "${backupDir}/${file}"
	fi

	ln --symbolic --relative "${filePath}" "${dstPath}"
	pCheckError $? "create symbolic link"

	pLog "symbolic link created ${dstPath} -> ${filePath}"
	
done

for file in .config/*; do

	filePath=${dotDir}/${file}
	dstPath=${HOME}/${file}

	if [ -f "$dstPath" ] || [ -d "$dstPath" ] || [ -L "$dstPath" ]; then
		pLog "backing up ${file} in ${backupDir}"
	
		mkdir -p "${backupDir}"
		mv "${dstPath}" "${backupDir}/${file}"
	fi

	ln --symbolic --relative "${filePath}" "${dstPath}"
	pCheckError $? "create symbolic link"

	pLog "symbolic link created ${dstPath} -> ${filePath}"
	
done

pEnd

