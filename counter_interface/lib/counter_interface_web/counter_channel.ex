defmodule CounterInterfaceWeb.CounterChannel do
  use CounterInterfaceWeb, :channel

  alias Counter.{Accumulator, WorkerSupervisor}

  def join("counter:public", _payload, socket) do
    Process.send_after(self(), :poll_total, 500)
    {:ok, all_workers(), socket}
  end

  def handle_in("start_worker", payload, socket) do
    IO.puts("=== start_worker")
    WorkerSupervisor.start_counter()
    broadcast(socket, "workers_updated", all_workers())
    {:reply, {:ok, payload}, socket}
  end

  def handle_in("stop_worker", %{"worker_name" => worker_name}=payload, socket) do
    IO.puts("=== stop worker")
    WorkerSupervisor.stop_counter(worker_name)
    broadcast(socket, "workers_updated", all_workers())
    {:reply, {:ok, payload}, socket}
  end

  def handle_info(:poll_total, socket) do
    total = Accumulator.get_total()
    broadcast(socket, "update_total", %{total: total})
    Process.send_after(self(), :poll_total, 200)
    {:noreply, socket}
  end

  defp all_workers do
    %{workers: Accumulator.get_workers() |> MapSet.to_list}
  end
end
