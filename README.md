# Elixir EJSONWrapper

Wraps the [ejson](https://github.com/Shopify/ejson) golang program to safely execute it and parse the resulting JSON.

It is an Elixir port of Ruby gem [envato/ejson_wrapper](https://github.com/envato/ejson_wrapper)

## Dependency

* [ejson](https://github.com/Shopify/ejson)

To install on macOS:

```
$ brew tap shopify/shopify
$ brew install ejson
```

For other OS, please consult your vendor's package repository.

## Installation

The package can be installed by adding `ex_ejson_wrapper` to your list of dependencies in `mix.exs`:

```elixir
# mix.exs
defp deps do
  [
    {:ex_ejson_wrapper, "~> 0.1.0"}
  ]
end
```

Then JSON encoder and EJSON Keydir must be configured.

## Configuration

#### JSON Decoder

The library does not dictate which library to use, thus it is up to the users to configure the library. In following example, the `Jason` library is added to mix dependency and configured to be used:

```elixir
# mix.exs
defp deps do
  [
    {:jason, "~> 1.1"}
  ]
end
```

```elixir
# config/config.exs
config :ex_ejson_wrapper,
  json_codec: Jason,
```

#### EJSON Keydir

EJSON Keydir is the directory that consists of EJSON private keys. By default, it is set to `/opt/ejson/keys`. It can be configured with:


```elixir
# config/config.exs
config :ex_ejson_wrapper,
  ejson_keydir: "/my_ejson/keys",
```

## Usage

#### Decrypting EJSON file

```elixir
# Private key is in /opt/ejson/keys
EJSONWrapper.decrypt('myfile.ejson')
# => {:ok, %{"my_api_key" => "key"}}
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/envato/ex_ejson_wrapper.

