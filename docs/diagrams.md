# Skills — Diagrammes visuels

## /init-project

Initialisation complete d'un nouveau projet en 6 phases sequentielles.

```mermaid
flowchart TD
    START([Vincent : "nouveau projet"]) --> P1

    subgraph P1["Phase 1 — Decouverte"]
        Q1[Le probleme] --> Q2[Les utilisateurs]
        Q2 --> Q3[Le scope MVP]
        Q3 --> Q4[Les contraintes]
        Q4 --> Q5[Le business]
        Q5 --> RESUME[Resume structure]
    end

    P1 -->|Vincent valide| P2

    subgraph P2["Phase 2 — Stack"]
        ANALYSE[Analyse du projet] --> RESEARCH[Recherche web]
        RESEARCH --> RECO[Stack recommandee + alternatives ecartees]
    end

    P2 -->|Vincent valide| P3

    subgraph P3["Phase 3 — Vision & Roadmap"]
        VISION[docs/vision-produit.md] --> ROAD[Roadmap par phases]
        ROAD --> PH0[Phase 0 : Direction Artistique]
        ROAD --> PH1[Phase 1 : Fondations]
        ROAD --> PHN[Phase 2+ : Features]
    end

    P3 -->|Vincent valide| P4

    subgraph P4["Phase 4 — Installation preset"]
        direction LR
        CLAUDE_MD[CLAUDE.md] ~~~ RULES[rules/ x7]
        RULES ~~~ AGENTS[agents/ x8]
        AGENTS ~~~ SKILLS_P[skills/]
        SKILLS_P ~~~ CONTEXTS[contexts/ x3]
        CONTEXTS ~~~ DESIGN[DESIGN.md]
    end

    P4 --> P5

    subgraph P5["Phase 5 — Init technique"]
        DEPS[Installer stack] --> CONFIG[Config TS + linter + formatter]
        CONFIG --> STRUCT[Structure src/]
        STRUCT --> CHECK["Build + lint OK ?"]
    end

    P5 --> P6

    subgraph P6["Phase 6 — GitHub"]
        COMMIT["chore: initial setup"] --> REPO["gh repo create --private"]
        REPO --> PROTECT[Branch protection main]
    end

    P6 --> DONE([Projet pret])

    style START fill:#f9a825,color:#000
    style DONE fill:#43a047,color:#fff
    style P1 fill:#e3f2fd,stroke:#1565c0
    style P2 fill:#e8f5e9,stroke:#2e7d32
    style P3 fill:#fff3e0,stroke:#e65100
    style P4 fill:#f3e5f5,stroke:#6a1b9a
    style P5 fill:#e0f7fa,stroke:#00695c
    style P6 fill:#fce4ec,stroke:#b71c1c
```

---

## /design-flow

Pipeline UI en 5 etapes. Gate humaine au Visual Review — Claude propose, Vincent decide.

```mermaid
flowchart TD
    START([Page ou composant a construire]) --> E0

    subgraph E0["Etape 0 — Brief"]
        AUDIENCE[Audience] --> ACTION[Action primaire + CTA]
        ACTION --> PRIO[Priorite de contenu]
        PRIO --> CONSTRAINTS[Contraintes DESIGN.md + ui/]
    end

    E0 --> E1

    subgraph E1["Etape 1 — Build"]
        direction TB
        READ_DS["Lire DESIGN.md + ui/\n+ pages existantes"] --> BUILD[Construire l'interface]
        BUILD --> SLOP{"Anti-slop check\nCTA visible ? Hierarchie claire ?\nSpecifique au produit ?"}
        SLOP -->|Non| BUILD
    end

    E1 --> E2

    subgraph E2["Etape 2 — Visual Review"]
        direction TB
        LAUNCH["Lancer localhost\nOuvrir dans le navigateur"] --> PASSES["3 passes :\nA. Structure & emphase\nB. Typo & contenu\nC. Finish & etats"]
        PASSES --> RECO_VR["Recommandations presentees\nCODE NON MODIFIE"]
    end

    RECO_VR --> GATE_H{"Vincent decide"}
    GATE_H -->|"ok fais tout"| APPLY[Appliquer corrections]
    GATE_H -->|"feedback specifique"| APPLY
    GATE_H -->|"je prefere comme ca"| E3

    APPLY --> E2

    subgraph E3["Etape 3 — Technical Audit"]
        direction TB
        A11Y[a11y WCAG AA] --> PERF[Performance]
        PERF --> RESP[Responsive 375/768/1440]
        RESP --> ANTI[Anti-patterns]
    end

    E3 --> E4

    subgraph E4["Etape 4 — Release Gate"]
        direction TB
        CHECK_BRIEF[Brief respecte ?] --> CHECK_DS[Design system respecte ?]
        CHECK_DS --> CHECK_COH[Coherent avec le projet ?]
        CHECK_COH --> CHECK_AUDIT[Audit PASS ?]
        CHECK_AUDIT --> CHECK_VINCENT[Vincent a valide ?]
    end

    E4 --> VERDICT{"Verdict"}
    VERDICT -->|READY| DONE([Ship it])
    VERDICT -->|WITH WARNINGS| DONE_W([Ship avec warnings])
    VERDICT -->|NOT READY| E1

    style START fill:#f9a825,color:#000
    style DONE fill:#43a047,color:#fff
    style DONE_W fill:#ff9800,color:#000
    style GATE_H fill:#ff5722,color:#fff
    style E0 fill:#fff9c4,stroke:#f57f17
    style E1 fill:#e3f2fd,stroke:#1565c0
    style E2 fill:#f3e5f5,stroke:#6a1b9a
    style E3 fill:#fce4ec,stroke:#b71c1c
    style E4 fill:#e8f5e9,stroke:#2e7d32
```

