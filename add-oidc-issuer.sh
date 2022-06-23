#!/usr/bin/env bash
if [ "$#" -ne 2 ]; then
  echo "usage: ./add-oidc-issuer.sh host root-folder"
  exit 1
fi

HOST=$1
ROOT=$2

pushd $ROOT

for FOLDER in *
do
  echo "Processing Pod $FOLDER.$HOST"
  PROFILE="$FOLDER/profile/card\$.ttl"

  if test -f "$PROFILE"; then
    echo "  Checking $PROFILE"

    if grep -s -q oidcIssuer $PROFILE; then
      echo "  Found existing oidcIssuer triple; skipping"
    else
      echo "  Adding oidcIssuer triple"
      cp $PROFILE "$FOLDER/profile/card.bak"
      printf "\n<#me> <http://www.w3.org/ns/solid/terms#oidcIssuer> <https://$HOST>. # Automatically added for Solid 0.9 compatibility\n" >> $PROFILE
    fi
  fi
done

popd
