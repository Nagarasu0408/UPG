import 'package:flutter/material.dart';

class FollowersPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Followers'),
      ),
      body: Center(
        child: Text('List of users following the current user.'),
      ),
    );
  }
}
