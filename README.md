# mxmlconverter-boilerplate

## Objectif

Ce projet est une implémentation de référence ("Reference Implementation") minimale et propre, démontrant l'intégration complète de **mXMLConverter** dans un environnement **Flutter** via **FFI** (Foreign Function Interface).

Il sert de base ("Template") pour le développement d'applications (Mobile, Desktop) utilisant le moteur de rendu mXMLConverter.

## Architecture

L'application suit une architecture en couches stricte pour séparer l'interface utilisateur du moteur C++ :

*   **Flutter UI (Widgets)** : Interface utilisateur.
*   **Controller** : Gestion de l'état (Chargement, Erreur, Lecture).
*   **mXML Bridge (Dart)** : Interface Dart cachant la complexité de FFI.
*   **dart:ffi** : Pont vers le code natif.
*   **C-API Wrapper** : Interface C exposant les fonctionnalités de mXMLConverter.
*   **mXMLConverter (C++ Core)** : Moteur de conversion et de rendu.

## Fonctionnalités prévues

Le développement suit plusieurs phases :

1.  **Intégration de base** : Compilation et affichage statique (SVG).
2.  **Rendu Natif (Zero-Copy)** : Rendu direct sur le Canvas Flutter pour une performance maximale.
3.  **Interactivité** : Zoom, Pan, et Scroll infini (Chunking).
4.  **Playback & Audio** : Synchronisation rythmique et audio.

Pour plus de détails sur l'implémentation et la roadmap, voir [TODO-BOILERPLATE.md](TODO-BOILERPLATE.md).