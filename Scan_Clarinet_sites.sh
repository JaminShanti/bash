#!/usr/bin/env bash
musicsite="http://www.carolinaclarinet.org/links2.htm"
echo $musicsite
echo $(lynx -dump -listonly "$musicsite")
sitelist=$( lynx --dump --listonly "$musicsite"| grep http | cut -f2- -d'.' | tr -d ' ' | sort | uniq )
echo $sitelist
for site in "$sitelist[@]";do
    echo $site
done
