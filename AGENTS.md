# AGENTS.md — mXMLConverter-boilerplate (Codex Agent)
@ARCHITECTURE.md

## Mission
Références de vérité (ne pas lire par défaut ; n’ouvrir que si nécessaire)
- README.md : description du projet
- TODO.md : jalons à implémenter, ignore les autres fichier qui commence par TODO*.md sauf demande explicite.

## Contexte & quotas (TRÈS IMPORTANT)
- Ne scanne jamais tout le repo.
- Ignore toujours : build*/, dist/, node_modules/, .git/, assets/, docs/ (sauf demande explicite).

## regles de codage
@BEST-PRACTICES.md
- Eviter les magic number et les valeur en dur pour rafistoler, demander a l'utilisateur

## Politique de réponse (éviter la verbosité)
- Toujours donner un plan 3–6 étapes avant de modifier du code.
- Donne moi dans un topic séparé les fichiers que tu as ouvert en lecture

## Workflow obligatoire (à chaque requête)
1) Résumer le but
2) Lister les fichiers à modifier + pourquoi.
3) Proposer un plan.
4) Donner une commande de validation à lancer.

## Commandes de validation (choisir la plus pertinente)
voir README.md
Apres validation, tu commit uniquement tes changements

## Règles de modif (sécurité du design)
- Toute nouvelle structure doit être testable (petites fonctions, pas de singleton).
- Pas d'ajout de dépendances externes sans demande explicite.
- Bien commenter les fonctions, methodes, blocs boucle et condition.
- Pas de modification dans third_party/mxmlconverter/

## Fin de tâche
- Résumer : fichiers modifiés + raison + prochaine étape.
- Si une TODO est bouclée, cocher dans TODO.md. Ne pas purger le todo des sous taches, juste cocher, commiter, puis proposer la feature suivante a implémenter.
