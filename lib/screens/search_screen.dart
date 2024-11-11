import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  List movies = [];
  TextEditingController _searchController = TextEditingController();
  bool isLoading = false;

  Future<void> searchMovies(String searchTerm) async {
    if (searchTerm.isEmpty) return;

    setState(() {
      isLoading = true;
    });

    final response = await http.get(
      Uri.parse('https://api.tvmaze.com/search/shows?q=$searchTerm'),
    );

    if (response.statusCode == 200) {
      List results = json.decode(response.body);
      setState(() {
        movies = results;
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
      throw Exception('Failed to load movies');
    }
  }

  Future<void> initialise() async {
    await searchMovies("all");
  }

  @override
  void initState() {
    super.initState();
    initialise();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        iconTheme: const IconThemeData(color: Colors.white),
        titleSpacing: 0,
        title: Row(
          children: [
            Padding(
              padding: EdgeInsets.only(left: 8.0.w),
              child: Image.asset(
                'assets/images/netflix_logo.png',
                fit: BoxFit.contain,
                height: 30.h,
              ),
            ),
            Expanded(
              child: TextField(
                controller: _searchController,
                onChanged: (value) => searchMovies(value),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.1),
                  hintText: 'Search...',
                  hintStyle: const TextStyle(color: Colors.white54),
                  prefixIcon: const Icon(Icons.search, color: Colors.white54),
                  contentPadding: EdgeInsets.symmetric(vertical: 10.h),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.r),
                    borderSide: BorderSide.none,
                  ),
                ),
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
      body: isLoading
          ? Container()
          : movies.isEmpty
              ? const Center(
                  child: Text(
                    'No results found',
                    style: TextStyle(color: Colors.white54, fontSize: 18),
                  ),
                )
              : ListView.builder(
                  itemCount: movies.length,
                  itemBuilder: (context, index) {
                    final movie = movies[index]['show'];
                    return Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: 8.0.h, horizontal: 16.0.w),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, '/details',
                              arguments: movie);
                        },
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CachedNetworkImage(
                              imageUrl: movie['image']?['medium'] ?? '',
                              placeholder: (context, url) => Container(),
                              errorWidget: (context, url, error) =>
                                  const Icon(Icons.error),
                              width: 80.w,
                              height: 120.h,
                              fit: BoxFit.cover,
                            ),
                            SizedBox(width: 10.w),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    movie['name'] ?? 'No title',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 18.sp),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  SizedBox(height: 5.h),
                                  Text(
                                    movie['summary'] != null
                                        ? movie['summary']
                                            .replaceAll(RegExp(r'<[^>]*>'), '')
                                        : 'No description available',
                                    style: TextStyle(
                                        color: Colors.white70, fontSize: 14.sp),
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
