# Installation de code-review-graph

## Prérequis
- Python 3.10 ou supérieur
- pip (gestionnaire de paquets Python)
- Git (pour les mises à jour incrémentales)

## Installation du plugin

### Méthode 1: Installation simple
```bash
pip install code-review-graph
```

### Méthode 2: Installation avec virtualenv (recommandé)
```bash
# Créer un environnement virtuel
python -m venv venv

# Activer l'environnement
source venv/bin/activate  # Linux/macOS
# ou
venv\Scripts\activate     # Windows

# Installer le plugin
pip install code-review-graph
```

### Méthode 3: Installation globale
```bash
# Avec pipx (recommandé pour les outils CLI)
pipx install code-review-graph
```

## Vérification de l'installation
```bash
# Vérifier la version
code-review-graph --version

# Vérifier que la commande est disponible
which code-review-graph
```

## Configuration dans ai-dev-framework

### 1. Mise à jour du framework
```bash
# Dans le répertoire ai-dev-framework
git pull origin main
ai-framework update
```

### 2. Utilisation dans un projet
```bash
cd votre-projet
claude

# Tester le skill
/code-review-graph build
```

## Intégration avec les workflows

### map-project
Le workflow `/map-project` propose automatiquement de générer le graphe de dépendances à l'étape 4.6.

### code-reviewer
L'agent `code-reviewer` demande s'il doit utiliser code-review-graph avant chaque review pour réduire la consommation de tokens.

### add-feature
Le workflow `/add-feature` propose de valider l'impact des changements avec code-review-graph après l'implémentation.

### debug-issue
Le workflow `/debug-issue` propose d'analyser les dépendances des fichiers affectés avec code-review-graph.

## Première utilisation

### Étape 1: Construire le graphe initial
```bash
/code-review-graph build
```
- Analyse tout le codebase
- Crée le dossier `.code-review-graph/` avec les fichiers JSON
- Génère les visualisations HTML
- Temps: 1-5 minutes selon la taille du projet

### Étape 2: Ajouter à .gitignore
```bash
echo ".code-review-graph/" >> .gitignore
```

### Étape 3: Tester l'analyse d'impact
```bash
# Modifier un fichier
edit src/main.js

# Analyser l'impact
/code-review-graph impact src/main.js
```

## Commandes disponibles

| Commande | Description |
|----------|-------------|
| `/code-review-graph build` | Construit le graphe de dépendances complet |
| `/code-review-graph update` | Met à jour incrémentalement le graphe |
| `/code-review-graph impact <fichier>` | Analyse l'impact d'un changement |
| `/code-review-graph visualize` | Génère une visualisation interactive |

## Dépannage

### Problème: "ModuleNotFoundError: No module named 'code_review_graph'"
```bash
# Réinstaller le plugin
pip install --upgrade code-review-graph

# Vérifier le chemin Python
python -c "import sys; print(sys.executable)"
```

### Problème: "Command 'code-review-graph' not found"
```bash
# Ajouter le chemin de pip au PATH
export PATH="$HOME/.local/bin:$PATH"

# Ou réinstaller avec --user
pip install --user code-review-graph
```

### Problème: "Python 3.10+ required"
```bash
# Vérifier la version
python --version

# Mettre à jour Python si nécessaire
# Sur Ubuntu/Debian:
sudo apt update
sudo apt install python3.10 python3.10-venv
```

### Problème: Permission denied
```bash
# Utiliser --user flag
pip install --user code-review-graph

# Ou utiliser virtualenv
python -m venv venv
source venv/bin/activate
pip install code-review-graph
```

## Performance

### Taille du codebase vs temps de build
- 100 fichiers: ~30 secondes
- 500 fichiers: ~2 minutes
- 1000 fichiers: ~4 minutes
- 5000 fichiers: ~20 minutes

### Taille du dossier .code-review-graph
- 100 fichiers: ~5 MB
- 500 fichiers: ~25 MB
- 1000 fichiers: ~50 MB

## Conseils

1. **Premier build**: Lancez-le pendant une pause ou la nuit pour les grands projets
2. **Mises à jour incrémentales**: Presque instantanées après le build initial
3. **Visualisation**: Utile pour comprendre l'architecture du projet
4. **Review**: Jusqu'à 6.8× moins de tokens consommés

## Support
- Documentation officielle: https://github.com/tirth8205/code-review-graph
- Issues: https://github.com/tirth8205/code-review-graph/issues
- Intégration ai-dev-framework: KillianPiccerelle/ai-dev-framework

---

**Note:** Le plugin code-review-graph est un outil tiers. ai-dev-framework fournit uniquement l'intégration, pas le plugin lui-même.