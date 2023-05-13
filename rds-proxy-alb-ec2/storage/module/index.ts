import { Client } from 'pg';

export const handler = async () => {
  const client = new Client();
  await client.connect();

  const results = await client.query('SELECT * FROM film WHERE film_id = 3');

  await client.end();

  return results.rows[0];
};
