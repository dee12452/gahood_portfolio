import { PrivategptApiClient } from 'privategpt-sdk-node';

const createPgptClient = async (): Promise<PrivategptApiClient> => {
  const pgptUrl = process.env.PGPT_URL || 'http://localhost';
  const pgptApiClient = new PrivategptApiClient({ environment: `${pgptUrl}:8001` });
  const health = await pgptApiClient.health.health();
  if (health.status != 'ok') {
    return Promise.reject(new Error('Cannot connect to Private GPT Instance'));
  }
  return pgptApiClient;
}

export const client = {
  createPgptClient,
};
