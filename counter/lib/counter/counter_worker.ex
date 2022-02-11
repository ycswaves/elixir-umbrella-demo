defmodule Counter.Worker do
  use GenServer
  alias Counter.Accumulator

  def via_tuple(name), do: {:via, Registry, {Registry.Counter, name}}

  def start_link(worker_name) do
    GenServer.start_link(__MODULE__, worker_name, name: via_tuple(worker_name))
  end

  defp count_next() do
    Process.send_after(self(), :count_next, 3 * 1000)
  end

  ## Callbacks
  @impl true
  def init(worker_name) do
    count_next()
    Accumulator.add_worker(worker_name)
    {:ok, worker_name}
  end

  # @impl true
  # def terminate(_reason, worker_name) do
  #   IO.puts('=========== terminate')
  #   IO.inspect(worker_name)
  #   Accumulator.remove_worker(worker_name)
  # end

  @impl true
  def handle_info(:count_next, state) do
    GenServer.cast(self(), :increment)
    {:noreply, state}
  end

  @impl true
  def handle_cast(:increment, state) do
    Accumulator.increment()
    count_next()
    {:noreply, state}
  end
end
