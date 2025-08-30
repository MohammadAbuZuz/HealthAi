import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../profile/register/login_screen.dart';

class WelScreen extends StatefulWidget {
  const WelScreen({super.key});

  @override
  State<WelScreen> createState() => _WelScreenState();
}

class _WelScreenState extends State<WelScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 2), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(30),
        child: Column(
          children: [
            Stack(
              children: [
                SvgPicture.asset('assets/images/imagewelcom.svg'),
                Positioned(
                  top: 50,
                  left: 100,
                  right: 100,
                  child: Center(
                    child: Text(
                      'data',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Text('Lorem Ipsum '),
            SizedBox(height: 20),
            Text('Lorem Ipsum is a dummy text\n used as placeholder'),
          ],
        ),
      ),
    );
  }
}
