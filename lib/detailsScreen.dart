import 'package:flutter/material.dart';

class DetailsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final movie =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
    final imageUrl = movie['image'] != null ? movie['image']['medium'] : null;
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    String cleanSummary(String summary) {
      if (summary == null) return 'No summary available';
      return summary.replaceAll(RegExp(r'<[^>]*>'), '');
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(movie['name']),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Hero(
              tag: 'movieImage-${movie['id']}',
              child: imageUrl != null && imageUrl.isNotEmpty
                  ? Image.network(
                      imageUrl,
                      fit: BoxFit.cover,
                    )
                  : Container(
                      color: Colors.grey,
                      child: FittedBox(
                        fit: BoxFit.cover,
                        child: Icon(
                          Icons.broken_image,
                          color: Colors.white,
                          size: screenHeight * 0.3,
                        ),
                      ),
                    ),
            ),
            SizedBox(height: 20),
            Text(
              movie['name'],
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                cleanSummary(movie['summary']),
                style: TextStyle(fontSize: screenWidth * 0.04),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
