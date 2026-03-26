---
name: stack-advisor
description: >
  Recommande une stack technique adaptée au projet en cours.
  Lit memory/project-context.md et produit memory/stack.md.
  Invoquer avec /stack-advisor au démarrage d'un projet.
tags: [architecture, stack, setup]
---

Lis memory/project-context.md avant de commencer.

Pose ces questions à l'utilisateur si les réponses ne sont pas dans le contexte :
- Quel type d'application ? (SaaS, API pure, app IA, fullstack, mobile backend)
- Quelles contraintes de performance ? (latence, volume de données, utilisateurs simultanés)
- Quelles sont les compétences techniques de l'équipe ?
- Quel est le budget infrastructure mensuel estimé ?
- Quelle est la date cible pour la v1 ?

Une fois les informations collectées, applique la matrice de décision
décrite dans l'agent stack-advisor et produis memory/stack.md avec ce format :

# Stack technique — [Nom du projet]

## Résumé des choix

| Couche | Choix | Raison principale |
|--------|-------|-------------------|
| Runtime | ... | ... |
| Framework | ... | ... |
| Base de données | ... | ... |
| Auth | ... | ... |
| Tests | ... | ... |
| Déploiement | ... | ... |

## Détail des décisions

### [Couche]
Choix retenu : [technologie]
Justification : [pourquoi ce choix est adapté à CE projet]
Alternatives rejetées : [ce qui a été considéré et pourquoi c'est écarté]

[Répéter pour chaque couche]

## Points d'attention
[Risques ou décisions à reconsidérer si le contexte change]
