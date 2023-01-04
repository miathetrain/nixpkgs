#!/usr/bin/env nix-shell
#! nix-shell -I nixpkgs=../../../../.. -i bash -p wp4nix

set -e
set -u
set -o pipefail
set -x

nixFlags="--option experimental-features nix-command eval --raw --impure --expr"
export WP_VERSION=$(nix $nixFlags '(import <nixpkgs> {}).wordpress.version')

PLUGINS=`cat wordpress-plugins.json | jq -r '.[]' | sed -z 's/\n/,/g;s/,$/\n/'`
THEMES=`cat wordpress-themes.json | jq -r '.[]' | sed -z 's/\n/,/g;s/,$/\n/'`
LANGUAGES=`cat wordpress-languages.json | jq -r '.[]' | sed -z 's/\n/,/g;s/,$/\n/'`

wp4nix -p $PLUGINS -pl en
wp4nix -t $THEMES -tl en
wp4nix -l $LANGUAGES

rm *.log themeLanguages.json pluginLanguages.json
