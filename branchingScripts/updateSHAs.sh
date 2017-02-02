#!/bin/bash
brew install jq
RCol='\x1B[0m'; Red='\x1B[0;31m'; Gre='\x1B[0;32m'; Yel='\x1B[0;33m'; Blu='\x1B[0;34m';

declare -a allrepos=("openmrs-module-bahmniapps" "openerp-atomfeed-service" "OpenElis"
 "bahmni-core" "bahmni-java-utils" "openerp-modules" "openerp-functional-tests" "openmrs-distro-bahmni"
 "emr-functional-tests" "default-config" "bahmni-reports" "pacs-integration" "openmrs-module-rulesengine"
 "event-log-service" "bahmni-offline" "bahmni-package" "bahmni-playbooks" "bahmni-tw-playbooks" "bahmni-offline-sync"
 "bahmni-gauge" "openmrs-module-bahmni.ie.apps")

rm repo_revisions.properties
  for repo in "${allrepos[@]}"
do
   echo -e "${Gre}Getting latest commit SHA for $repo ${RCol}"
   echo  -e "https://api.github.com/repos/Bahmni/$repo/commits/master"
   printf "$repo=" | tr "-" "_" >> repo_revisions.properties
   curl "https://api.github.com/repos/Bahmni/$repo/commits/master"| jq '.sha'| tr -d  "\"">> repo_revisions.properties
done
