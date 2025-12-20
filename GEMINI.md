include @AGENTS.md

## RÈGLE CRITIQUE — ÉDITION DE FICHIERS (ANTI-TRONCATURE)
- Interdiction de réécrire un fichier complet (pas de `write_file`, pas de remplacement global, pas de suppression/recréation) dès qu’un fichier dépasse ~200 lignes ou si tu n’as pas son contenu intégral.
- Tu dois travailler exclusivement via un **unified diff** minimal (format git complet : `diff --git` + `---/+++` + hunks `@@`), limité à **≤ 40 lignes modifiées**, sans reformat.
- Si tu manques de contexte : **arrête-toi** et demande-moi 1–2 **plages de lignes** précises (ex: `nl -ba file | sed -n '240,340p'`). Ne “devine” jamais le contenu manquant.
- Ne tente jamais d’ouvrir/lire les fichiers d’output (SVG/PNG) pour valider : validation = exit code + logs + tests.
- Si un diff ne s’applique pas proprement (conflit/contexte manquant), ne “corrige” pas en réécrivant : demande une nouvelle plage de lignes et régénère le diff.
- Ne propose jamais de patch qui modifie plus de 1 fichier “gros” à la fois (>200 lignes) ; traiter fichier par fichier.