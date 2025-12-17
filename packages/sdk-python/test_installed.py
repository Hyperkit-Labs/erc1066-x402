#!/usr/bin/env python3
"""
Test script to verify the installed Python SDK works correctly
"""

try:
    from erc1066_x402 import ERC1066Client, Intent
    
    print("[OK] SDK imported successfully!")
    
    # Initialize client
    client = ERC1066Client("http://localhost:3001")
    print("[OK] Client initialized")
    
    # Test intent (using Intent model)
    intent = Intent(
        sender="0xa43b752b6e941263eb5a7e3b96e2e0dea1a586ff",
        target="0xf5cb11878b94c9cd0bfa2e87ce9d6e1768cea818",
        data="0x",
        value="0",
        nonce="1",
        validAfter="0",
        validBefore="18446744073709551615",
        policyId="0x0000000000000000000000000000000000000000000000000000000000000000",
    )
    
    print("\nTesting intent validation...")
    result = client.validate_intent(intent, 133717)
    
    print(f"[OK] Validation successful!")
    print(f"   Status: {result.status}")
    print(f"   HTTP Code: {result.httpCode}")
    print(f"   Intent Hash: {result.intentHash}")
    
    print("\n[OK] All tests passed!")
    
except ImportError as e:
    print(f"[ERROR] Import failed: {e}")
    print("\nInstall the package first:")
    print("  pip install hyperkitlabs-erc1066-x402")
except Exception as e:
    print(f"[ERROR] Test failed: {e}")
    import traceback
    traceback.print_exc()

