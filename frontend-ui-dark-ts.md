---
name: frontend-ui-dark-ts
description: Build dark-themed React applications using Tailwind CSS with custom theming, glassmorphism effects, and Framer Motion animations. Dashboards, admin panels, data-rich interfaces.
---

# Frontend UI — Dark Theme (TypeScript)

## Stack
React + TypeScript + Tailwind CSS + Framer Motion + shadcn/ui

## Theme Setup (tailwind.config.js)
```js
module.exports = {
  darkMode: 'class',
  theme: {
    extend: {
      colors: {
        surface: { DEFAULT: '#0f0f11', elevated: '#1a1a1f', border: '#2a2a32' },
        accent: { DEFAULT: '#6366f1', hover: '#818cf8' },
      },
      backdropBlur: { xs: '2px' },
    },
  },
}
```

## Glassmorphism Card
```tsx
<div className="
  bg-surface-elevated/60 backdrop-blur-md
  border border-surface-border/50 rounded-xl p-6
  shadow-xl shadow-black/20
">
  {children}
</div>
```

## Framer Motion Page Transition
```tsx
const variants = {
  hidden: { opacity: 0, y: 8 },
  visible: { opacity: 1, y: 0, transition: { duration: 0.3 } },
  exit: { opacity: 0, y: -8 }
}
<motion.div variants={variants} initial="hidden" animate="visible" exit="exit">
```

## Dark Data Table Pattern
```tsx
<table className="w-full text-sm">
  <thead className="text-zinc-400 border-b border-surface-border">
    <tr><th className="text-left py-3 px-4">Column</th></tr>
  </thead>
  <tbody className="divide-y divide-surface-border">
    <tr className="hover:bg-surface-elevated/50 transition-colors">
      <td className="py-3 px-4 text-zinc-100">Value</td>
    </tr>
  </tbody>
</table>
```

## Key Utilities
- Text hierarchy: `text-zinc-100` (primary) `text-zinc-400` (secondary) `text-zinc-600` (disabled)
- Borders: `border-surface-border` or `border-white/10`
- Hover states: always add `transition-colors duration-150`
- Focus rings: `focus-visible:ring-2 focus-visible:ring-accent`
