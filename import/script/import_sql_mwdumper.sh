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
echo " drop index"
cat ${BASE_PATH}/script/page_start.sql | mysql -h db -u${MYSQL_USER} -p${MYSQL_PASSWORD} -D ${MYSQL_DATABASE}
echo " import xml"
ls ${DATA_PATH}/*.xml-*.bz2 -Sr | parallel -u -j${IMPORT_THREADS} "cat ${BASE_PATH}/script/tran_start.sql <(java -jar /app/mwdumper/mwdumper.jar --format=sql:1.25 --filter=latest {}) <(cat ${BASE_PATH}/script/tran_end.sql) | mysql -h db -u${MYSQL_USER} -p${MYSQL_PASSWORD} -D ${MYSQL_DATABASE}"
echo " create index"
cat ${BASE_PATH}/script/page_end.sql | mysql -h db -u${MYSQL_USER} -p${MYSQL_PASSWORD} -D ${MYSQL_DATABASE}
echo "=== xml import end ${SECONDS}s ==="

echo 'SET GLOBAL innodb_flush_log_at_trx_commit = 1' | mysql -h db -uroot -p${MYSQL_ROOT_PASSWORD}

end_time=`date +%Y/%m/%d-%H:%M:%S`
echo "=== import_sql.sh end ${end_time} ==="
