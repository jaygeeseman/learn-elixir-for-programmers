import Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :b1, B1Web.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "9vzMIOJTIv/OcTOkGbvLZ2pORyp2GlsIJaTLLMCns2tSjAoueemqMt6/n/0+C8Ag",
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime
