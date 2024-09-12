#!/bin/sh

#  gNewsAPI.sh
#  ChartsTest
#
#  Created by Вадим on 29.08.2024.
#  

MODULE="Package/Dota2TeamsAPI/Sources/Dota2TeamsAPI/"

openapi-generator-cli generate -i "APIs/Dota2Teams.yaml" -g swift5 -o "Dota2Teams" --additional-properties=responseAs=AsyncAwait

rm -r $MODULE""*
cp -R "Dota2Teams/OpenAPIClient/Classes/OpenAPIs/". $MODULE
rm -r "Dota2Teams"
