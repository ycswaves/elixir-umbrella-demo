import App from './App.svelte';

const app = new App({
  target: document.body,
  props: {
    name: 'Task Tracker App',
  },
});

export default app;
