---
name: radix-ui-design-system
description: Build accessible design systems with Radix UI primitives. Headless component customization, theming strategies, and compound component patterns for production-grade UI libraries.
risk: safe
source: self
---

# Radix UI Design System

Unstyled, accessible primitives. Full styling control. WAI-ARIA compliant by default.

## Install
```bash
npm install @radix-ui/react-dialog @radix-ui/react-dropdown-menu  # individual
npm install @radix-ui/themes                                        # full suite
```

## Base Component Pattern
```tsx
import * as Dialog from '@radix-ui/react-dialog'

export function Modal({ title, children }: Props) {
  return (
    <Dialog.Root>
      <Dialog.Trigger asChild><Button>Open</Button></Dialog.Trigger>
      <Dialog.Portal>
        <Dialog.Overlay className="fixed inset-0 bg-black/50" />
        <Dialog.Content className="fixed top-1/2 left-1/2 -translate-x-1/2 -translate-y-1/2 bg-white p-6 rounded-lg">
          <Dialog.Title>{title}</Dialog.Title>
          {children}
          <Dialog.Close asChild><Button variant="ghost">Close</Button></Dialog.Close>
        </Dialog.Content>
      </Dialog.Portal>
    </Dialog.Root>
  )
}
```

## Theming with CSS Variables
```css
:root {
  --color-primary: #0070f3;
  --radius-md: 6px;
  --space-4: 16px;
}
[data-theme="dark"] {
  --color-primary: #60a5fa;
}
```

## Key Primitives Reference
| Component | Import | Use for |
|---|---|---|
| Dialog | `@radix-ui/react-dialog` | Modals, drawers |
| DropdownMenu | `@radix-ui/react-dropdown-menu` | Action menus |
| Select | `@radix-ui/react-select` | Custom selects |
| Tabs | `@radix-ui/react-tabs` | Tab navigation |
| Toast | `@radix-ui/react-toast` | Notifications |
| Tooltip | `@radix-ui/react-tooltip` | Hover hints |
| Popover | `@radix-ui/react-popover` | Floating panels |
| Accordion | `@radix-ui/react-accordion` | Collapsible sections |

## `asChild` Pattern — Merge Props Without Extra DOM Node
```tsx
<Dialog.Trigger asChild>
  <Button>Open</Button>   {/* Button renders, not a Radix button wrapper */}
</Dialog.Trigger>
```

## Accessibility Checklist
- [ ] All interactive elements reachable by keyboard
- [ ] Focus trapped inside open modals/dialogs
- [ ] `aria-label` on icon-only buttons
- [ ] Color contrast ≥ 4.5:1 (WCAG AA)
- [ ] Reduced motion: wrap animations in `@media (prefers-reduced-motion: no-preference)`
