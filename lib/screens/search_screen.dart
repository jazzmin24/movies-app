import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';


class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  List searchResults = [];
  TextEditingController _searchController = TextEditingController();

  Future<void> searchMovies(String query) async {
    final response = await http.get(Uri.parse('https://api.tvmaze.com/search/shows?q=$query'));
    if (response.statusCode == 200) {
      setState(() {
        searchResults = json.decode(response.body);
      });
    } else {
      throw Exception('Failed to search movies');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: TextField(
          controller: _searchController,
          decoration: InputDecoration(
            hintText: 'Search...',
            prefixIcon: Icon(Icons.search, color: Colors.white),
          ),
          onSubmitted: searchMovies,
        ),
      ),
      body: searchResults.isEmpty
          ? Center(child: Text('No results found', style: TextStyle(color: Colors.white)))
          : ListView.builder(
              itemCount: searchResults.length,
              itemBuilder: (context, index) {
                final movie = searchResults[index]['show'];
                return ListTile(
                  leading: CachedNetworkImage(imageUrl: movie['image']?['medium'] ?? ''),
                  title: Text(movie['name'], style: TextStyle(color: Colors.white)),
                  onTap: () {
                    Navigator.pushNamed(context, '/details', arguments: movie);
                  },
                );
              },
            ),
    );
  }
}
