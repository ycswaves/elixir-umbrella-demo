import Phoenix from 'phoenix';

export const socket = new Phoenix.Socket('ws://localhost:4000/socket', {});

export function newCounter(socket) {
  return socket.channel('counter:public', {});
}

export function joinChannel(channel, cb) {
  channel
    .join()
    .receive('ok', cb)
    .receive('error', (res) => {
      console.log('Unable to join', res);
    });
}

export function stopWorker(channel, workerName) {
  channel.push('stop_worker', { worker_name: workerName });
}

export function startWorker(channel) {
  channel.push('start_worker', { step: 1 });
}
