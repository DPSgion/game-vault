import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../providers/explore_provider.dart';
import '../views/game_detail_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/auth_service.dart';
import 'library_view.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ExploreProvider>().loadHomeData();
    });
  }

  void _showFilterBottomSheet() {
    final Map<String, String> genres = {
      'All': 'all',
      'Action': 'action',
      'RPG': 'role-playing-games-rpg',
      'Shooter': 'shooter',
      'Sports': 'sports',
      'Indie': 'indie',
      'Adventure': 'adventure',
      'Strategy': 'strategy',
    };

    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1E293B),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'FILTER GAMES',
                style: TextStyle(
                  fontSize: 18, 
                  fontWeight: FontWeight.bold, 
                  color: Colors.white, 
                  letterSpacing: 1.5
                ),
              ),
              const SizedBox(height: 20),
              DropdownButtonFormField<String>(
                value: context.read<ExploreProvider>().selectedGenre,
                dropdownColor: const Color(0xFF0F172A),
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Select Genre',
                  labelStyle: const TextStyle(color: Color(0xFF00E5FF)),
                  enabledBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.white24)),
                  focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: Color(0xFF00E5FF))),
                ),
                items: genres.entries.map((entry) {
                  return DropdownMenuItem<String>(
                    value: entry.value,
                    child: Text(entry.key),
                  );
                }).toList(),
                onChanged: (newValue) {
                  if (newValue != null) {
                    context.read<ExploreProvider>().filterByGenre(newValue);
                    Navigator.pop(context);
                  }
                },
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1E293B),
        title: const Text("SYSTEM LOGOUT", style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold)),
        content: const Text("Disconnect from Game Vault?", style: TextStyle(color: Colors.white)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("CANCEL", style: TextStyle(color: Colors.white54)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
            onPressed: () async {
              context.read<ExploreProvider>().clearData();
              await AuthService().signOut();
              if (context.mounted) Navigator.pop(context);
            },
            child: const Text("LOGOUT", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ExploreProvider>();
    
    const Color bgColor = Color(0xFF0F172A);
    const Color cardColor = Color(0xFF1E293B);
    const Color accentColor = Color(0xFF00E5FF);

    return Scaffold(
      backgroundColor: bgColor,
      // Đã xóa hoàn toàn thuộc tính drawer: Drawer(...) tại đây
      
      appBar: AppBar(
        backgroundColor: bgColor,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        
        leading: IconButton(
          icon: const Icon(Icons.local_fire_department, color: accentColor),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const LibraryView()),
            );
          }
        ),
        
        title: const Text(
          'EXPLORE',
          style: TextStyle(fontWeight: FontWeight.w900, color: Colors.white, letterSpacing: 2.0),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0, left: 8.0),
            child: GestureDetector(
              onLongPress: () => _showLogoutDialog(context),
              child: CircleAvatar(
                radius: 16,
                backgroundColor: accentColor.withOpacity(0.2),
                backgroundImage: FirebaseAuth.instance.currentUser?.photoURL != null
                    ? NetworkImage(FirebaseAuth.instance.currentUser!.photoURL!)
                    : null,
                child: FirebaseAuth.instance.currentUser?.photoURL == null
                    ? const Icon(Icons.person, color: accentColor, size: 20)
                    : null,
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: 'Search games...',
                      hintStyle: const TextStyle(color: Colors.white38),
                      prefixIcon: const Icon(Icons.search, color: accentColor),
                      filled: true,
                      fillColor: cardColor,
                      contentPadding: const EdgeInsets.symmetric(vertical: 0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    onSubmitted: (value) {
                      context.read<ExploreProvider>().search(value);
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  decoration: BoxDecoration(
                    color: accentColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: accentColor.withOpacity(0.3)),
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.filter_alt, color: accentColor),
                    onPressed: _showFilterBottomSheet,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            Expanded(
              child: provider.isLoading
                  ? const Center(child: CircularProgressIndicator(color: accentColor))
                  : provider.gridGames.isEmpty
                  ? const Center(child: Text("No games found.", style: TextStyle(color: Colors.white54)))
                  : GridView.builder(
                      physics: const BouncingScrollPhysics(),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        childAspectRatio: 0.75,
                      ),
                      itemCount: provider.gridGames.length,
                      itemBuilder: (context, index) {
                        final game = provider.gridGames[index];
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => GameDetailView(game: game)),
                            );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: cardColor,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: Colors.white.withOpacity(0.05)),
                            ),
                            clipBehavior: Clip.antiAlias,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Expanded(
                                  flex: 4,
                                  child: CachedNetworkImage(
                                    imageUrl: game.backgroundImage.isNotEmpty
                                        ? game.backgroundImage
                                        : 'https://via.placeholder.com/150',
                                    fit: BoxFit.cover,
                                    placeholder: (context, url) => Container(color: Colors.black26),
                                    errorWidget: (context, url, error) => Container(
                                      color: Colors.black26, 
                                      child: const Icon(Icons.sports_esports, color: Colors.white24)
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Center(
                                      child: Text(
                                        game.name,
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 13,
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}