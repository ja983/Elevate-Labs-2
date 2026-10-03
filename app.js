const express = require('express');

const app = express();

app.get('/', (req, res) => {
  res.json({ message: 'Hello from nodejs-demo-app!', status: 'ok' });
});

app.get('/health', (req, res) => {
  res.status(200).send('healthy');
});

module.exports = app;
