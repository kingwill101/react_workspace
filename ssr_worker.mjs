import React from 'react';
import ReactDOMServer from 'react-dom/server';
globalThis.React = React;

import './build/ssr.js';
import http from 'http';
const server = http.createServer((req,res)=>{
  let b=''; req.on('data',c=>b+=c); req.on('end',()=>{
    try {
      const {id, props} = JSON.parse(b);
      const element = globalThis.__REACT_RENDER__({id, props});
      const html = ReactDOMServer.renderToString(element);
      res.writeHead(200, {'Content-Type':'application/json'});
      res.end(JSON.stringify({html}));
    } catch(e){ res.writeHead(500); res.end(JSON.stringify({error: e.toString()})); }
  });
});
server.listen(3001, ()=>console.log('ssr worker :3001'));
