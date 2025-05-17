import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/theme_provider.dart';
import '../screens/user_history_screen.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final TabBar? bottom;
  final bool automaticallyImplyLeading;

  const CustomAppBar({
    super.key,
    required this.title,
    this.bottom,
    this.automaticallyImplyLeading = true,
  });

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final themeProvider = Provider.of<ThemeProvider>(context);
    
    return AppBar(
      automaticallyImplyLeading: automaticallyImplyLeading,
      title: Text(title),
      actions: [
        // Bouton de thème
        IconButton(
          icon: Icon(
            themeProvider.isDarkMode ? Icons.light_mode : Icons.dark_mode,
          ),
          tooltip: themeProvider.isDarkMode ? 'Passer en mode clair' : 'Passer en mode sombre',
          onPressed: () {
            themeProvider.toggleTheme();
          },
        ),
        Row(
          children: [
            Text(authProvider.username),
            SizedBox(width: 8),
            PopupMenuButton<String>(
              offset: Offset(0, 45),
              icon: CircleAvatar(
                child: Text(authProvider.username.isNotEmpty 
                  ? authProvider.username[0].toUpperCase() 
                  : 'U'),
              ),
              onSelected: (value) {
                if (value == 'analyzed_images') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => UserHistoryScreen(
                        historyType: HistoryType.analyzed,
                      ),
                    ),
                  );
                } else if (value == 'submitted_cases') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => UserHistoryScreen(
                        historyType: HistoryType.submitted,
                      ),
                    ),
                  );
                }
              },
              itemBuilder: (BuildContext context) => [
                PopupMenuItem<String>(
                  value: 'analyzed_images',
                  child: Row(
                    children: [
                      Icon(Icons.photo_library, color: Theme.of(context).primaryColor),
                      SizedBox(width: 8),
                      Text('Images analysées'),
                    ],
                  ),
                ),
                PopupMenuItem<String>(
                  value: 'submitted_cases',
                  child: Row(
                    children: [
                      Icon(Icons.folder_shared, color: Theme.of(context).primaryColor),
                      SizedBox(width: 8),
                      Text('Cas soumis'),
                    ],
                  ),
                ),
                PopupMenuItem<String>(
                  value: 'profile',
                  child: Row(
                    children: [
                      Icon(Icons.person, color: Theme.of(context).primaryColor),
                      SizedBox(width: 8),
                      Text('Profil'),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(width: 16),
            IconButton(
              icon: Icon(Icons.logout),
              onPressed: () async {
                await authProvider.logout();
                Navigator.pushReplacementNamed(context, '/login');
              },
            ),
          ],
        ),
      ],
      bottom: bottom,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(bottom != null ? 100.0 : 56.0);
}