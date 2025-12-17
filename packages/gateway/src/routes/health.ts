import { FastifyInstance } from "fastify";
import { getAllChainIds, getRpcClient } from "../config/chains";
import { getMetrics } from "../monitoring/prometheus";

export async function healthRoutes(fastify: FastifyInstance) {
  fastify.get("/metrics", async (request, reply) => {
    reply.type("text/plain");
    return getMetrics();
  });

  fastify.get("/health", async (request, reply) => {
    const chainIds = getAllChainIds();
    const health: Record<string, boolean> = {};

    for (const chainId of chainIds) {
      const client = await getRpcClient(chainId);
      if (client) {
        try {
          await client.getBlockNumber();
          health[chainId.toString()] = true;
        } catch {
          health[chainId.toString()] = false;
        }
      } else {
        health[chainId.toString()] = false;
      }
    }

    const allHealthy = Object.values(health).every((h) => h);

    reply.code(allHealthy ? 200 : 503);
    return {
      status: allHealthy ? "healthy" : "degraded",
      chains: health,
    };
  });
}

