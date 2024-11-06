import * as http from 'http';
import { WebSocketServer } from 'ws';
import { client } from './client';

const pgptClient = await client.createPgptClient();
const httpServer = http.createServer();
const wsServer = new WebSocketServer({ server: httpServer });

let runningQueries = 0;
const maxQueries = 5;

wsServer.on('connection', (ws, rq) => {
  const ipAddress = rq.socket.remoteAddress;
  console.log(`New connection! ${ipAddress}`);

  ws.on('message', async (message) => {
    if (!message) {
      return;
    }
    console.log(`Message from ${ipAddress}: ${message}`);
    if (runningQueries > maxQueries) {
      ws.send('AI is currently at capacity, please try again later.');
      return;
    }

    runningQueries++;
    const prompt = message.toString();
    const response = await client.createResponse(pgptClient, prompt);
    if (!response) {
      ws.close(1013, 'Failed to receive a response from the AI.')
    } else {
      console.log(`Message to ${ipAddress}: ${response}`);
      ws.send(response);
    }
    runningQueries--;
  });

  ws.on('close', () => {
    console.log(`${ipAddress} has disconnected`);
  });
});

const port = '8000';
httpServer.listen(port, () => {
  console.log(`Starting server on port ${port}`);
});
