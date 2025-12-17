import 'dotenv/config';
import { createServer } from "./server";

async function start() {
  const server = await createServer();

  try {
    const address = await server.listen({
      port: Number(process.env.PORT || 3000),
      host: process.env.HOST || "0.0.0.0",
    });
    console.log(`Server listening on ${address}`);
  } catch (err) {
    server.log.error(err);
    process.exit(1);
  }

  const gracefulShutdown = async (signal: string) => {
    server.log.info(`${signal} received, shutting down gracefully`);
    await server.close();
    process.exit(0);
  };

  process.on("SIGTERM", () => gracefulShutdown("SIGTERM"));
  process.on("SIGINT", () => gracefulShutdown("SIGINT"));
}

start();

