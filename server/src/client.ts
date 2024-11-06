import { PrivategptApiClient } from 'privategpt-sdk-node';

const createPgptClient = async (): Promise<PrivategptApiClient> => {
  const pgptUrl = process.env.PGPT_URL || 'http://localhost:8001';
  console.log(`Starting connection to pgpt instance at ${pgptUrl}`);
  const pgptApiClient = new PrivategptApiClient({ environment: pgptUrl });
  const health = await pgptApiClient.health.health();
  if (health.status != 'ok') {
    return Promise.reject(new Error('Cannot connect to Private GPT Instance'));
  }
  return pgptApiClient;
}

const createResponse = async (client: PrivategptApiClient, prompt: string): Promise<string | undefined> => {
  if (prompt.length > 100) {
    console.log(`Message was too long with length ${prompt.length}`);
    return 'Prompt too long, can only be a max of 100 characters.';
  }

  try {
    const result = await client.contextualCompletions.promptCompletion({
      prompt: prompt,
      includeSources: true,
      useContext: true,
    });
    if (result.choices.length == 0) {
      return undefined;
    }

    const aiMessage = result.choices[0].message?.content;
    return aiMessage;
  } catch (error) {
    console.log(`Error occurred when getting a response from the llm: ${error}`);
    return undefined;
  }
};

export const client = {
  createPgptClient,
  createResponse,
};
