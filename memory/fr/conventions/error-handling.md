# Gestion des erreurs

> Rempli par l'agent architect lors du workflow /new-project.

## Format des erreurs API
```json
{
  "error": {
    "code": "RESOURCE_NOT_FOUND",
    "message": "La ressource demandée n'existe pas.",
    "details": {}
  }
}
```

## Codes d'erreur HTTP
- 400 : données invalides (validation échouée)
- 401 : non authentifié
- 403 : non autorisé (authentifié mais sans permission)
- 404 : ressource inexistante
- 409 : conflit (ex: email déjà utilisé)
- 422 : données syntaxiquement correctes mais sémantiquement incorrectes
- 500 : erreur serveur inattendue (à logger, jamais exposer les détails)

## Règles
- Toujours retourner le même format d'erreur
- Les erreurs 500 sont loggées avec le stack trace complet côté serveur
- Les erreurs 500 ne retournent jamais le stack trace au client
- Les messages d'erreur sont en français côté client
