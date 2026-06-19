# Regles front — a coller dans le CLAUDE.md du projet

> Le garde-fou qui empeche le front de deriver. C'est le "Code Connect" du solo : zero CLI, zero plan payant. Adapter les chemins au projet.

## Stack
- Next + React, TypeScript, Tailwind v4, shadcn/ui dans `components/ui/`.

## Design tokens (obligatoire)
- Couleurs / spacing / radius depuis `globals.css` (variables CSS, nommees comme les Variables Figma). JAMAIS de hex brut, JAMAIS de valeur Tailwind arbitraire (`bg-[#...]`, `p-[13px]`, `leading-[22.1px]`).
- Spacing = echelle Tailwind. Radius via `--radius`.

## Composants (obligatoire)
- Utiliser shadcn/ui dans `components/ui/` AVANT de coder un composant custom. Pour tout composant Figma, prendre l'equivalent shadcn, jamais un clone.
- Pas de `any`. `cn()` pour les classnames.

## Workflow MCP Figma (ordre impose)
1. `get_design_context` (structure/layout) -> 2. `get_variable_defs` (tokens) -> 3. `get_screenshot` (reference visuelle) -> 4. coder en reutilisant `components/ui/`, aux tokens.
- Composant par composant, jamais l'ecran entier d'un coup.
- Icones : SVG du projet (lucide), jamais demandees au MCP.

## Qualite (non-negociable)
- Etats erreur / vide / chargement DES le build. A11y (contraste AA, focus visible, touch >= 44px). Micro-animations sobres (Motion, 150-300ms).
- Anti-slop : pas de pilules (radius sobre), pas de bordures epaisses / tout-encadre, pas de gradients, pas de blur, pas d'ombres molles, pas d'em dashes, pas d'emojis en puces. Si un ecran pourrait etre celui de 20 startups, recommencer.
