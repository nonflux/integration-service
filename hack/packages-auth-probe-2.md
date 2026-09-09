(node:917) [UNDICI-EHPA] Warning: EnvHttpProxyAgent is experimental, expect them to change at any time.
(Use `node --trace-warnings ...` to show where the warning was created)
# packages-auth-probe-2 (in-sandbox, node fetch)
date: 2026-09-09T18:44:53.700Z
GH_TOKEN prefix=ghs_ len=390; GITHUB_TOKEN set=no; node v22.22.1
- anon metadata -> HTTP 401; body: {"error":"authentication token not provided"}
- anon download -> HTTP 401; body: {"error":"authentication token not provided"}
- GH_TOKEN metadata -> HTTP 403; body: {"error":"Permission installation not allowed to Read organization package"}
- GH_TOKEN download -> HTTP 403; body: {"error":"Permission installation not allowed to Read organization package"}
done
