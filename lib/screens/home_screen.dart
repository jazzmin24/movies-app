import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Map<String, dynamic>> categorizedMovies = [];

  @override
  void initState() {
    super.initState();
    fetchAndCategorizeMovies();
  }

  Future<void> fetchAndCategorizeMovies() async {
    final response =
        await http.get(Uri.parse('https://api.tvmaze.com/search/shows?q=all'));
    if (response.statusCode == 200) {
      List movies = json.decode(response.body);
      setState(() {
        categorizedMovies = categorizeMovies(movies);
      });
    } else {
      throw Exception('Failed to load movies');
    }
  }

  List<Map<String, dynamic>> categorizeMovies(List movies) {
    List<Map<String, dynamic>> categorizedMovies = [];

    categorizedMovies.add({
      'title': 'Popular Shows',
      'movies': movies.where((movie) {
        var rating = movie['show']['rating']['average'];
        return rating != null && rating >= 4;
      }).toList()
    });

    categorizedMovies.add({
      'title': 'Recently Added',
      'movies': movies.where((movie) {
        DateTime premiered =
            DateTime.parse(movie['show']['premiered'] ?? '2018-01-08');
        return premiered.isAfter(DateTime(2016, 1, 8));
      }).toList()
    });

    categorizedMovies.add({
      'title': 'Classic Shows',
      'movies': movies.where((movie) {
        DateTime premiered =
            DateTime.parse(movie['show']['premiered'] ?? '2018-01-08');
        return premiered.isBefore(DateTime(2016, 1, 8));
      }).toList()
    });

    categorizedMovies.add({
      'title': 'Drama',
      'movies': movies.where((movie) {
        return movie['show']['genres'].contains('Drama');
      }).toList()
    });

    categorizedMovies.add({
      'title': 'Comedy',
      'movies': movies.where((movie) {
        return movie['show']['genres'].contains('Comedy');
      }).toList()
    });

    return categorizedMovies;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
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
              child: GestureDetector(
                onTap: () => Navigator.pushNamed(context, '/search'),
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 10.w),
                  height: 40.h,
                  child: TextField(
                    enabled: false,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.1),
                      hintText: 'Search...',
                      hintStyle: const TextStyle(color: Colors.white54),
                      prefixIcon:
                          const Icon(Icons.search, color: Colors.white54),
                      contentPadding: EdgeInsets.symmetric(vertical: 10.h),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.r),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      body: categorizedMovies.isEmpty
          ? Container()
          : ListView.builder(
              itemCount: categorizedMovies.length,
              itemBuilder: (context, index) {
                final category = categorizedMovies[index];
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: 8.0.h, horizontal: 16.0.w),
                      child: Text(
                        category['title'],
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(
                      height: 200.h,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: category['movies'].length,
                        itemBuilder: (context, movieIndex) {
                          final movie = category['movies'][movieIndex]['show'];
                          return Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8.0.w),
                            child: GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(context, '/details',
                                    arguments: movie);
                              },
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CachedNetworkImage(
                                    imageUrl: movie['image']?['medium'] ?? '',
                                    placeholder: (context, url) => Container(),
                                    errorWidget: (context, url, error) =>
                                        const Icon(Icons.error),
                                    width: 120.w,
                                    height: 160.h,
                                    fit: BoxFit.cover,
                                  ),
                                  SizedBox(height: 5.h),
                                  Text(
                                    movie['name'] ?? 'No title',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 14.sp),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                );
              },
            ),
    );
  }
}
