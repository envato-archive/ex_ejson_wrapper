# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
use Mix.Config

config :ex_ejson_wrapper,
  json_codec: Jason,
  ejson_keydir: "/opt/ejson/keys"

config :porcelain,
  driver: Porcelain.Driver.Basic

# and access this configuration in your application as:
#
#     Application.get_env(:ex_ejson_wrapper, :key)
#
# You can also configure a third-party app:
#
#     config :logger, level: :info
#

# It is also possible to import configuration files, relative to this
# directory. For example, you can emulate configuration per environment
# by uncommenting the line below and defining dev.exs, test.exs and such.
# Configuration from the imported file will override the ones defined
# here (which is why it is important to import them last).
#
import_config "#{Mix.env()}.exs"
