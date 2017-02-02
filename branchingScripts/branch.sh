#!/bin/bash

RCol='\x1B[0m'; Red='\x1B[0;31m'; Gre='\x1B[0;32m'; Yel='\x1B[0;33m'; Blu='\x1B[0;34m';

usage() {
	echo "Usage: branch.sh <version-to-be-released> <snapshot-version-number> <revision-properties-file>"
	echo "<version-to-be-released> is the current bahmni version"
	echo "<snapshot-version-number> is the next version"
	echo "<revision-properties-file> is repo revision file. Provide full path of the file"
}

if [  $# -le 2 ]
then
	usage
	exit 1
fi

declare -a allrepos=("openmrs-module-bahmniapps" "openerp-atomfeed-service" "OpenElis"
 "bahmni-core" "bahmni-java-utils" "openerp-modules" "openerp-functional-tests" "openmrs-distro-bahmni"
 "emr-functional-tests" "default-config" "bahmni-reports" "pacs-integration" "openmrs-module-rulesengine"
 "event-log-service" "bahmni-offline" "bahmni-package" "bahmni-playbooks" "bahmni-tw-playbooks" "bahmni-offline-sync"
 "bahmni-gauge" "openmrs-module-bahmni.ie.apps")

rm -rf ~/allrepos
mkdir ~/allrepos
cd ~/allrepos

. $3

for repo in "${allrepos[@]}"
do
   declare shaKey=$(echo "$repo" | tr '-' '_')
#   echo ${!shaKey}

   echo -e "${Blu}Cloning $repo ${RCol}"
   git clone git@github.com:Bahmni/$repo.git
   cd $repo
   echo -e "${Gre}Creating a branch for $repo - release-"${1/-SNAPSHOT/}"... ${RCol}"
   git branch release-"${1/-SNAPSHOT/}" ${!shaKey}
   find . -name "pom.xml" -exec sed -i '' 's/'${1/-SNAPSHOT/}'/'${2/-SNAPSHOT/}'/g'  {} \;
   find . -name "config.xml" -exec sed -i '' 's/'${1/-SNAPSHOT/}'/'${2/-SNAPSHOT/}'/g'  {} \;
   find . -name "openmrs-versions-configuration.pp" -exec sed -i '' 's/'${1/-SNAPSHOT/}'/'${2/-SNAPSHOT/}'/g'  {} \;
   if [ -n "$(git status --porcelain)" ]; then
   	git diff > ../$repo.diff
   	echo -e "${Gre}Version changes in "$repo:master" ->  ./allrepos/$repo.diff ${RCol} "
   	git commit -am "upping the version to $2"
   fi
   cd ..
done
