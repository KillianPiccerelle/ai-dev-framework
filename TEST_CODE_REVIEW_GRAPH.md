# Test de l'intégration code-review-graph

## Objectif
Valider que l'intégration de code-review-graph fonctionne correctement dans ai-dev-framework v3.

## Prérequis
- Python ≥3.10
- `pip install code-review-graph`
- Un projet test avec code Git (par exemple `wave-agent-build`)

## Étapes de test

### 1. Mise à jour du framework
```bash
# Dans le répertoire ai-dev-framework
git add .
git commit -m "feat: integrate code-review-graph with workflows and code-reviewer agent"
git push origin main

# Mettre à jour le framework globalement
ai-framework update
```

### 2. Initialisation sur un projet test
```bash
cd ~/wave-agent-build
ai-framework init
claude
```

### 3. Test du workflow map-project avec code-review-graph
```bash
# Dans Claude Code
/map-project
```
**Vérifier:**
- [ ] Le workflow propose l'option "Generate structural dependency graph with code-review-graph?"
- [ ] Si code-review-graph n'est pas installé, propose l'installation
- [ ] Le skill `/code-review-graph build` s'exécute correctement
- [ ] Crée le dossier `.code-review-graph/` avec les fichiers JSON
- [ ] Affiche l'estimation de réduction de tokens

### 4. Test du skill directement
```bash
# Dans Claude Code
/code-review-graph build
/code-review-graph visualize
/code-review-graph impact src/main.js
/code-review-graph update
```

### 5. Test du code-reviewer avec graph
```bash
# Créer une modification de test
echo "// Test change" >> src/test.js

# Lancer la review
/code-reviewer
```
**Vérifier:**
- [ ] L'agent demande s'il doit utiliser code-review-graph
- [ ] Identifie les fichiers impactés via `git diff --name-only`
- [ ] Utilise `/code-review-graph impact` pour obtenir le rayon d'impact
- [ ] Ne review que les fichiers dans le rayon d'impact
- [ ] Rapporte la réduction de tokens estimée

### 6. Test du workflow add-feature
```bash
/add-feature
```
**Vérifier:**
- [ ] Propose "Validate change impact with code-review-graph?" après l'implémentation
- [ ] Exécute `/code-review-graph impact` sur les fichiers modifiés
- [ ] Met à jour le graph incrémentalement avec `/code-review-graph update`

### 7. Test du workflow debug-issue
```bash
/debug-issue
```
**Vérifier:**
- [ ] Propose "Analyze dependencies of affected files with code-review-graph?"
- [ ] Utilise le graph pour tracer les dépendances transitives

## Validation finale

### Résultats attendus
- ✅ Skill `/code-review-graph` disponible avec 4 commandes
- ✅ Intégration dans 3 workflows (`map-project`, `add-feature`, `debug-issue`)
- ✅ Agent `code-reviewer` utilise le graph pour réduire les tokens
- ✅ Documentation mise à jour (10 skills au lieu de 9)
- ✅ Toutes les modifications sont commitées et pushées

### Métriques de succès
- Réduction de tokens: 6.8× (par rapport à la review complète)
- Temps de build initial: <5 minutes pour 1000 fichiers
- Mises à jour incrémentales: <30 secondes
- Visualisation interactive: fonctionne dans le navigateur

## Dépannage

### Erreur: "command not found: code-review-graph"
```bash
pip install code-review-graph
```

### Erreur: "Python ≥3.10 required"
```bash
python --version
# Mettre à jour Python si nécessaire
```

### Erreur: "Not a git repository"
```bash
git init
git add .
git commit -m "Initial commit"
```

### Le graph ne se construit pas
```bash
# Vérifier les permissions
ls -la .code-review-graph/

# Forcer la reconstruction
rm -rf .code-review-graph/
/code-review-graph build
```

## Notes
- Le premier build peut prendre plusieurs minutes sur un grand codebase
- Ajouter `.code-review-graph/` à `.gitignore`
- Les visualisations HTML peuvent être partagées avec l'équipe
- La réduction de tokens est estimée, réelle peut varier selon la complexité

---

**Statut:** Prêt pour test sur `wave-agent-build`