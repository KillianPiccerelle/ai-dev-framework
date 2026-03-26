#!/usr/bin/env node
// Avertit avant les commandes destructives
const cmd = process.argv[2] || '';
const dangerous = [
  { pattern: /rm\s+-rf/, label: 'Suppression récursive forcée' },
  { pattern: /DROP\s+TABLE/i, label: 'Suppression de table SQL' },
  { pattern: /DROP\s+DATABASE/i, label: 'Suppression de base de données' },
  { pattern: /git push --force/, label: 'Push force Git' },
];
const found = dangerous.find(d => d.pattern.test(cmd));
if (found) {
  console.error(`[safety-guard] ATTENTION : ${found.label} détectée.`);
  console.error(`[safety-guard] Commande : ${cmd}`);
  console.error(`[safety-guard] Confirme que c'est intentionnel avant de continuer.`);
}