---

## /feature

Harness multi-agent pour les features complexes. Double review Codex + Opus a chaque etage.

```mermaid
flowchart TD
    DETECT{"Detection auto :\n> 3 etapes OU 4+ fichiers\nOU nouvelle page/route\nOU code sensible"} -->|Oui| CONFIRM[Demander confirmation Vincent]

    CONFIRM -->|OK| ARCH

    subgraph ARCH["1. ARCHITECT — Opus"]
        PLAN["plan.md + contrat-qualite.md"]
    end

    ARCH --> CODEX_PLAN

    subgraph CODEX_PLAN["2. CODEX — Challenge du plan"]
        CHALLENGE["Challenge le plan\nfaisabilite, risques, alternatives"]
    end

    CODEX_PLAN --> VALID[3. Vincent valide le plan]

    VALID --> UI_CHECK{UI detectee ?}
    UI_CHECK -->|Oui| DESIGN_FLOW
    UI_CHECK -->|Non| DEV

    subgraph DESIGN_FLOW["4. /design-flow"]
        DF_BRIEF[Brief] --> DF_BUILD[Build]
        DF_BUILD --> DF_REVIEW["Visual Review\n+ gate humaine"]
        DF_REVIEW --> DF_AUDIT[Audit + Release Gate]
    end

    DESIGN_FLOW --> DEV

    subgraph DEV["5. DEVELOPER — Opus"]
        WORKTREE["Git worktree isole"] --> IMPL[Implemente + tests + commit]
    end

    DEV --> CODEX_REVIEW

    subgraph CODEX_REVIEW["6. CODEX — Code review"]
        CR["Review qualite du code\nRead-only"]
    end

    CODEX_REVIEW --> DEV_FIX[7. DEVELOPER integre feedback]
    DEV_FIX --> QA

    subgraph QA["8. QA — Opus"]
        CHECKS["typecheck + lint\ntests + build + review"]
        CHECKS --> VERDICT_QA{PASS ?}
    end

    VERDICT_QA -->|FAIL| CODEX_DIAG["CODEX diagnostique"] --> DEV
    VERDICT_QA -->|"3x FAIL"| ESCALADE([Escalade a Vincent])

    VERDICT_QA -->|PASS| VERIFY

    subgraph VERIFY["9. VERIFY-APP — Opus"]
        CU["Computer Use + screenshots"]
        CU --> VISUAL{Problemes visuels ?}
    end

    VISUAL -->|Oui| DEV
    VISUAL -->|Non| SEC_CHECK{Code sensible ?}

    SEC_CHECK -->|Oui| SEC
    SEC_CHECK -->|Non| CODEX_FINAL

    subgraph SEC["10. SECURITY-AUDITOR — Opus"]
        OWASP[Audit OWASP Top 10]
    end

    SEC --> CODEX_FINAL

    subgraph CODEX_FINAL["11. CODEX — Adversarial review"]
        ADV["auth, data loss, race conditions\nrollback safety"]
    end

    CODEX_FINAL --> PR([12. PR creee automatiquement])

    style DETECT fill:#f9a825,color:#000
    style PR fill:#43a047,color:#fff
    style ESCALADE fill:#b71c1c,color:#fff
    style ARCH fill:#e3f2fd,stroke:#1565c0
    style CODEX_PLAN fill:#fff3e0,stroke:#e65100
    style CODEX_REVIEW fill:#fff3e0,stroke:#e65100
    style CODEX_FINAL fill:#fff3e0,stroke:#e65100
    style DEV fill:#e8f5e9,stroke:#2e7d32
    style QA fill:#fce4ec,stroke:#b71c1c
    style VERIFY fill:#f3e5f5,stroke:#6a1b9a
    style SEC fill:#e0f7fa,stroke:#00695c
    style DESIGN_FLOW fill:#fff9c4,stroke:#f57f17
```

