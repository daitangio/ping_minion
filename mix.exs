defmodule PingMinion.Mixfile do
  use Mix.Project

  def project do
    [app: :ping_minion,
     version: "0.0.2",
     # doc stuff
     source_url: "https://github.com/daitangio/ping_minion",
     homepage_url: "http://gioorgi.com/tag/ping_minion",
     docs: [
       extras: [ "README.md"  ]
     ],
     # end doc stuff     
     elixir: "~> 1.3",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    [applications: [:logger, :httpotion,
                    :quantum
                    # webbish stuff:
                    #:cowboy, :plug
                   ]]
  end

  # Dependencies can be Hex packages:
  #
  #   {:mydep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:mydep, git: "https://github.com/elixir-lang/mydep.git", tag: "0.1.0"}
  #
  # Type "mix help deps" for more examples and options
  defp deps do
    [
      {:httpotion, "~> 3.0"},
      # Documentation
      {:earmark, "~> 0.2", only: :dev},
      {:ex_doc, "~> 0.12", only: :dev},
      # additional dependencies for a webbish life
      # {:cowboy, "~> 1.0.0"},{:plug, "~> 1.0"},
      # Cron-like services
      {:quantum, ">= 1.7.1"},
      {:csv, "~> 1.2.0"}
    ]
  end
end
