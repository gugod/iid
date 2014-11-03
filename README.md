
## run

plackup -Ilib bin/iid

## POST

```
curl -XPOST http://localhost:5000/stuff/ -d '{
    "documents": [
        { "id": "taipei",   "tokens": ["daan","park","beef","noodle"] },
        { "id": "hsinchu",  "tokens": ["science","park","rice","noodle"] },
        { "id": "taichung", "tokens": ["science","museum","thick","noodle"] }
    ]
}'
~~~
```
