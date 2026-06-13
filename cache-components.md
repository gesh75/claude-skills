---
name: cache-components
description: Next.js 'use cache' directive API reference — cacheLife, cacheTag, unstable_cacheLife profiles, and cache invalidation patterns.
---

# Cache Components — Next.js Reference

## `'use cache'` Directive
```tsx
'use cache'                    // file-level
async function Comp() { 'use cache'; ... }  // function-level
'use cache: remote'            // platform remote cache only
```

## `cacheLife(profile)` — TTL Control
```tsx
import { cacheLife } from 'next/cache'
cacheLife('seconds')  // stale:0  revalidate:1    expire:1
cacheLife('minutes')  // stale:60 revalidate:60   expire:3600
cacheLife('hours')    // stale:300 revalidate:3600 expire:86400
cacheLife('days')     // stale:3600 revalidate:86400 expire:604800
cacheLife('weeks')    // stale:86400 revalidate:604800 expire:2592000
cacheLife({ stale: 30, revalidate: 120, expire: 3600 })  // custom
```

## `cacheTag(...tags)` — Tag-Based Invalidation
```tsx
import { cacheTag } from 'next/cache'
import { revalidateTag } from 'next/cache'

async function getData(id: string) {
  'use cache'
  cacheTag(`product-${id}`, 'products')
  return fetchProduct(id)
}

// Invalidate from server action / route handler:
revalidateTag('products')
```

## Subshell Caching Pattern
```tsx
// Wrap dynamic parts in Suspense to cache the static shell
export default async function Page() {
  'use cache'
  cacheLife('hours')
  return (
    <Layout>
      <StaticContent />
      <Suspense fallback={<Spinner />}>
        <DynamicSection />   {/* not cached */}
      </Suspense>
    </Layout>
  )
}
```

## Rules
- Cannot use `cookies()`, `headers()`, or `searchParams` inside cached functions
- Mutable objects passed as arguments are serialized at call time
- `'use cache'` on a layout caches all children unless they opt out
- Use `noStore()` inside a cached function to exclude specific data
