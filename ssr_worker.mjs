import React from 'react';
import ReactDOMServer from 'react-dom/server';
globalThis.React = React;

import './packages/react_js/js/callback_trampoline.mjs';
import './build/ssr.js';
import http from 'http';

http.createServer((req, res) => {
  let b = ''; req.on('data', c => b += c); req.on('end', () => {
    try {
      const {id, props} = JSON.parse(b || '{"id":"package:react_workspace/example/lib/app.dart#App","props":{"title":"hi"}}');
      const element = globalThis.__REACT_RENDER__({id, props});
      const html = ReactDOMServer.renderToString(element);
      res.writeHead(200, {'Content-Type': 'application/json'});
      res.end(JSON.stringify({html, props}));
    } catch (e) { console.error(e); res.writeHead(500); res.end(JSON.stringify({error: e.message})); }
  });
}).listen(3001, () => console.log('ssr worker :3001'));
