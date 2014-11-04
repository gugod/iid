
## run

plackup -Ilib bin/iid

## load the index

```
curl -XPOST http://localhost:5000/stuff/ -d '{"action":"load"}'
```

## adding documents to an index

```
curl -XPOST http://localhost:5000/stuff/ -d '{
    "action": "index",
    "documents": [
        { "id": "taipei",   "tokens": ["daan","park","beef","noodle"] },
        { "id": "hsinchu",  "tokens": ["science","park","rice","noodle"] },
        { "id": "taichung", "tokens": ["science","museum","thick","noodle"] }
    ]
}'
```

## save the index

```
curl -XPOST http://localhost:5000/stuff/ -d '{"action":"save"}'
```
