# ai-dev-framework — Repo source

## Contexte
Ce repo est le repo source privé du framework ai-dev-framework.
Il contient les versions FR et EN de tous les fichiers.

## Règles de travail sur ce repo

Chaque fichier doit exister en deux versions : `dossier/fr/` et `dossier/en/`.
Quand tu modifies un agent ou un skill, mets à jour les deux langues
dans le même commit.

## Publier une mise à jour

```bash
./scripts/publish.sh        # publie FR et EN
./scripts/publish.sh fr     # publie uniquement FR
./scripts/publish.sh en     # publie uniquement EN
```

## Ajouter un agent

1. Créer `agents/fr/nom-agent.md`
2. Créer `agents/en/nom-agent.md`
3. Mettre à jour `docs/fr/adding-agent.md` et `docs/en/adding-agent.md`
4. `./scripts/publish.sh`

## Ajouter un skill

1. Créer `skills/fr/domaine/nom/SKILL.md`
2. Créer `skills/en/domaine/nom/SKILL.md`
3. `./scripts/publish.sh`

## Structure des repos publics générés

ai-dev-framework-fr → https://github.com/KillianPiccerelle/ai-dev-framework-fr
ai-dev-framework-en → https://github.com/KillianPiccerelle/ai-dev-framework-en

Le script publish.sh extrait la version de la langue et pousse
vers le repo public correspondant.
