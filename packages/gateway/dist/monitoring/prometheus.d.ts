import { Counter, Histogram } from "prom-client";
export declare const intentValidationsTotal: Counter<"status" | "chain_id">;
export declare const intentExecutionsTotal: Counter<"status" | "chain_id">;
export declare const statusCodeDistribution: Counter<"status_code">;
export declare const chainRequestsTotal: Counter<"chain_id">;
export declare const responseTimeHistogram: Histogram<"method" | "endpoint">;
export declare function getMetrics(): Promise<string>;
//# sourceMappingURL=prometheus.d.ts.map