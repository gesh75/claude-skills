# Data Fetching Patterns

Portable, library-agnostic conventions for fetching data in React. (The Suspense-first model below works with React Query's `useSuspenseQuery`, SWR's `suspense` mode, or React `use()` with a Suspense boundary.)

## Suspense-First (preferred for client data)

Prefer Suspense boundaries over per-component `isLoading` ladders. This removes early-return spinners and keeps render logic linear.

```tsx
// PASS: data resolves via Suspense — no isLoading branch in the component
function MarketPanel({ id }: { id: number }) {
  const { data } = useSuspenseQuery({
    queryKey: ['market', id],
    queryFn: () => marketApi.getMarket(id),
  })
  return <MarketView market={data} />
}

// Boundary supplies the fallback (and an error boundary catches failures)
<ErrorBoundary fallback={<MarketError />}>
  <Suspense fallback={<MarketSkeleton />}>
    <MarketPanel id={id} />
  </Suspense>
</ErrorBoundary>
```

Avoid:

- `isLoading` conditionals and manual spinners scattered inside leaf components
- Inline `fetch`/`axios` calls written directly in components
- Untyped responses — always type the returned data

## Isolate the data layer

Keep network access out of components. Put it in a dedicated API module per feature/domain:

- One API file per feature (`features/{name}/api/`), exported through the feature's `index.ts`.
- Components call typed API functions; they never construct requests inline.
- This makes data access mockable in tests and swappable behind one interface (repository pattern).

## Loading & error handling rule

- Lean on Suspense boundaries for loading state and Error Boundaries for failures, placed at the route or feature root.
- Surface user feedback through one consistent notification mechanism rather than mixing several toast libraries.
