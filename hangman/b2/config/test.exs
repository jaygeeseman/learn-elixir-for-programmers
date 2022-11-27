import Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :b2, B2Web.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "//ZN07D1xSDJe9t1JsCMNtV0zoQLvooI3K9X3SGkuVSfWZuYGRcuIne9Kl77ZUGC",
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime
