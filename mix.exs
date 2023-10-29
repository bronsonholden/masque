defmodule Masque.MixProject do
  use Mix.Project

  @github_url "https://www.github.com/bronsonholden/masque"
  @version "0.1.0"

  def project do
    [
      app: :masque,
      version: @version,
      description: "Masque is a first-party headless CMS for Elixir backed by PostgreSQL.",
      elixir: "~> 1.15",
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      deps: deps(),
      package: package(),
      elixirc_paths: elixirc_paths(Mix.env())
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_env), do: ["lib"]

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      {:ecto_sql, "~> 3.6"},
      {:jason, "~> 1.1"},
      {:postgrex, "~> 0.16"},
      {:ex_json_schema, "~> 0.10"}
    ]
  end

  defp package() do
    [
      maintainers: ["Bronson Holden"],
      licenses: ["MIT"],
      links: %{
        Website: "https://www.getmasque.com",
        GitHub: @github_url
      }
    ]
  end

  defp aliases do
    [
      test: ["ecto.create --quiet", "ecto.migrate --quiet", "test"]
    ]
  end
end
