const wsPort = 8000;
const portJava = 7000;

export const environment = {
  production: false,
  wsPort,
  wsPath: '/ws/canvas/',
  endpoint_python: `http://127.0.0.1:${wsPort}/`,
  WebSocket_python: `127.0.0.1:${wsPort}`,
  endpoint_java: `http://127.0.0.1:${portJava}/`
};
