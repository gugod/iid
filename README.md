
## run

    IID_INDEX_DIRECTORY=/db/iid plackup -Ilib bin/iid

It is mandatory to set `IID_INDEX_DIRECTORY` to a existing directory.

## reload the index from file.

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
