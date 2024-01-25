import 'package:flutter/material.dart';

class FollowingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Following'),
      ),
      body: Center(
        child: Text('List of users followed by the current user.'),
      ),
    );
  }
}
