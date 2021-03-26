#!/bin/bash
# send an url to getpocket.com, using the token from ~/.pocket_access_token.
#
# (c) 2013, Andreas Happe <andreashappe@snikt.net>
. $HOME/.secret_aliases

METHOD_URL="https://getpocket.com/v3/add"

TITLE="$2"
URL="$1"



PARAMS="{\"url\":\"$URL\", \"title\":\"$TITLE\", \"consumer_key\":\"$APPLICATION_CONSUMER_KEY\", \"access_token\":\"$USER_ACCESS_TOKEN\"}"

output=`wget --post-data "$PARAMS" --header="Content-Type: application/json" $METHOD_URL -O - `
