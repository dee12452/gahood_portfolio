import * as http from 'http';
import { WebSocketServer } from 'ws';
import { client } from './client';

const pgptClient = await client.createPgptClient();
const httpServer = http.createServer();
const wsServer = new WebSocketServer({ server: httpServer });

wsServer.on('connection', (ws, rq) => {
  const ipAddress = rq.socket.remoteAddress;
  console.log(`New connection! ${ipAddress}`);

  ws.on('message', async (message) => {
    if (!message) {
      return;
    }
    console.log(`Message from ${ipAddress}: ${message}`);
    const prompt = message.toString();
    if (prompt.length > 100) {
      console.log(`Message was too long with length ${prompt.length}`);
      ws.send('Prompt too long, can only be a max of 100 characters.');
      return;
    }

    const result = await pgptClient.contextualCompletions.promptCompletion({
      prompt: message.toString(),
      includeSources: true,
      useContext: true,
    });
    if (result.choices.length == 0) {
      return;
    }
    const aiMessage = result.choices[0].message?.content;
    if (aiMessage) {
      console.log(`Message to ${ipAddress}: ${aiMessage}`);
      ws.send(aiMessage);
    } else {
      ws.close(1013, 'Failed to receive a response from the AI.')
    }
  });

  ws.on('close', () => {
    console.log(`${ipAddress} has disconnected`);
  });
});

const port = '8000';
httpServer.listen(port, () => {
  console.log(`Starting server on port ${port}`);
});
