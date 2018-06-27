# OvhEx

OvhEx is a wrapper on OVH API

## Creates a customer key

First, you need a consumer key. For this, you can use the `mix ovh.auth` task.

For instance, for a consumer key allowed to read all routes and PUT on
`/me` route:

``` shell
mix ovh.auth 'GET /*' 'PUT /me'
```

See `https://api.ovh.com/console/#/auth/credential#POST` for more
details about rules.

Once the key is validated, you should export it in `OVH_CONSUMER_KEY`
env var:

``` shell
export OVH_CONSUMER_KEY=abcdef12345
```

## TODO

* Implements all calls
* Use some kind of translator between doc and Elixir code (should
  achieve first point)
