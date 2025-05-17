import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class SubmitCaseTab extends StatefulWidget {
  const SubmitCaseTab({super.key});

  @override
  _SubmitCaseTabState createState() => _SubmitCaseTabState();
}

class _SubmitCaseTabState extends State<SubmitCaseTab> {
  final ImagePicker _picker = ImagePicker();
  final _formKey = GlobalKey<FormState>();
  List<CaseImageData> _caseImages = [];
  bool _isSubmitting = false;
  bool _hasSubmitted = false;
  String? _comments;
  
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Titre et description
            Text(
              'Soumettre des radiographies pulmonaires',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Téléchargez des images de radiographie pulmonaire et indiquez si elles présentent des signes de pneumonie.',
              style: TextStyle(
                // Utiliser la couleur du texte du thème avec opacité
                color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.8),
              ),
            ),
            SizedBox(height: 24),
            
            // Zone d'upload
            InkWell(
              onTap: _pickImages,
              child: Container(
                height: 120,
                decoration: BoxDecoration(
                  border: Border.all(
                    // Utiliser la couleur du séparateur du thème
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
                          color: Theme.of(context).primaryColor,
                        ),
                        SizedBox(height: 8),
                        Text(
                          "Ajouter des radiographies",
                          style: TextStyle(
                            // Utiliser la couleur du texte du thème
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
            
            // Images téléchargées et options
            _caseImages.isEmpty
                ? Center(
                    child: Text(
                      'Aucune image téléchargée',
                      style: TextStyle(
                        // Utiliser la couleur du texte du thème avec opacité
                        color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.7),
                        fontSize: 16,
                      ),
                    ),
                  )
                : Expanded(
                    child: ListView.builder(
                      itemCount: _caseImages.length,
                      itemBuilder: (context, index) {
                        return ImageLabelCard(
                          imageData: _caseImages[index],
                          onDelete: () => _removeImage(index),
                          onLabelChanged: (value) {
                            setState(() {
                              _caseImages[index].isSick = value;
                            });
                          },
                        );
                      },
                    ),
                  ),
            
            // Champ de commentaires
            if (_caseImages.isNotEmpty) ...[
              SizedBox(height: 24),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Commentaires additionnels',
                  border: OutlineInputBorder(),
                  alignLabelWithHint: true,
                ),
                maxLines: 3,
                onChanged: (value) => _comments = value,
              ),
            ],
            
            // Bouton de soumission
            if (_caseImages.isNotEmpty) ...[
              SizedBox(height: 24),
              ElevatedButton(
                onPressed: _isSubmitting ? null : _submitCase,
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Theme.of(context).primaryColor,
                  foregroundColor: Colors.white,
                  minimumSize: Size(double.infinity, 50),
                ),
                child: _isSubmitting
                    ? CircularProgressIndicator(color: Colors.white)
                    : Text('SOUMETTRE LE CAS', style: TextStyle(fontSize: 16)),
              ),
            ],
            
            // Message de confirmation
            if (_hasSubmitted) ...[
              SizedBox(height: 16),
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.green[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.green[300]!),
                ),
                child: Row(
                  children: [
                    Icon(Icons.check_circle, color: Colors.green),
                    SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        'Cas soumis avec succès. Merci pour votre contribution!',
                        style: TextStyle(color: Colors.green[800]),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Future<void> _pickImages() async {
    try {
      final List<XFile> selectedImages = await _picker.pickMultiImage();
      if (selectedImages.isNotEmpty) {
        setState(() {
          // Convertir les XFile en CaseImageData
          _caseImages.addAll(selectedImages.map(
            (file) => CaseImageData(file: file, isSick: null)
          ));
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur lors de la sélection des images: $e')),
      );
    }
  }

  void _removeImage(int index) {
    setState(() {
      _caseImages.removeAt(index);
    });
  }

  Future<void> _submitCase() async {
    // Vérifier que toutes les images ont été étiquetées
    if (_caseImages.any((image) => image.isSick == null)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Veuillez étiqueter toutes les images comme malade ou sain')),
      );
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      // Simulation d'envoi au serveur
      await Future.delayed(Duration(seconds: 2));
      
      // Réinitialiser le formulaire et afficher confirmation
      setState(() {
        _isSubmitting = false;
        _hasSubmitted = true;
        _caseImages = [];
        _comments = null;
      });
      
      // Faire disparaître le message après 5 secondes
      Future.delayed(Duration(seconds: 5), () {
        if (mounted) {
          setState(() {
            _hasSubmitted = false;
          });
        }
      });
    } catch (e) {
      setState(() {
        _isSubmitting = false;
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur lors de la soumission: $e')),
      );
    }
  }
}

// Classe pour stocker les données d'image et son étiquette
class CaseImageData {
  final XFile file;
  bool? isSick;  // true = malade, false = sain, null = non étiqueté
  
  CaseImageData({
    required this.file,
    this.isSick,
  });
}

// Widget pour afficher une image avec options d'étiquetage
class ImageLabelCard extends StatelessWidget {
  final CaseImageData imageData;
  final VoidCallback onDelete;
  final Function(bool?) onLabelChanged;

  const ImageLabelCard({super.key, 
    required this.imageData,
    required this.onDelete,
    required this.onLabelChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    imageData.file.name,
                    style: TextStyle(fontWeight: FontWeight.bold),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.delete_outline, color: Colors.red),
                  onPressed: onDelete,
                ),
              ],
            ),
            SizedBox(height: 12),
            // Option 1: Limiter la hauteur avec un conteneur à taille fixe
            Container(
              height: 150, // Hauteur réduite (ajustez selon vos besoins)
              alignment: Alignment.center,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.file(
                  File(imageData.file.path),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            
            // Option 2 (alternative): Utiliser un SizedBox avec une largeur maximale
            // SizedBox(
            //   width: MediaQuery.of(context).size.width * 0.7, // 70% de la largeur de l'écran
            //   child: AspectRatio(
            //     aspectRatio: 16/12, // Ratio plus compact
            //     child: ClipRRect(
            //       borderRadius: BorderRadius.circular(8),
            //       child: Image.file(
            //         File(imageData.file.path),
            //         fit: BoxFit.cover,
            //       ),
            //     ),
            //   ),
            // ),
            SizedBox(height: 16),
            Text(
              'Diagnostic:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: RadioListTile<bool>(
                    title: Text('Sain'),
                    value: false,
                    groupValue: imageData.isSick,
                    onChanged: onLabelChanged,
                    activeColor: Colors.green,
                    dense: true,
                  ),
                ),
                Expanded(
                  child: RadioListTile<bool>(
                    title: Text('Pneumonie'),
                    value: true,
                    groupValue: imageData.isSick,
                    onChanged: onLabelChanged,
                    activeColor: Colors.red,
                    dense: true,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// Réutilisation du widget pour bordure en pointillés
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
        painter: DashBorderPainter(context),
        child: child,
      ),
    );
  }
}

class DashBorderPainter extends CustomPainter {
  final BuildContext context;
  
  DashBorderPainter(this.context);
  
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      // Utiliser la couleur des séparateurs du thème
      ..color = Theme.of(context).dividerColor
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