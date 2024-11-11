import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DetailsScreen extends StatelessWidget {
  String removeHtmlTags(String htmlString) {
    RegExp exp = RegExp(r"<[^>]*>", multiLine: true, caseSensitive: true);
    return htmlString.replaceAll(exp, '');
  }

  @override
  Widget build(BuildContext context) {
    final movie = ModalRoute.of(context)!.settings.arguments as Map;

    double rating = (movie['rating']['average'] ?? 0).toDouble();
    List<String> genres = List<String>.from(movie['genres'] ?? []);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        title: Text(
          movie['name'],
          style: TextStyle(
            color: Colors.white,
            fontSize: 24.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.black,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(bottom: 8.0.h),
              child: CachedNetworkImage(
                imageUrl: movie['image']?['original'] ?? '',
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0.w),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Expanded(
                    child: RatingBarIndicator(
                      rating: rating / 2,
                      itemBuilder: (context, index) => const Icon(
                        Icons.star,
                        color: Colors.amber,
                      ),
                      itemCount: 5,
                      itemSize: 24.0.w,
                      direction: Axis.horizontal,
                    ),
                  ),
                  Text(
                    '($rating/10)',
                    style: TextStyle(color: Colors.white70, fontSize: 16.sp),
                  ),
                  Text(
                    '  RT',
                    style:
                        TextStyle(color: Colors.red.shade600, fontSize: 16.sp),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0.w, vertical: 4.0.h),
              child: Wrap(
                spacing: 8.0.w,
                children: genres
                    .map((genre) => Chip(
                          label: Text(
                            genre,
                            style: const TextStyle(color: Colors.white),
                          ),
                          backgroundColor: Colors.grey[800],
                        ))
                    .toList(),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8.0.w),
              child: Text(
                removeHtmlTags(movie['summary'] ?? 'No summary available'),
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w400,
                ),
                textAlign: TextAlign.justify,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
