import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen>
    with TickerProviderStateMixin {
  List<dynamic> searchResults = [];
  TextEditingController searchController = TextEditingController();
  late AnimationController _fadeController;
  late AnimationController _slideController;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _slideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  searchMovies(String query) async {
    final response = await http
        .get(Uri.parse('https://api.tvmaze.com/search/shows?q=$query'));
    if (response.statusCode == 200) {
      setState(() {
        searchResults = jsonDecode(response.body);
      });
      _fadeController.forward();
      _slideController.forward();
    }
  }

  String cleanSummary(String summary) {
    if (summary == null) return 'No summary available';
    return summary.replaceAll(RegExp(r'<[^>]*>'), '');
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: searchController,
          decoration: const InputDecoration(hintText: 'Search movies'),
          onSubmitted: (value) {
            searchMovies(value);
          },
        ),
      ),
      body: searchResults.isEmpty
          ? const Center(child: Text('Search for movies'))
          : ListView.builder(
              itemCount: searchResults.length,
              itemBuilder: (context, index) {
                final movie = searchResults[index]['show'];

                Animation<Offset> slideAnimation = Tween<Offset>(
                  begin: const Offset(1, 0),
                  end: Offset.zero,
                ).animate(CurvedAnimation(
                  parent: _slideController,
                  curve: Curves.easeInOut,
                ));

                return SlideTransition(
                  position: slideAnimation,
                  child: FadeTransition(
                    opacity: _fadeController,
                    child: ListTile(
                      leading: Image.network(
                        movie['image'] != null ? movie['image']['medium'] : '',
                        height: screenHeight * 0.1,
                        width: screenWidth * 0.2,
                        fit: BoxFit.cover,
                      ),
                      title: Text(
                        movie['name'],
                        style: TextStyle(fontSize: screenWidth * 0.04),
                      ),
                      subtitle: Text(
                        cleanSummary(
                            movie['summary'] ?? 'No summary available'),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style: TextStyle(fontSize: screenWidth * 0.03),
                      ),
                      onTap: () {
                        Navigator.pushNamed(context, '/details',
                            arguments: movie);
                      },
                    ),
                  ),
                );
              },
            ),
    );
  }
}
