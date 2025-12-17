// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

library DeploymentConfig {
    struct ChainConfig {
        uint256 chainId;
        string rpcUrl;
        string name;
    }

    function getHyperionTestnet() internal pure returns (ChainConfig memory) {
        return ChainConfig({
            chainId: 133717,
            rpcUrl: "https://hyperion-testnet.metisdevops.link",
            name: "Hyperion Testnet"
        });
    }

    function getMetisSepolia() internal pure returns (ChainConfig memory) {
        return ChainConfig({
            chainId: 59902,
            rpcUrl: "https://metis-sepolia-rpc.publicnode.com",
            name: "Metis Sepolia"
        });
    }

    function getMetisMainnet() internal pure returns (ChainConfig memory) {
        return ChainConfig({
            chainId: 1088,
            rpcUrl: "https://andromeda.metis.io/?owner=1088",
            name: "Metis Andromeda Mainnet"
        });
    }

    function getMantleTestnet() internal pure returns (ChainConfig memory) {
        return ChainConfig({
            chainId: 5003,
            rpcUrl: "https://rpc.sepolia.mantle.xyz",
            name: "Mantle Testnet"
        });
    }

    function getMantleMainnet() internal pure returns (ChainConfig memory) {
        return ChainConfig({
            chainId: 5000,
            rpcUrl: "https://rpc.mantle.xyz",
            name: "Mantle Mainnet"
        });
    }

    function getAvalancheFuji() internal pure returns (ChainConfig memory) {
        return ChainConfig({
            chainId: 43113,
            rpcUrl: "https://api.avax-test.network/ext/bc/C/rpc",
            name: "Avalanche Fuji"
        });
    }

    function getAvalancheMainnet() internal pure returns (ChainConfig memory) {
        return ChainConfig({
            chainId: 43114,
            rpcUrl: "https://api.avax.network/ext/bc/C/rpc",
            name: "Avalanche C-Chain"
        });
    }
}

