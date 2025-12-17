export const STATUS_CODE_MAP = {
    "0x01": { code: 200, headers: {} },
    "0x00": { code: 500, headers: {} },
    "0x10": { code: 403, headers: {} },
    "0x11": { code: 200, headers: {} },
    "0x20": { code: 202, headers: { "Retry-After": "60" } },
    "0x21": { code: 410, headers: {} },
    "0x22": { code: 409, headers: {} },
    "0x50": { code: 500, headers: {} },
    "0x51": { code: 200, headers: {} },
    "0x54": { code: 402, headers: { "X-Payment-Required": "true" } },
    "0xA0": { code: 400, headers: {} },
    "0xA1": { code: 501, headers: {} },
    "0xA2": { code: 421, headers: {} },
};
export function mapStatusToHttp(status) {
    return STATUS_CODE_MAP[status] || { code: 500, headers: {} };
}
//# sourceMappingURL=status.js.map