#!/bin/bash
type jq >/dev/null 2>&1
if [ $? -ne 0 ]; then
	echo "jq is not installed, please google it to install"
	exit 1
fi

fields=(".pipeline.stages[0].actions[0].configuration.Branch" ".pipeline.stages[0].actions[0].configuration.Owner")

pathDir=/devops_labs/lab_1/task3
backupName=$(date '+%Y-%m-%d')pipeline.json
branch="main"
owner=""

jq 'del(.metadata)' $pathDir/pipeline.json > tmp.$$.json && mv tmp.$$.json $pathDir/$backupName

jq '.pipeline.version |=.+1' $pathDir/$backupName > tmp.$$.json && mv tmp.$$.json  $pathDir/$backupName

for field in "${fields[@]}"
do
	if [[ -z `jq --arg field "$field" '$field | select(.)'  $pathDir/$backupName` ]]; then
	echo "Does not exist"
	exit 1
fi
done

while getopts ":b:o:c:p:" arg; do
	case "$arg" in 
		b)
			branch=${OPTARG}
			;;
		o) 
			owner=${OPTARG}
			;;
		p) 	
			`jq '.pipeline.stages[0].actions[0].configuration.PollForSourceChanges = true' $pathDir/$backupName > tmp.$$.json && mv tmp.$$.json $pathDir/$backupName`
			;;
		c)
			conf=${OPTARG}
			`jq --arg conf $conf '.pipeline.stages[1].actions[0].configuration.EnvironmentVariables = $conf' $pathDir/$backupName > tmp.$$.json && mv tmp.$$.json $pathDir/$backupName`
			;;
	esac
done
shift $((OPTIND-1))

jq --arg branch $branch '.pipeline.stages[0].actions[0].configuration.Branch = $branch' $pathDir/$backupName > tmp.$$.json && mv tmp.$$.json $pathDir/$backupName

[ ! -z $owner ] && `jq --arg owner $owner '.pipeline.stages[0].actions[0].configuration.Owner = $owner' $pathDir/$backupName > tmp.$$.json && mv tmp.$$.json $pathDir/$backupName`

