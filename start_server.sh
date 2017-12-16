#!/bin/bash
while ! curl -s http://${ELASTICSEARCH_HOST}/_cluster/health; do sleep 1; done
curl -s "http://${ELASTICSEARCH_HOST}/_cluster/health?wait_for_status=green&timeout=10s"
psql -l $DATABASE_URL || ( \
       createdb -h meme-db -U postgres meme \
    && psql $DATABASE_URL < scripts/init_db.sql \
    && redis-cli -h meme-redis -n 0 flushall \
    && curl -XPUT http://${ELASTICSEARCH_HOST}/meme/ \
       --data-binary "@scripts/init_es.json" \
        && rm -rf webapp/public/uploads/* )
service nginx start
npm start
