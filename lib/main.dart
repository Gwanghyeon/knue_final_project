import 'package:flutter/material.dart';
import 'package:smart_content/const/const.dart';
import 'package:smart_content/const/font_design.dart';
import 'package:smart_content/screens/lesson_screen.dart';
import 'package:smart_content/screens/text_recognition.dart';

void main(List<String> args) {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smart Content',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          fontFamily: 'noto_sans',
          primaryColor: primaryColor,
          appBarTheme: const AppBarTheme(
            color: primaryColor,
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              textStyle: const TextStyle(
                fontFamily: 'noto_sans',
              ),
            ),
          )),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.home),
          onPressed: () {},
        ),
        title: const Text(
          'Learning English with AI',
        ),
        centerTitle: true,
      ),
      body: Stack(children: [
        Container(
          decoration: const BoxDecoration(
              image: DecorationImage(
            image: AssetImage('asset/paper.jpg'),
            fit: BoxFit.cover,
          )),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            const SizedBox(),
            _renderButton(
              title: 'English Lesson with AI',
              icon: Icons.abc,
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LessonScreen(),
                    ));
              },
            ),
            _renderButton(
              title: 'AI Text Recognition',
              icon: Icons.camera,
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const TextRecogScreen(),
                    ));
              },
            ),
            const SizedBox(),
          ],
        ),
      ]),
    );
  }

  Widget _renderButton(
      {required IconData icon,
      required VoidCallback onTap,
      required String title}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Column(
          children: [
            GestureDetector(
              onTap: onTap,
              child: Container(
                decoration: BoxDecoration(
                  color: primaryColor,
                  borderRadius: BorderRadius.circular(4),
                  boxShadow: primaryShadow,
                ),
                child: Icon(
                  icon,
                  color: Colors.white,
                  size: 180,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(
                8,
              ),
              decoration: BoxDecoration(
                color: primaryColor,
                borderRadius: BorderRadius.circular(8),
                boxShadow: primaryShadow,
              ),
              child: Text(
                title,
                style: primaryTextStyle.copyWith(color: Colors.white),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
