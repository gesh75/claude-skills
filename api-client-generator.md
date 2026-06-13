---
name: api-client-generator
description: Auto-generate type-safe API clients from OpenAPI specs with error handling, retries, and caching.
category: Developer Tools
version: 1.0.0
---

# API Client Generator

## Generate from OpenAPI Spec
```bash
npx @openapitools/openapi-generator-cli generate \
  -i openapi.yaml \
  -g typescript-axios \
  -o ./src/api/generated \
  --additional-properties=supportsES6=true,withSeparateModelsAndApi=true
```

## Production Client Pattern
```typescript
import axios, { AxiosInstance } from 'axios'

class ApiClient {
  private http: AxiosInstance

  constructor(baseURL: string, token: string) {
    this.http = axios.create({ baseURL, timeout: 10000 })
    this.http.defaults.headers.common['Authorization'] = `Bearer ${token}`
    this.http.interceptors.response.use(null, this.handleError)
  }

  private async handleError(error: any) {
    if (error.response?.status === 401) { /* refresh token */ }
    if (error.response?.status === 429) {
      const retryAfter = error.response.headers['retry-after'] ?? 1
      await new Promise(r => setTimeout(r, retryAfter * 1000))
      return this.http.request(error.config)
    }
    throw error
  }
}
```

## Retry with Exponential Backoff
```typescript
async function withRetry<T>(fn: () => Promise<T>, maxRetries = 3): Promise<T> {
  for (let attempt = 0; attempt < maxRetries; attempt++) {
    try { return await fn() }
    catch (err: any) {
      if (attempt === maxRetries - 1 || err.response?.status < 500) throw err
      await new Promise(r => setTimeout(r, Math.pow(2, attempt) * 1000))
    }
  }
  throw new Error('Max retries exceeded')
}
```

## Response Caching
```typescript
const cache = new Map<string, { data: any; expires: number }>()

async function cachedGet(url: string, ttlMs = 60000) {
  const cached = cache.get(url)
  if (cached && Date.now() < cached.expires) return cached.data
  const data = await client.get(url)
  cache.set(url, { data, expires: Date.now() + ttlMs })
  return data
}
```
