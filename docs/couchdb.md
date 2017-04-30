## CouchDB

1. START COUCH DB:
```
/etc/init.d/couchdb start
```
- Execute in shell:
```
COUCH="localhost:5984"
JSON="Content-Type:application/json"
```
- GET DB ENTITIES:
```
curl -X GET $COUCH/polls
```
- GET ALL DB ENTITIES ONLY DOCS:
```
curl -X GET "$COUCH/polls/_all_docs?include_docs=true"
```
- GET ONE DB ENTITY:
```
curl -X GET $COUCH/polls/5e6ba44d3bc61c3241bc0894b3000263
```
- ADD DB ENTITY:
```
curl -X POST -H $JSON $COUCH/polls -d '{"title":"Which is better: iOS or macOS?", "option1": "iOS", "option2": "macOS", "votes1": 0, "votes2": 0}'
```
- DELETE DB ENTITY:
```
curl -X DELETE "<ID_OF_ENTITY>?rev=<REV_OF_ENTITY>"
```
- EXAMPLE:
```
curl -X DELETE "$COUCH/polls/5e6ba44d3bc61c3241bc0894b3000263?rev=2-28f0a0a699b4f093b717df88c86f2e8c"
```
