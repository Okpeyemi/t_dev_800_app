import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import '../widgets/custom_app_bar.dart';

// Définition du type d'historique
enum HistoryType {
  analyzed,
  submitted
}

class UserHistoryScreen extends StatefulWidget {
  final HistoryType historyType;

  const UserHistoryScreen({
    super.key,
    required this.historyType,
  });

  @override
  _UserHistoryScreenState createState() => _UserHistoryScreenState();
}

class _UserHistoryScreenState extends State<UserHistoryScreen> {
  // Données simulées pour démonstration
  // Dans une application réelle, cela viendrait d'une base de données ou d'une API
  final List<Map<String, dynamic>> _analyzedImages = [
    {
      'date': DateTime.now().subtract(Duration(days: 2)),
      'imagePath': '', // À remplacer par des chemins d'images réelles dans une vraie application
      'result': 'Pneumonie (87%)',
      'status': 'Terminé',
    },
    {
      'date': DateTime.now().subtract(Duration(days: 5)),
      'imagePath': '',
      'result': 'Sain (92%)',
      'status': 'Terminé',
    },
  ];

  final List<Map<String, dynamic>> _submittedCases = [
    {
      'date': DateTime.now().subtract(Duration(days: 1)),
      'images': 3,
      'diagnosis': 'Pneumonie',
      'status': 'En attente de révision',
    },
    {
      'date': DateTime.now().subtract(Duration(days: 10)),
      'images': 2,
      'diagnosis': 'Sain',
      'status': 'Validé',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final String pageTitle = widget.historyType == HistoryType.analyzed
        ? 'Images Analysées'
        : 'Cas Soumis';
        
    final bool isAnalyzed = widget.historyType == HistoryType.analyzed;
    final items = isAnalyzed ? _analyzedImages : _submittedCases;

    return Scaffold(
      // Utiliser le même CustomAppBar mais sans le bouton de retour automatique
      appBar: CustomAppBar(
        title: 'Photo Analysis App',
        automaticallyImplyLeading: false, // Désactive le bouton retour
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Ajouter un bouton de retour manuel à côté du titre
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Row(
              children: [
                IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                SizedBox(width: 8),
                Text(
                  pageTitle,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Divider(),
          // Contenu principal
          Expanded(
            child: items.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          isAnalyzed ? Icons.image_not_supported : Icons.folder_off,
                          size: 64,
                          color: Colors.grey,
                        ),
                        SizedBox(height: 16),
                        Text(
                          isAnalyzed
                              ? 'Aucune image analysée'
                              : 'Aucun cas soumis',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey[700],
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: EdgeInsets.all(16),
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final item = items[index];
                      return _buildHistoryItem(item, isAnalyzed);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryItem(Map<String, dynamic> item, bool isAnalyzed) {
    return Card(
      margin: EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _formatDate(item['date']),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Chip(
                  label: Text(
                    item['status'],
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                  ),
                  backgroundColor: _getStatusColor(item['status']),
                ),
              ],
            ),
            SizedBox(height: 12),
            if (isAnalyzed)
              ..._buildAnalyzedContent(item)
            else
              ..._buildSubmittedContent(item),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildAnalyzedContent(Map<String, dynamic> item) {
    return [
      Container(
        height: 120,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          Icons.image,
          size: 48,
          color: Colors.grey[400],
        ),
      ),
      SizedBox(height: 12),
      Text(
        'Résultat: ${item['result']}',
        style: TextStyle(
          fontSize: 16,
        ),
      ),
    ];
  }

  List<Widget> _buildSubmittedContent(Map<String, dynamic> item) {
    return [
      Text(
        'Nombre d\'images: ${item['images']}',
        style: TextStyle(
          fontSize: 16,
        ),
      ),
      SizedBox(height: 8),
      Text(
        'Diagnostic: ${item['diagnosis']}',
        style: TextStyle(
          fontSize: 16,
        ),
      ),
    ];
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Terminé':
      case 'Validé':
        return Colors.green;
      case 'En attente de révision':
        return Colors.orange;
      default:
        return Colors.blue;
    }
  }
}