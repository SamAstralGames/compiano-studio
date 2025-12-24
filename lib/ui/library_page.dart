import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import '../logic/play/play_controller.dart';

class LibraryPage extends StatefulWidget {
  final PlayController playController;

  const LibraryPage({super.key, required this.playController});

  @override
  State<LibraryPage> createState() => _LibraryPageState();
}

class _LibraryPageState extends State<LibraryPage> {
  // Liste simulée pour l'instant. À terme, tu pourras persister ça (SQLite/Hive)
  final List<Map<String, String>> _scores = [
    {'title': 'test 1', 'path': 'assets/test1.xml', 'composer': 'Sam'},
    {'title': 'test 2', 'path': 'assets/test2.xml', 'composer': 'Sam'},
    {'title': 'test 3', 'path': 'assets/test3.xml', 'composer': 'Claude Debussy'},
    {'title': 'test all', 'path': 'assets/test-all.xml', 'composer': 'Erik Satie'},
    {'title': 'Elite Syncopations', 'path': 'assets/ScottJoplin_EliteSyncopations.xml', 'composer': 'Scott Joplin '},
    {'title': 'An Die Ferne Geliebte', 'path': 'assets/Beethoven_AnDieFerneGeliebte.xml', 'composer': 'Beethoven'},
  ];

  Future<void> _importFile() async {
    // Ouvre le sélecteur de fichiers natif
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['xml', 'musicxml', 'mxl'],
    );

    if (result != null) {
      final file = result.files.single;
      if (file.path != null) {
        setState(() {
          _scores.add({
            'title': file.name, // On utilise le nom du fichier comme titre par défaut
            'path': file.path!,
            'composer': 'Inconnu', // On pourrait parser le XML pour trouver le compositeur
          });
        });
        // Optionnel : Ouvrir directement le fichier importé
        // widget.onScoreSelected(file.path!);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _importFile,
        icon: const Icon(Icons.add),
        label: const Text("Importer MusicXML"),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: _scores.length,
        itemBuilder: (context, index) {
          final score = _scores[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 10),
            elevation: 2,
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                child: const Icon(Icons.music_note),
              ),
              title: Text(score['title']!, style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text(score['composer']!),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () => widget.playController.requestPlay(score['path']!),
            ),
          );
        },
      ),
    );
  }
}
