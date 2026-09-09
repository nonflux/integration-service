# packages-auth-probe (in-sandbox)
date: 2026-09-09T18:32:57Z
token env: GH_TOKEN prefix=ghs_ len=390; GITHUB_TOKEN set=no
node: v22.22.1; npm: (node:905) [UNDICI-EHPA] Warning: EnvHttpProxyAgent is experimental, expect them to change at any time.
(Use `node --trace-warnings ...` to show where the warning was created)
11.11.0; corepack: 0.34.6
(node:918) [UNDICI-EHPA] Warning: EnvHttpProxyAgent is experimental, expect them to change at any time.
(Use `node --trace-warnings ...` to show where the warning was created); pnpm: /tmp/probe.sh: line 13: pnpm: command not found

## curl
- auth=none url=https://npm.pkg.github.com/@nvidia%2Fopenshell-sdk -> HTTP 000; curl-err: curl: (56) CONNECT tunnel failed, response 403
head: cannot open '/tmp/body' for reading: No such file or directory
  body:
- auth=none url=https://npm.pkg.github.com/download/@nvidia/openshell-sdk/0.0.106/placeholder -> HTTP 000; curl-err: curl: (56) CONNECT tunnel failed, response 403
head: cannot open '/tmp/body' for reading: No such file or directory
  body:
- auth=GH_TOKEN url=https://npm.pkg.github.com/@nvidia%2Fopenshell-sdk -> HTTP 000; curl-err: curl: (56) CONNECT tunnel failed, response 403
head: cannot open '/tmp/body' for reading: No such file or directory
  body:
- auth=GH_TOKEN url=https://npm.pkg.github.com/download/@nvidia/openshell-sdk/0.0.106/placeholder -> HTTP 000; curl-err: curl: (56) CONNECT tunnel failed, response 403
head: cannot open '/tmp/body' for reading: No such file or directory
  body:

## node fetch (same requests through node, the binary pnpm runs under)
(node:974) [UNDICI-EHPA] Warning: EnvHttpProxyAgent is experimental, expect them to change at any time.
(Use `node --trace-warnings ...` to show where the warning was created)
- auth=none url=https://npm.pkg.github.com/@nvidia%2Fopenshell-sdk -> fetch error: Error: Request was cancelled.
- auth=none url=https://npm.pkg.github.com/download/@nvidia/openshell-sdk/0.0.106/placeholder -> fetch error: Error: Request was cancelled.
- auth=GH_TOKEN url=https://npm.pkg.github.com/@nvidia%2Fopenshell-sdk -> fetch error: Error: Request was cancelled.
- auth=GH_TOKEN url=https://npm.pkg.github.com/download/@nvidia/openshell-sdk/0.0.106/placeholder -> fetch error: Error: Request was cancelled.

## pnpm (Kaiden layout: committed .npmrc with ${GITHUB_TOKEN}, GITHUB_TOKEN=$GH_TOKEN)
npm i -g pnpm@10.28.0 failed: npm notice npm error A complete log of this run can be found in: /sandbox/.npm/_logs/2026-09-09T18_32_58_134Z-debug-0.log
### pnpm /tmp/probe.sh: line 55: pnpm: command not found (requested 10.28.0)
- project .npmrc, GITHUB_TOKEN=$GH_TOKEN -> exit 127
- pnpm_config_//host/:_authToken env -> exit 127
npm i -g pnpm@latest failed: npm error the command again as root/Administrator. npm error A complete log of this run can be found in: /sandbox/.npm/_logs/2026-09-09T18_32_58_799Z-debug-0.log
### pnpm /tmp/probe.sh: line 55: pnpm: command not found (requested latest)
- project .npmrc, GITHUB_TOKEN=$GH_TOKEN -> exit 127
- pnpm_config_//host/:_authToken env -> exit 127

done
