import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:upg/main.dart';
import 'package:upg/settingspage.dart';

import 'Theme.dart';

class HomeScreen extends StatefulWidget {
  final User user;

  const HomeScreen({Key? key, required this.user}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final ImagePicker _picker = ImagePicker();
  bool isLiked = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [Text('UPG')],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              context.read<ThemeProvider>().darkMode = false;
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => LoginPage()));
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream:
                  FirebaseFirestore.instance.collection('images').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Text('No images found.');
                }
                var images = snapshot.data!.docs;

                List<Widget> imageWidgets = [];
                for (var image in images) {
                  var imageUrl = image['url'];
                  var likes = image['likes'] ?? 0;
                  imageWidgets.add(
                    ListTile(
                      title: Image.network(imageUrl),
                      subtitle: Row(
                        children: [
                          IconButton(
                            icon: Icon(
                              isLiked ? Icons.favorite : Icons.favorite_border,
                              color: isLiked ? Colors.red : null,
                            ),
                            onPressed: () {
                              _handleLike(image.id);
                            },
                          ),
                          Text('$likes Likes'),
                        ],
                      ),
                    ),
                  );
                }

                return ListView(
                  children: imageWidgets,
                );
              },
            ),
          ),
        ElevatedButton(
            onPressed: () {
              _pickImage();
            },
            child:const Text('Upload Image'),
          ),
        ],
      ),
    );
  }

  void _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      _uploadImage(File(pickedFile.path));
    }
  }

  void _uploadImage(File image) async {
    try {
      var user = widget.user;
      var timestamp = DateTime.now().millisecondsSinceEpoch;

      var ref = _storage.ref().child('images/$timestamp.jpg');
      var uploadTask = ref.putFile(image);

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Uploading Image...'),
                SizedBox(height: 16),
                CircularProgressIndicator(),
              ],
            ),
          );
        },
      );

      // Listen for changes in the upload state
      uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
        if (snapshot.state == TaskState.success) {
          Navigator.of(context).pop(); // Close the loading indicator
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Image uploaded successfully!'),
            ),
          );
        }
      });

      var imageUrl = await (await uploadTask).ref.getDownloadURL();

      await _firestore.collection('images').add({
        'url': imageUrl,
        'likes': 0,
        'uploadedBy': user.uid,
      });
    } catch (error) {
      Navigator.of(context).pop(); // Close the loading indicator on error
      print(error);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error uploading image. Please try again.'),
        ),
      );
    }
  }

  void _handleLike(String documentId) async {
    var user = widget.user;
    // Check if the user has already liked the image
    var likedImages = await _firestore
        .collection('user_likes')
        .doc(user.uid)
        .collection('liked_images')
        .where('imageId', isEqualTo: documentId)
        .get();

    if (likedImages.docs.isEmpty) {
      // User has not liked the image yet, add a like
      await _firestore.collection('images').doc(documentId).update({
        'likes': FieldValue.increment(1),
      });

      // Record the like in the user_likes collection
      await _firestore
          .collection('user_likes')
          .doc(user.uid)
          .collection('liked_images')
          .add({'imageId': documentId});

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('You liked the image!'),
        ),
      );
    } else {
      // User has already liked the image, revoke the like
      await _firestore.collection('images').doc(documentId).update({
        'likes':FieldValue.increment(-1),
      });

      // Remove the like from the user_likes collection
      await _firestore
          .collection('user_likes')
          .doc(user.uid)
          .collection('liked_images')
          .doc(likedImages.docs.first.id)
          .delete();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('You revoked the like!'),
        ),
      );
    }
  }
}
