defmodule Counter.Accumulator do
  use GenServer

  def start_link(init_num) do
    IO.puts("accumulator starts with #{init_num}")
    GenServer.start_link(__MODULE__, init_num, name: __MODULE__)
  end

  def increment(step) do
    GenServer.cast(__MODULE__, {:increment, step})
  end

  def increment() do
    GenServer.cast(__MODULE__, {:increment, 1})
  end

  def add_worker(worker_name) do
    GenServer.cast(__MODULE__, {:add_worker, worker_name})
  end

  def remove_worker(worker_name) do
    GenServer.cast(__MODULE__, {:remove_worker, worker_name})
  end

  def get_total() do
    GenServer.call(__MODULE__, :total)
  end

  def get_workers() do
    GenServer.call(__MODULE__, :all_workers)
  end

  ## Callbacks
  @impl true
  def init(init_num) do
    IO.puts("accumulator started")
    {:ok, %{total: init_num, workers: MapSet.new()}}
  end

  @impl true
  def handle_call(:total, _from, state) do
    {:reply, state.total, state}
  end

  def handle_call(:all_workers, _from, state) do
    {:reply, state.workers, state}
  end

  @impl true
  def handle_cast({:increment, step}, state) do
    {:noreply, %{state | total: state.total + step}}
  end

  def handle_cast({:add_worker, worker_name}, state) do
    {:noreply, %{state | workers: MapSet.put(state.workers, worker_name)}}
  end

  def handle_cast({:remove_worker, worker_name}, state) do
    {:noreply, %{state | workers: MapSet.delete(state.workers, worker_name)}}
  end
end
