#!/bin/bash

set -x

echo ""
read -p "Tenant: "   TENANT
read -p "Username: " USER
read -p "Password: " PASSWORD
read -p "Keystone IP: " KEYSTONE
echo ""

echo $TENANT

COMMAND="curl -s -d '{\"auth\": {\"tenantName\": \"$TENANT\", \"passwordCredentials\":{\"username\": \"$USER\", \"password\": \"$PASSWORD\"}}}' -H \"Content-type: applicat
ion/json\" -H \"Accept: application/json\"  http://$KEYSTONE/keystone/v2.0/tokens"

RESP=`eval $COMMAND`

echo -e "\nResp: $RESP"

TOKEN=`echo $RESP | sed 's/.*"id":."\(.*\)",."tenant.*/\1/'`

echo -e "\nAccess Token: $TOKEN"

RESP=`curl -v -H "X-Auth-Token:$TOKEN" -X HEAD http://130.206.80.61/glance/v1/images/31177950-5f8b-40be-a307-70c81fc37719 2> a.out`

RESP=`more a.out | grep x-image-meta-property-nid`

if [[ -z "$RESP" ]]; then
  echo "Metadata not assigned..."
  echo "\nFix metadata value on them"
else
  echo "check correct value of metadata"
fi

RESP=`echo $RESP | awk '{print $3}'`

echo -e "\nFinal: $RESP"

