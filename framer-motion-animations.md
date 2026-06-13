---
name: framer-motion-animations
description: Master variants, gestures, layout animations, scroll effects, and exit animations in React.
author: Claude Skills 360
date: 2026-03-17
---

# Framer Motion Animations

> **Package note:** Framer Motion was renamed to **`motion`** (v11+). Install `npm i motion`
> and import from `motion/react` (e.g. `import { motion, AnimatePresence, useScroll, useTransform } from "motion/react"`).
> The legacy `framer-motion` package still works as an alias, but new projects should use `motion`.
> The API below is unchanged across the rename.

## Variants (reusable animation states)
```tsx
const container = {
  hidden: { opacity: 0 },
  visible: { opacity: 1, transition: { staggerChildren: 0.1 } }
}
const item = {
  hidden: { opacity: 0, y: 20 },
  visible: { opacity: 1, y: 0 }
}
<motion.ul variants={container} initial="hidden" animate="visible">
  <motion.li variants={item}>One</motion.li>
```

## Gestures
```tsx
<motion.button
  whileHover={{ scale: 1.05 }}
  whileTap={{ scale: 0.95 }}
  drag="x"
  dragConstraints={{ left: -100, right: 100 }}
/>
```

## Layout Animation (shared element)
```tsx
<motion.div layoutId="card-1" />   {/* same layoutId = morphing transition */}
```

## Scroll-Triggered
```tsx
const { scrollYProgress } = useScroll()
const opacity = useTransform(scrollYProgress, [0, 0.5], [0, 1])
<motion.div style={{ opacity }} />

// In-view trigger:
<motion.div
  initial={{ opacity: 0, y: 30 }}
  whileInView={{ opacity: 1, y: 0 }}
  viewport={{ once: true, margin: "-100px" }}
/>
```

## Exit Animations
```tsx
<AnimatePresence mode="wait">
  {isVisible && (
    <motion.div
      key="modal"
      initial={{ opacity: 0, scale: 0.95 }}
      animate={{ opacity: 1, scale: 1 }}
      exit={{ opacity: 0, scale: 0.95 }}
      transition={{ duration: 0.2 }}
    />
  )}
</AnimatePresence>
```

## Performance Tips
- Use `will-change: transform` for GPU-accelerated animations
- Prefer `transform` and `opacity` — avoid animating `width`/`height`/`top`/`left`
- Wrap with `<LazyMotion>` + `domAnimation` to reduce bundle size
- `useReducedMotion()` hook to respect accessibility preferences
