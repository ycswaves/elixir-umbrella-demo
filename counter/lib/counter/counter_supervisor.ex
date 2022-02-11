defmodule Counter.WorkerSupervisor do
  @moduledoc """
  Documentation for `Counter`.
  """

  @doc """
  Hello world.

  ## Examples

      iex> WorkerSupervisor.start_counter()
      iex> Accumulator.get_total()

  """
  use DynamicSupervisor
  alias Counter.Accumulator

  # https://hexdocs.pm/elixir/Supervisor.html#module-child_spec-1
  def start_link(_opts) do
    IO.puts("starting worker supervisor")
    DynamicSupervisor.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def start_counter() do
    timestamp = :os.system_time(:millisecond)
    worker_name = "worker: #{timestamp}"
    DynamicSupervisor.start_child(__MODULE__, {Counter.Worker, worker_name})
    worker_name
  end

  def stop_counter(worker_name) do
    DynamicSupervisor.terminate_child(__MODULE__, pid_from_name(worker_name))
    Accumulator.remove_worker(worker_name)
  end

  defp pid_from_name(name) do
    name
    |> Counter.Worker.via_tuple()
    |> GenServer.whereis()
  end

  ## Callbacks
  @impl true
  def init(:ok) do
    IO.puts("worker supervisor started")
    DynamicSupervisor.init(strategy: :one_for_one)
  end
end
