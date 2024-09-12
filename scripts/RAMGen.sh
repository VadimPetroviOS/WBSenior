#!/bin/sh

#  gNewsAPI.sh
#  ChartsTest
#
#  Created by Вадим on 29.08.2024.
#  

MODULE="Package/RickAndMortyAPI/Sources/RickAndMortyAPI/"

openapi-generator-cli generate -i "APIs/RickAndMorty.yaml" -g swift5 -o "RickAndMorty" --additional-properties=responseAs=AsyncAwait

rm -r $MODULE""*
cp -R "RickAndMorty/OpenAPIClient/Classes/OpenAPIs/". $MODULE
rm -r "RickAndMorty"
