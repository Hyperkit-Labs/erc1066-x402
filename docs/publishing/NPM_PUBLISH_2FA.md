# npm Publishing with 2FA - Solutions

## Issue
npm requires 2FA for publishing, but the interactive login process may not work in all environments.

## Solutions

### Option 1: Use Granular Access Token (Recommended)

1. **Create a Granular Access Token:**
   - Go to https://www.npmjs.com/settings/hyperkitdev/tokens
   - Click "Generate New Token"
   - Select "Granular Access Token"
   - Set permissions: `Read and Write` for `@hyperkit` scope
   - Copy the token

2. **Use Token for Publishing:**
   ```bash
   cd packages/sdk-ts
   npm config set //registry.npmjs.org/:_authToken YOUR_TOKEN_HERE
   npm publish --access public
   ```

3. **Or use environment variable:**
   ```bash
   export NPM_TOKEN=your_token_here
   npm publish --access public --//registry.npmjs.org/:_authToken=$NPM_TOKEN
   ```

### Option 2: Use .npmrc File

Create `.npmrc` in `packages/sdk-ts/`:
```
//registry.npmjs.org/:_authToken=${NPM_TOKEN}
@hyperkit:registry=https://registry.npmjs.org/
```

Then set environment variable:
```bash
export NPM_TOKEN=your_granular_token
npm publish --access public
```

### Option 3: Use npm CLI with Automation Token

1. Create automation token at: https://www.npmjs.com/settings/hyperkitdev/tokens
2. Select "Automation" type (bypasses 2FA)
3. Use the token as above

### Option 4: Complete Browser Login

If interactive login is available:
1. Run `npm login`
2. Complete authentication in browser
3. Token will be saved automatically
4. Then run `npm publish --access public`

## Current Status

- ✅ Python SDK: Published to PyPI
- ⏳ TypeScript SDK: Waiting for npm authentication

## Quick Fix Command

If you have a granular token ready:

```bash
cd packages/sdk-ts
npm config set //registry.npmjs.org/:_authToken YOUR_GRANULAR_TOKEN
npm publish --access public
```

## Verify Publication

After publishing, verify:
```bash
npm view @hyperkitlab/erc1066-x402
```

Or check: https://www.npmjs.com/package/@hyperkitlab/erc1066-x402

