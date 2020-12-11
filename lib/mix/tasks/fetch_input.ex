defmodule Mix.Tasks.FetchInput do
  use Mix.Task

  @shortdoc "Fetch input for the specified day"

  def run(args) do
    day = hd(args)
    url = "https://adventofcode.com/2020/day/#{day}/input"
    cookie = Application.fetch_env!(:advent_of_code_2020, :cookie)
    file = Path.expand("../../inputs/day_#{String.pad_leading(day, 2, "0")}_input.txt", __DIR__)

    IO.puts("Downloading from #{url}...")
    HTTPoison.start()
    %HTTPoison.Response{body: body} = HTTPoison.get!(url, %{}, hackney: [cookie: [cookie]])

    if File.exists?(file) do
      IO.puts("File exists, will overwrite...")
    end

    IO.puts("Writing file...")
    File.write!(file, body)

    IO.puts("Done.")
  end
end
