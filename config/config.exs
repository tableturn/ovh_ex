use Mix.Config

config :ovh, app_secret: "DPs1p5NMnY0pB06MH7TF3haVyodAiOH1"

case Mix.env() do
  env when env in [:dev, :test] ->
    config :ovh, http: {"0.0.0.0", 3241}
    config :ovh, redirection: "http://0.0.0.0:3241"
  _ ->
    config :ovh, http: false
    config :ovh, redirection: "http://api.ovh.com"
end