---

## /take-your-time

Co-fondateur virtuel avec 2 modes.

```mermaid
flowchart TD
    TRIGGER{"Vincent demande :\nnouveau projet ? feature ?\n'challenge-moi' ? 'on reflechit' ?"}

    TRIGGER -->|Nouveau projet| MODE_P
    TRIGGER -->|Feature existante| MODE_F

    subgraph MODE_P["MODE PROJET — Creation from scratch"]
        direction TB
        S1P["Step 1 — L'etincelle\nL'idee, le probleme, la personne cible"]
        S1P -->|Challenge : vrai probleme ?| S2P
        S2P["Step 2 — Le marche\nRecherche web, concurrence, timing"]
        S2P -->|Challenge : pourquoi toi ?| S3P
        S3P["Step 3 — Le business\nMonetisation, couts, signal d'arret"]
        S3P -->|Challenge : qui paye ?| S4P
        S4P["Step 4 — Le produit\nMVP, parcours, features V1/V2/Jamais"]
        S4P -->|Challenge : scope realiste ?| S5P
        S5P["Step 5 — Synthese\ndocs/vision-produit.md"]
    end

    subgraph MODE_F["MODE FEATURE — Projet existant"]
        direction TB
        S1F["Step 1 — Le vrai besoin\nPourquoi ? Pourquoi vraiment ?"]
        S1F -->|Creuser 2x| S2F
        S2F["Step 2 — Challenge\nBlind spots, failure modes, over-engineering"]
        S2F -->|Direct, presque inconfortable| S3F
        S3F["Step 3 — Approches\n2-3 options, pros/cons, recommandation"]
        S3F -->|Prendre position| S4F
        S4F["Step 4 — Risques\nTech, UX, dette, effets de bord"]
        S4F --> S5F
        S5F["Step 5 — Plan & Validation\ndocs/features/[nom].md"]
    end

    MODE_P --> OUT_P([Vision produit solide])
    MODE_F --> OUT_F([Plan d'implementation valide])

    style TRIGGER fill:#f9a825,color:#000
    style OUT_P fill:#43a047,color:#fff
    style OUT_F fill:#43a047,color:#fff
    style MODE_P fill:#e3f2fd,stroke:#1565c0
    style MODE_F fill:#fff3e0,stroke:#e65100
```

---

## Vue d'ensemble — Quand utiliser quel skill

```mermaid
flowchart LR
    VINCENT([Vincent]) --> NEED{Besoin ?}

    NEED -->|"Nouveau projet\nfrom scratch"| INIT["/init-project\n6 phases"]
    NEED -->|"Reflechir, challenger\nposer les bases"| TYT["/take-your-time\nco-fondateur virtuel"]
    NEED -->|"Page, modale,\ncomposant UI"| DF["/design-flow\n5 etapes + gate humaine"]
    NEED -->|"Feature complexe\n4+ fichiers"| FEAT["/feature\nharness multi-agent"]

    INIT -.->|"Premiere feature UI"| DF
    TYT -.->|"Decision prise,\non implemente"| FEAT
    DF -.->|"Feature complete\navec backend"| FEAT

    style VINCENT fill:#f9a825,color:#000
    style INIT fill:#e3f2fd,stroke:#1565c0
    style TYT fill:#fff3e0,stroke:#e65100
    style DF fill:#f3e5f5,stroke:#6a1b9a
    style FEAT fill:#e8f5e9,stroke:#2e7d32
```
