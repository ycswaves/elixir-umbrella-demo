<style>
main {
  text-align: center;
  padding: 1em;
  max-width: 240px;
  margin: 0 auto;
}

h1 {
  color: #ff3e00;
  text-transform: uppercase;
  font-size: 4em;
  font-weight: 100;
}

h2 {
  font-size: 2em;
}

span.large-font {
  font-size: 2.5em;
}

div.layout {
  padding: 20px 10%;
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  gap: 10px;
}

.notification {
  margin: 0 !important;
}

@media (min-width: 640px) {
  main {
    max-width: none;
  }
}
</style>

<script>
import { onMount } from 'svelte';
import { joinChannel, newCounter, startWorker, stopWorker, socket } from './channel';
export let name;
let counterChannel;
let workDone = 0;
let allWorkers = [];

function updateWorkersCount(res) {
  console.log(res);
  allWorkers = res?.workers;
}

onMount(() => {
  socket.connect();
  counterChannel = newCounter(socket);
  joinChannel(counterChannel, updateWorkersCount);

  counterChannel.on('update_total', (res) => {
    workDone = res?.total ?? 0;
  });

  counterChannel.on('workers_updated', updateWorkersCount);
});

function stopOneWorker(workerName) {
  stopWorker(counterChannel, workerName);
}

function startOneWorker() {
  startWorker(counterChannel);
}
</script>

<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bulma@0.9.1/css/bulma.min.css" />
<main>
  <h1>{name}!</h1>
  <br />
  <button class="button is-success is-rounded" on:click="{startOneWorker}">start a worker</button>
  <h2>task completed: <span class="large-font">{workDone}</span></h2>
  <h2>👷 x {allWorkers.length}</h2>
  <div class="layout">
    {#each allWorkers as worker}
      <div class="notification is-info">
        <button class="delete" on:click="{() => stopOneWorker(worker)}"></button>{worker}
      </div>
    {/each}
  </div>
</main>
