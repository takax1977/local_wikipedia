### Local Wikipedia

## Description
copy wikipedia to the local computer with docker

### supports wikipedia
- [English Wikipedia](https://en.wikipedia.org)  
- [Japanese Wikipedia](https://ja.wikipedia.org)

## Requirements
- docker 17.09.0 or higher
- docker-compose 3.4 or higher

:exclamation:
English Wikipedia:make sure you have at least 800GB of free disk space  
:exclamation:
Japanese Wikipedia:make sure you have at least 50GB of free disk space

## Usage
1. clone this repository

        git clone https://github.com/takax1977/wikipedia_local.git

2. create mediawiki

        export WIKI_LANG=ja
        export PUID=$(id -u); export PGID=$(id -g)
        export WIKI_HOST=localhost
        docker-compose up -d

     ##### WIKI_LANG
    en=English Wikipedia  
    ja=Japanese Wikipedia


3. download data

        docker-compose exec --user `whoami` mediawiki /import/script/download.sh

    :exclamation:
    English Wikipedia:download data around 80GB

    :exclamation:
    Japanese Wikipedia:download data around 4GB

4. import data

        docker-compose exec --user `whoami` mediawiki /import/script/import_sql.sh

    :exclamation:
    English Wikipedia:It will take at least 5 days

    :exclamation:
    Japanese Wikipedia:It will take at least 10 hours

5. access

        http://localhost/

## Known issues

- script error because of wikidata access, extensions, modules, images, etc.

## Usage Examples
### call mediawiki api
    curl "http://localhost/api.php?format=xml&action=query&prop=revisions&rvslots=*&titles=a&rvprop=content"

### exec sql
    docker-compose exec --user `whoami` mediawiki bash
    mysql -h db -u${MYSQL_USER} -p${MYSQL_PASSWORD} ${MYSQL_DATABASE}

    SELECT
        p.page_id AS "page_id",
        CAST(p.page_title AS CHAR(10000) CHARACTER SET utf8) AS "page_title",
        r.rev_text_id AS "revision_id",
        t.old_id AS "text_id",
        t.old_text AS "text"
    FROM
        page p
            INNER JOIN revision r
                ON p.page_latest = r.rev_id
            INNER JOIN text t
                ON r.rev_text_id = t.old_id
    WHERE
        p.page_title like "%a%"
    AND
        p.page_namespace = 0
    AND
        r.rev_deleted = 0
    AND
        p.page_is_redirect = 0 \G

## Licence

MIT
