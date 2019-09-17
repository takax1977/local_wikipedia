#!/bin/bash
set -Ceu
BASE_PATH=/import
DATA_PATH=${BASE_PATH}/wikidata/${WIKI_LANG}

start_time=`date +%Y/%m/%d-%H:%M:%S`
echo 'will cite' | parallel --citation 1> /dev/null 2> /dev/null &
echo "=== import_sql.sh start ${start_time} ==="

if [ -z "${WIKI_LANG+x}" ]; then
	echo "env empty error WIKI_LANG"
    exit 1
fi

echo 'SET GLOBAL innodb_flush_log_at_trx_commit = 2' | mysql -h db -uroot -p${MYSQL_ROOT_PASSWORD}

echo "=== csv import start ==="
SECONDS=0
ls ${DATA_PATH}/*.sql.gz -Sr | parallel -j${IMPORT_THREADS} --progress "cat ${BASE_PATH}/script/tran_start.sql <(zcat {}) <(cat ${BASE_PATH}/script/tran_end.sql) | mysql -h db -u${MYSQL_USER} -p${MYSQL_PASSWORD} -D ${MYSQL_DATABASE}"
echo "=== csv import end ${SECONDS}s ==="

echo "=== xml import start ==="
SECONDS=0
echo " import xml"
ls ${DATA_PATH}/*-latest-pages-articles*.xml-*.bz2 -Sr | parallel -j${IMPORT_THREADS} "bzip2 -dc {} | php importdump.php --no-updates"
echo "=== xml import end ${SECONDS}s ==="

echo 'SET GLOBAL innodb_flush_log_at_trx_commit = 1' | mysql -h db -uroot -p${MYSQL_ROOT_PASSWORD}

end_time=`date +%Y/%m/%d-%H:%M:%S`
echo "=== import_sql.sh end ${end_time} ==="
