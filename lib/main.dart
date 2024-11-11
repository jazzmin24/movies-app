import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:movie_app/screens/main_screen.dart';
import 'package:movie_app/screens/splash_screen.dart';
import 'package:movie_app/screens/home_screen.dart';
import 'package:movie_app/screens/search_screen.dart';
import 'package:movie_app/screens/details_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Use a Builder widget to get the size of the screen through MediaQuery
    return Builder(
      builder: (context) {
        final size = MediaQuery.of(context).size;
        return ScreenUtilInit(
          designSize: Size(size.width, size.height),
          minTextAdapt: true,
          splitScreenMode: true,
          builder: (context, child) {
            return MaterialApp(
              title: 'Movie App',
              debugShowCheckedModeBanner: false,
              initialRoute: '/', // Set the initial route to splash screen
              routes: {
                '/': (context) => SplashScreen(),
                '/main': (context) => MainScreen(), 
                '/home': (context) => HomeScreen(),
                 '/search': (context) => SearchScreen(),
                 '/details': (context) => DetailsScreen(),
              },
            );
          },
          child: SplashScreen(),
        );
      },
    );
  }
}
