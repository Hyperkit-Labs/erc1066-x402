import { Counter, Histogram, Registry } from "prom-client";

const register = new Registry();

export const intentValidationsTotal = new Counter({
  name: "intent_validations_total",
  help: "Total number of intent validations",
  labelNames: ["chain_id", "status"],
  registers: [register],
});

export const intentExecutionsTotal = new Counter({
  name: "intent_executions_total",
  help: "Total number of intent executions",
  labelNames: ["chain_id", "status"],
  registers: [register],
});

export const statusCodeDistribution = new Counter({
  name: "status_code_distribution",
  help: "Distribution of status codes",
  labelNames: ["status_code"],
  registers: [register],
});

export const chainRequestsTotal = new Counter({
  name: "chain_requests_total",
  help: "Total number of chain requests",
  labelNames: ["chain_id"],
  registers: [register],
});

export const responseTimeHistogram = new Histogram({
  name: "gateway_response_time_seconds",
  help: "Response time in seconds",
  labelNames: ["endpoint", "method"],
  buckets: [0.1, 0.5, 1, 2, 5],
  registers: [register],
});

export function getMetrics(): Promise<string> {
  return register.metrics();
}

