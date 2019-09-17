#!/bin/bash
set -Ceu

if [ -z "${WIKI_LANG+x}" ] ; then
	echo "env empty error WIKI_LANG"
    exit 1
fi

while read line
do
    dirname=`dirname ${line}`
    filename=`basename ${line}`
    wget -r -l1 -nc -np -nd -e robots=off -R "*multistream*" -A "${filename}" ${dirname}/ -P /import/wikidata/${WIKI_LANG}
done < /import/script/download.lst.${WIKI_LANG}
