import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class AnalyzePhotoTab extends StatefulWidget {
  const AnalyzePhotoTab({super.key});

  @override
  _AnalyzePhotoTabState createState() => _AnalyzePhotoTabState();
}

class _AnalyzePhotoTabState extends State<AnalyzePhotoTab> {
  final ImagePicker _picker = ImagePicker();
  final List<XFile> _images = [];
  bool _isAnalyzing = false;
  bool _showResults = false;
  String _analysisResults = "";

  @override
  Widget build(BuildContext context) {
    if (_showResults) {
      // Vue des résultats d'analyse (deux colonnes)
      return Column(
        children: [
          // Bouton pour retourner à la vue d'upload
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: () {
                    setState(() {
                      _showResults = false;
                      _isAnalyzing = false;
                    });
                  },
                ),
                Text('Retour à l\'upload'),
                Spacer(),
                // Bouton pour redémarrer l'analyse
                TextButton.icon(
                  onPressed: _analyzePhotos,
                  icon: Icon(Icons.refresh),
                  label: Text('Relancer l\'analyse'),
                ),
              ],
            ),
          ),
          // Contenu principal divisé en deux colonnes
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Colonne 1: Images
                Expanded(
                  child: Card(
                    margin: EdgeInsets.all(8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Images analysées',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        Divider(),
                        Expanded(
                          child: _images.isEmpty
                              ? Center(child: Text('Aucune image'))
                              : _images.length == 1
                                  ? Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Image.file(
                                        File(_images[0].path),
                                        fit: BoxFit.contain,
                                      ),
                                    )
                                  : GridView.builder(
                                      padding: EdgeInsets.all(8),
                                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 2,
                                        crossAxisSpacing: 10,
                                        mainAxisSpacing: 10,
                                      ),
                                      itemCount: _images.length,
                                      itemBuilder: (context, index) {
                                        return Image.file(
                                          File(_images[index].path),
                                          fit: BoxFit.cover,
                                        );
                                      },
                                    ),
                        ),
                      ],
                    ),
                  ),
                ),
                
                // Colonne 2: Analyse et Résultats
                Expanded(
                  child: Column(
                    children: [
                      // Ligne 1: État de l'analyse
                      Expanded(
                        child: Card(
                          margin: EdgeInsets.all(8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  'État de l\'analyse',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                              Divider(),
                              Expanded(
                                child: Center(
                                  child: _isAnalyzing
                                      ? Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            CircularProgressIndicator(),
                                            SizedBox(height: 16),
                                            Text('Analyse en cours...'),
                                          ],
                                        )
                                      : Text('Analyse terminée'),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      
                      // Ligne 2: Résultats
                      Expanded(
                        child: Card(
                          margin: EdgeInsets.all(8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  'Résultats',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                              Divider(),
                              Expanded(
                                child: SingleChildScrollView(
                                  padding: EdgeInsets.all(8),
                                  child: _isAnalyzing
                                      ? Text('En attente de résultats...')
                                      : Text(_analysisResults.isEmpty 
                                          ? 'Analyse terminée avec succès.\n\nL\'image montre des signes de {résultat}' 
                                          : _analysisResults),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    } else {
      // Vue d'upload originale (modifiée pour correspondre à submit_case_tab)
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Titre et description
            Text(
              'Analyser des radiographies pulmonaires',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Téléchargez des images de radiographie pulmonaire pour détecter des signes de pneumonie.',
              style: TextStyle(
                color: Colors.grey[700],
              ),
            ),
            SizedBox(height: 24),
            
            // Zone d'upload avec bordure en pointillés (style de submit_case_tab)
            InkWell(
              onTap: _pickImages,
              child: Container(
                height: 120,
                decoration: BoxDecoration(
                  border: Border.all(
                    // Utiliser une couleur qui s'adapte au thème
                    color: Theme.of(context).dividerColor,
                    width: 1,
                    style: BorderStyle.solid,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: DashedBorder(
                  padding: EdgeInsets.all(16),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.add_photo_alternate_outlined,
                          size: 36,
                          // Utiliser la couleur du thème au lieu d'une couleur fixe
                          color: Theme.of(context).primaryColor,
                        ),
                        SizedBox(height: 8),
                        Text(
                          "Ajouter des radiographies",
                          style: TextStyle(
                            // Utiliser la couleur du texte du thème actuel
                            color: Theme.of(context).textTheme.bodyMedium?.color,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 24),
            
            // Liste d'images avec style unifié
            Expanded(
              child: _images.isEmpty
                  ? Center(
                      child: Text(
                        'Aucune image téléchargée',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 16,
                        ),
                      ),
                    )
                  : GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                      ),
                      itemCount: _images.length,
                      itemBuilder: (context, index) {
                        return Card(
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(4),
                                child: Image.file(
                                  File(_images[index].path),
                                  fit: BoxFit.cover,
                                ),
                              ),
                              // Bouton de suppression similaire à submit_case_tab
                              Positioned(
                                right: 0,
                                top: 0,
                                child: IconButton(
                                  icon: Icon(Icons.delete_outline, color: Colors.red),
                                  onPressed: () {
                                    setState(() {
                                      _images.removeAt(index);
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _images.isEmpty ? null : _analyzePhotos,
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 16),
                backgroundColor: Theme.of(context).primaryColor,
                foregroundColor: Colors.white,
                minimumSize: Size(double.infinity, 50),
              ),
              child: _isAnalyzing
                  ? CircularProgressIndicator(color: Colors.white)
                  : Text('ANALYSER', style: TextStyle(fontSize: 16)),
            ),
          ],
        ),
      );
    }
  }

  Future<void> _pickImages() async {
    try {
      final List<XFile> selectedImages = await _picker.pickMultiImage();
      if (selectedImages.isNotEmpty) {
        setState(() {
          _images.addAll(selectedImages);
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur lors de la sélection des images: $e')),
      );
    }
  }

  Future<void> _analyzePhotos() async {
    setState(() {
      _isAnalyzing = true;
      _showResults = true;  // Afficher la vue des résultats
    });

    // Simuler l'analyse
    await Future.delayed(Duration(seconds: 3));

    // Simuler des résultats
    _analysisResults = "Résultats de l'analyse :\n\n"
        "- Détection: Présence de pneumonie\n"
        "- Probabilité: 87%\n"
        "- Classification: Pneumonie bactérienne\n\n"
        "Recommandations:\n"
        "- Consultation médicale recommandée\n"
        "- Traitement antibiotique potentiellement nécessaire\n\n"
        "Notes supplémentaires:\n"
        "Cette analyse a été effectuée avec le modèle v2.3";

    setState(() {
      _isAnalyzing = false;
    });
  }
}

// Widget pour créer une bordure en pointillés (identique à celui de submit_case_tab)
class DashedBorder extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;

  const DashedBorder({super.key, 
    required this.child,
    this.padding = EdgeInsets.zero,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.transparent),
        borderRadius: BorderRadius.circular(8),
      ),
      child: CustomPaint(
        painter: DashBorderPainter(),
        child: child,
      ),
    );
  }
}

class DashBorderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    const dashWidth = 5;
    const dashSpace = 5;

    // Top line
    double startX = 0;
    while (startX < size.width) {
      canvas.drawLine(
        Offset(startX, 0),
        Offset(startX + dashWidth, 0),
        paint,
      );
      startX += dashWidth + dashSpace;
    }

    // Right line
    double startY = 0;
    while (startY < size.height) {
      canvas.drawLine(
        Offset(size.width, startY),
        Offset(size.width, startY + dashWidth),
        paint,
      );
      startY += dashWidth + dashSpace;
    }

    // Bottom line
    startX = size.width;
    while (startX > 0) {
      canvas.drawLine(
        Offset(startX, size.height),
        Offset(startX - dashWidth, size.height),
        paint,
      );
      startX -= dashWidth + dashSpace;
    }

    // Left line
    startY = size.height;
    while (startY > 0) {
      canvas.drawLine(
        Offset(0, startY),
        Offset(0, startY - dashWidth),
        paint,
      );
      startY -= dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}