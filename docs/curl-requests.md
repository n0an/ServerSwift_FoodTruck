## Curl requests

#### Contents
- [Requests to Kitura](#kitura)
- [Requests to CouchDB](#couchdb)

#### Kitura
- POST JSON:
```
curl -vX POST -H "content- type: application/json" localhost:8090/messages/create -d '{"title": "Swift: great language or greatest language?"}'
```

#### CouchDB
1. Execute in shell:
```
COUCH="localhost:5984"
JSON="Content-Type:application/json"
```
2. GET DB ENTITIES:
```
curl -X GET $COUCH/polls
```
3. GET ALL DB ENTITIES ONLY DOCS:
```
curl -X GET "$COUCH/polls/_all_docs?include_docs=true"
```
4. GET ONE DB ENTITY:
```
curl -X GET $COUCH/polls/5e6ba44d3bc61c3241bc0894b3000263
```
5. ADD DB ENTITY:
```
curl -X POST -H $JSON $COUCH/polls -d '{"title":"Which is better: iOS or macOS?", "option1": "iOS", "option2": "macOS", "votes1": 0, "votes2": 0}'
```
6. DELETE DB ENTITY:
```
curl -X DELETE "<ID_OF_ENTITY>?rev=<REV_OF_ENTITY>"
```
7. EXAMPLE:
```
curl -X DELETE "$COUCH/polls/5e6ba44d3bc61c3241bc0894b3000263?rev=2-28f0a0a699b4f093b717df88c86f2e8c"
```
