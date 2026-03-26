# ai-dev-framework (source)

> Repo source privé — contient les versions FR et EN du framework.
> Ne pas publier directement. Utiliser `./scripts/publish.sh` pour générer les repos publics.

**Auteur:** [KillianPiccerelle](https://github.com/KillianPiccerelle)

---

## Repos publics générés

| Repo | Langue | URL |
|------|--------|-----|
| ai-dev-framework-fr | Français | https://github.com/KillianPiccerelle/ai-dev-framework-fr |
| ai-dev-framework-en | English  | https://github.com/KillianPiccerelle/ai-dev-framework-en |

---

## Travailler sur le framework

Toutes les modifications se font ici, dans ce repo source.
Chaque fichier existe en double : `agents/fr/` et `agents/en/`, etc.

Quand tu modifies un agent ou un skill, mets à jour les deux versions
dans le même commit pour garder les deux langues en sync.

## Publier une mise à jour

```bash
# Publier les deux langues
./scripts/publish.sh

# Publier uniquement le français
./scripts/publish.sh fr

# Publier uniquement l'anglais
./scripts/publish.sh en
```

## Structure du repo source

```
ai-dev-framework/        ← ce repo (privé)
├── agents/
│   ├── fr/              ← agents en français
│   └── en/              ← agents en anglais
├── skills/
│   ├── fr/              ← skills en français
│   └── en/              ← skills en anglais
├── workflows/
│   ├── fr/              ← workflows en français
│   └── en/              ← workflows en anglais
├── memory/
│   ├── fr/              ← templates mémoire en français
│   └── en/              ← templates mémoire en anglais
├── templates/           ← templates de projets (neutres)
├── hooks/               ← automations (neutres)
├── prompts/
│   ├── fr/
│   └── en/
├── docs/
│   ├── fr/
│   └── en/
└── scripts/
    ├── publish.sh       ← génère et pousse les repos publics
    └── init-project.sh  ← initialise un nouveau projet
```

## Ajouter un agent

1. Créer `agents/fr/nom-agent.md`
2. Créer `agents/en/nom-agent.md`
3. Mettre à jour `docs/fr/agents.md` et `docs/en/agents.md`
4. Lancer `./scripts/publish.sh`

## Ajouter un skill

1. Créer `skills/fr/domaine/nom/SKILL.md`
2. Créer `skills/en/domaine/nom/SKILL.md`
3. Lancer `./scripts/publish.sh`
