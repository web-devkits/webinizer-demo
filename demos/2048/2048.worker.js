importScripts("https://cdn.jsdelivr.net/npm/xterm-pty@0.9.6/workerTools.js");

onmessage = (msg) => {
  importScripts(location.origin + "/2048-in-terminal.js");

  emscriptenHack(new TtyClient(msg.data));
};
