# Data Access & Caching

## Repository Pattern

```typescript
// Abstract data access logic
interface MarketRepository {
  findAll(filters?: MarketFilters): Promise<Market[]>
  findById(id: string): Promise<Market | null>
  create(data: CreateMarketDto): Promise<Market>
  update(id: string, data: UpdateMarketDto): Promise<Market>
  delete(id: string): Promise<void>
}

class SupabaseMarketRepository implements MarketRepository {
  async findAll(filters?: MarketFilters): Promise<Market[]> {
    let query = supabase.from('markets').select('*')

    if (filters?.status) {
      query = query.eq('status', filters.status)
    }

    if (filters?.limit) {
      query = query.limit(filters.limit)
    }

    const { data, error } = await query

    if (error) throw new Error(error.message)
    return data
  }

  // Other methods...
}
```

## Service Layer Pattern

```typescript
// Business logic separated from data access
class MarketService {
  constructor(private marketRepo: MarketRepository) {}

  async searchMarkets(query: string, limit: number = 10): Promise<Market[]> {
    // Business logic
    const embedding = await generateEmbedding(query)
    const results = await this.vectorSearch(embedding, limit)

    // Fetch full data
    const markets = await this.marketRepo.findByIds(results.map(r => r.id))

    // Sort by similarity
    return markets.sort((a, b) => {
      const scoreA = results.find(r => r.id === a.id)?.score || 0
      const scoreB = results.find(r => r.id === b.id)?.score || 0
      return scoreA - scoreB
    })
  }

  private async vectorSearch(embedding: number[], limit: number) {
    // Vector search implementation
  }
}
```

## Middleware Pattern

```typescript
// Request/response processing pipeline
export function withAuth(handler: NextApiHandler): NextApiHandler {
  return async (req, res) => {
    const token = req.headers.authorization?.replace('Bearer ', '')

    if (!token) {
      return res.status(401).json({ error: 'Unauthorized' })
    }

    try {
      const user = await verifyToken(token)
      req.user = user
      return handler(req, res)
    } catch (error) {
      return res.status(401).json({ error: 'Invalid token' })
    }
  }
}

// Usage
export default withAuth(async (req, res) => {
  // Handler has access to req.user
})
```

## Database Patterns

### Query Optimization

```typescript
// PASS: GOOD: Select only needed columns
const { data } = await supabase
  .from('markets')
  .select('id, name, status, volume')
  .eq('status', 'active')
  .order('volume', { ascending: false })
  .limit(10)

// FAIL: BAD: Select everything
const { data } = await supabase
  .from('markets')
  .select('*')
```

### N+1 Query Prevention

```typescript
// FAIL: BAD: N+1 query problem
const markets = await getMarkets()
for (const market of markets) {
  market.creator = await getUser(market.creator_id)  // N queries
}

// PASS: GOOD: Batch fetch
const markets = await getMarkets()
const creatorIds = markets.map(m => m.creator_id)
const creators = await getUsers(creatorIds)  // 1 query
const creatorMap = new Map(creators.map(c => [c.id, c]))

markets.forEach(market => {
  market.creator = creatorMap.get(market.creator_id)
})
```

### Transaction Pattern

```typescript
async function createMarketWithPosition(
  marketData: CreateMarketDto,
  positionData: CreatePositionDto
) {
  // Use Supabase transaction
  const { data, error } = await supabase.rpc('create_market_with_position', {
    market_data: marketData,
    position_data: positionData
  })

  if (error) throw new Error('Transaction failed')
  return data
}

// SQL function in Supabase
CREATE OR REPLACE FUNCTION create_market_with_position(
  market_data jsonb,
  position_data jsonb
)
RETURNS jsonb
LANGUAGE plpgsql
AS $$
BEGIN
  -- Start transaction automatically
  INSERT INTO markets VALUES (market_data);
  INSERT INTO positions VALUES (position_data);
  RETURN jsonb_build_object('success', true);
EXCEPTION
  WHEN OTHERS THEN
    -- Rollback happens automatically
    RETURN jsonb_build_object('success', false, 'error', SQLERRM);
END;
$$;
```

## Caching Strategies

### Redis Caching Layer

```typescript
class CachedMarketRepository implements MarketRepository {
  constructor(
    private baseRepo: MarketRepository,
    private redis: RedisClient
  ) {}

  async findById(id: string): Promise<Market | null> {
    // Check cache first
    const cached = await this.redis.get(`market:${id}`)

    if (cached) {
      return JSON.parse(cached)
    }

    // Cache miss - fetch from database
    const market = await this.baseRepo.findById(id)

    if (market) {
      // Cache for 5 minutes
      await this.redis.setex(`market:${id}`, 300, JSON.stringify(market))
    }

    return market
  }

  async invalidateCache(id: string): Promise<void> {
    await this.redis.del(`market:${id}`)
  }
}
```

### Cache-Aside Pattern

```typescript
async function getMarketWithCache(id: string): Promise<Market> {
  const cacheKey = `market:${id}`

  // Try cache
  const cached = await redis.get(cacheKey)
  if (cached) return JSON.parse(cached)

  // Cache miss - fetch from DB
  const market = await db.markets.findUnique({ where: { id } })

  if (!market) throw new Error('Market not found')

  // Update cache
  await redis.setex(cacheKey, 300, JSON.stringify(market))

  return market
}
```
