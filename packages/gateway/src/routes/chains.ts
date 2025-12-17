import { FastifyInstance } from "fastify";
import { getAllChainIds, getChainConfig } from "../config/chains";
import { getChainMetadata, ChainMetadata } from "../utils/chainlist";
import { registerCustomNetwork, getCustomNetwork } from "../config/customNetworks";
import { z } from "zod";

export async function chainRoutes(fastify: FastifyInstance) {
  fastify.get("/chains", async (request, reply) => {
    const chainIds = getAllChainIds();
    const chains = await Promise.all(
      chainIds.map(async (chainId) => {
        const config = getChainConfig(chainId);
        const metadata = await getChainMetadata(chainId);

        // Combine RPC URLs from metadata and config (custom RPCs take priority)
        const allRpcUrls = [
          ...(config?.rpcUrls || []),
          ...(config?.rpcUrl ? [config.rpcUrl] : []),
          ...(metadata?.rpcUrls || []),
        ];
        // Remove duplicates
        const uniqueRpcUrls = Array.from(new Set(allRpcUrls));

        return {
          chainId,
          name: metadata?.name || config?.customMetadata?.name || `Chain ${chainId}`,
          nativeCurrency: metadata?.nativeCurrency || config?.customMetadata?.nativeCurrency,
          rpcUrls: uniqueRpcUrls,
          explorers: metadata?.explorers || config?.customMetadata?.explorers,
          contracts: config
            ? {
                executor: config.executorAddress,
                validator: config.validatorAddress,
                policyRegistry: config.policyRegistryAddress,
              }
            : undefined,
        };
      })
    );

    return { chains };
  });

  fastify.get("/chains/:chainId", async (request, reply) => {
    const chainId = Number((request.params as any).chainId);
    const config = getChainConfig(chainId);
    const metadata = await getChainMetadata(chainId);

    if (!config && !metadata) {
      reply.code(404);
      return { error: "Chain not found" };
    }

    // Combine RPC URLs from metadata and config (custom RPCs take priority)
    const allRpcUrls = [
      ...(config?.rpcUrls || []),
      ...(config?.rpcUrl ? [config.rpcUrl] : []),
      ...(metadata?.rpcUrls || []),
    ];
    // Remove duplicates
    const uniqueRpcUrls = Array.from(new Set(allRpcUrls));

    return {
      chainId,
      name: metadata?.name || config?.customMetadata?.name || `Chain ${chainId}`,
      nativeCurrency: metadata?.nativeCurrency || config?.customMetadata?.nativeCurrency,
      rpcUrls: uniqueRpcUrls,
      explorers: metadata?.explorers || config?.customMetadata?.explorers,
      contracts: config
        ? {
            executor: config.executorAddress,
            validator: config.validatorAddress,
            policyRegistry: config.policyRegistryAddress,
          }
        : undefined,
    };
  });

  // Register custom network
  const registerNetworkSchema = z.object({
    chainId: z.number(),
    name: z.string(),
    nativeCurrency: z
      .object({
        name: z.string(),
        symbol: z.string(),
        decimals: z.number(),
      })
      .optional(),
    rpcUrls: z.array(z.string()),
    explorers: z
      .array(
        z.object({
          name: z.string(),
          url: z.string(),
        })
      )
      .optional(),
  });

  fastify.post("/chains", async (request, reply) => {
    try {
      const body = registerNetworkSchema.parse(request.body);

      const metadata: ChainMetadata = {
        chainId: body.chainId,
        name: body.name,
        nativeCurrency:
          body.nativeCurrency ||
          ({
            name: "Ether",
            symbol: "ETH",
            decimals: 18,
          } as ChainMetadata["nativeCurrency"]),
        rpcUrls: body.rpcUrls,
        explorers: body.explorers,
      };

      registerCustomNetwork(metadata);

      reply.code(201);
      return {
        success: true,
        message: `Custom network ${body.chainId} registered`,
        network: metadata,
      };
    } catch (error) {
      if (error instanceof z.ZodError) {
        reply.code(400);
        return { error: "Invalid request", details: error.errors };
      }
      reply.code(500);
      return { error: "Failed to register network" };
    }
  });

  // Get custom network
  fastify.get("/chains/:chainId/custom", async (request, reply) => {
    const chainId = Number((request.params as any).chainId);
    const customNetwork = getCustomNetwork(chainId);

    if (!customNetwork) {
      reply.code(404);
      return { error: "Custom network not found" };
    }

    return customNetwork;
  });
}

