defmodule PingMinion.Mixfile do
  use Mix.Project

  def project do
    [app: :ping_minion,
     # doc stuff
     source_url: "https://github.com/USER/REPO",
     homepage_url: "http://YOUR_PROJECT_HOMEPAGE",
     docs: [
       extras: ["README.md"]
     ],
     # end doc stuff
     version: "0.0.1",
     elixir: "~> 1.2",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    [applications: [:logger, :httpotion,
                    # webbish stuff:
                    :cowboy, :plug]]
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
      {:ibrowse, github: "cmullaparthi/ibrowse", tag: "v4.1.2"},
      {:httpotion, "~> 2.1.0"},
      # Documentation
      {:earmark, "~> 0.1", only: :dev},
      {:ex_doc, "~> 0.11", only: :dev},
      # additional dependencies for a webbish life
      {:cowboy, "~> 1.0.0"},{:plug, "~> 1.0"}
    ]
  end
end
