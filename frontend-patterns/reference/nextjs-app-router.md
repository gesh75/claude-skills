# Next.js App Router

Principles for the Next.js App Router. Server Components are the default — start there, add `'use client'` only when you need interactivity. (Verified current against Next.js docs, 2026-06.)

## Server vs Client Components

Decision tree:

```
Does it need...?
│
├── useState, useEffect, event handlers, browser APIs
│   └── Client Component ('use client')
│
├── Direct data fetching, no interactivity
│   └── Server Component (default)
│
└── Both?
    └── Split: Server parent + Client child (pass data down as props)
```

| Type | Use for |
|------|---------|
| **Server** (default) | Data fetching, layout, static content, secrets/DB access |
| **Client** (`'use client'`) | Forms, buttons, stateful/interactive UI |

Keep `'use client'` at the leaves of the tree. A Server Component can render and pass data into Client children, but a Client Component cannot import a Server Component.

## Data Fetching

Fetch in Server Components by default; the cache strategy is set per-`fetch`:

```tsx
export default async function Page() {
  // Static — cached until manually invalidated (default; force-cache can be omitted)
  const staticData = await fetch('https://...', { cache: 'force-cache' })

  // Dynamic — refetched on every request
  const dynamicData = await fetch('https://...', { cache: 'no-store' })

  // ISR — cached with a 10s lifetime, then revalidated
  const isrData = await fetch('https://...', { next: { revalidate: 10 } })

  return <div>...</div>
}
```

| Pattern | Behavior |
|---------|----------|
| `cache: 'force-cache'` (default) | Static, cached at build / until invalidated |
| `next: { revalidate: N }` | ISR — time-based refresh every N seconds |
| `cache: 'no-store'` | Dynamic — fetched every request |

For direct DB access in a Server Component, use `import { unstable_noStore as noStore } from 'next/cache'` to opt a query out of caching.

Data flow by source:

| Source | Pattern |
|--------|---------|
| Database | Server Component fetch (or server action) |
| External API | `fetch` with the appropriate cache option |
| User input | Client state + server action |

## Routing — File Conventions

| File | Purpose |
|------|---------|
| `page.tsx` | Route UI |
| `layout.tsx` | Shared layout (persists across navigation) |
| `loading.tsx` | Suspense loading state |
| `error.tsx` | Error boundary (must be a Client Component) |
| `not-found.tsx` | 404 UI |

Route organization:

| Pattern | Use |
|---------|-----|
| Route groups `(name)` | Group routes without affecting the URL |
| Parallel routes `@slot` | Render multiple pages at the same level |
| Intercepting `(.)` | Modal overlays over an existing route |

## API Route Handlers

`route.ts` exports HTTP-method functions: `GET` (read), `POST` (create), `PUT`/`PATCH` (update), `DELETE` (remove).

- Validate input with Zod (or equivalent schema).
- Return proper HTTP status codes.
- Handle errors gracefully — never leak internal details.
- Use the Edge runtime when the handler has no Node-only dependencies.

## Caching Strategy

| Layer | Control |
|-------|---------|
| Request | `fetch` `cache` / `next` options |
| Data | `revalidate` time or cache tags |
| Full route | route segment config |

Revalidation methods:

| Method | Use |
|--------|-----|
| Time-based | `next: { revalidate: 60 }` |
| On-demand | `revalidatePath('/posts')` / `revalidateTag('tag')` |
| No cache | `cache: 'no-store'` |

## Server Actions

For form submissions, mutations, and revalidation triggers. Mark with `'use server'`, validate every input, return typed responses, and revalidate after writes:

```ts
'use server'

import { revalidatePath } from 'next/cache'
import { z } from 'zod'

export async function createTodo(_prev: { message: string }, formData: FormData) {
  const parsed = z.object({ todo: z.string().min(1) }).safeParse({
    todo: formData.get('todo'),
  })
  if (!parsed.success) return { message: 'Failed to create todo' }

  await db.todos.insert({ text: parsed.data.todo })
  revalidatePath('/')
  return { message: `Added todo ${parsed.data.todo}` }
}
```

## Performance

- **Images** — use `next/image`; set `priority` on above-the-fold images, provide a blur placeholder, and use responsive `sizes`.
- **Bundles** — dynamic-import heavy Client Components; route-based code splitting is automatic; inspect with the bundle analyzer.

## Metadata

| Type | Use |
|------|-----|
| Static `export const metadata` | Fixed per-route metadata |
| `generateMetadata` | Dynamic, per-route (async) metadata |

Essentials: `title` (50–60 chars), `description` (150–160 chars), Open Graph image, canonical URL.

## Anti-Patterns

| Don't | Do |
|-------|-----|
| `'use client'` everywhere | Server by default, client at the leaves |
| Fetch in Client Components | Fetch in Server Components / actions |
| Skip loading states | Use `loading.tsx` / Suspense |
| Ignore error boundaries | Use `error.tsx` |
| Ship large client bundles | Dynamic imports for heavy components |

## Project Structure

```
app/
├── (marketing)/        # route group — no URL segment
│   └── page.tsx
├── (dashboard)/
│   ├── layout.tsx      # dashboard-only layout
│   └── page.tsx
├── api/
│   └── [resource]/
│       └── route.ts    # route handlers
└── components/
    └── ui/
```
