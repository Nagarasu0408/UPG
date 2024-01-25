import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserImagesPage extends StatefulWidget {
  @override
  _UserImagesPageState createState() => _UserImagesPageState();
}

class _UserImagesPageState extends State<UserImagesPage> {
  late User _user;
  List<String> _userImages = [];

  @override
  void initState() {
    super.initState();
    _user = FirebaseAuth.instance.currentUser!;
    _loadUserImages();
  }

  Future<void> _loadUserImages() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('user_images')
        .doc(_user.uid)
        .collection('images')
        .get();

    setState(() {
      _userImages =
          querySnapshot.docs.map((doc) => doc['imageUrl'] as String).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Images'),
      ),
      body: _userImages.isEmpty
          ? Center(
              child: Text('No image found'),
            )
          : GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 4.0,
                mainAxisSpacing: 4.0,
              ),
              itemCount: _userImages.length,
              itemBuilder: (context, index) {
                return Image.network(_userImages[index]);
              },
            ),
    );
  }
}
