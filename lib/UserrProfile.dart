import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class UserProfilePage extends StatefulWidget {
  @override
  _UserProfilePageState createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  late User _user;
  late String _displayName;
  late String _photoUrl;
  int _followersCount = 0;
  int _followingCount = 0;

  @override
  void initState() {
    super.initState();
    _user = FirebaseAuth.instance.currentUser!;
    _displayName = _user.displayName ?? 'No Display Name';
    _photoUrl = _user.photoURL ?? '';
    _loadFollowCounts();
  }

  Future<void> _loadFollowCounts() async {
    // Load followers count
    int followersCount = await _getFollowersCount(_user.uid);

    // Load following count
    int followingCount = await _getFollowingCount(_user.uid);

    setState(() {
      _followersCount = followersCount;
      _followingCount = followingCount;
    });
  }

  Future<int> _getFollowersCount(String userId) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('followers')
        .doc(userId)
        .collection('userFollowers')
        .get();
    return querySnapshot.docs.length;
  }

  Future<int> _getFollowingCount(String userId) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('following')
        .doc(userId)
        .collection('userFollowing')
        .get();
    return querySnapshot.docs.length;
  }

  Future<void> _updateUserProfile(String imageUrl, String newDisplayName) async {
    bool isUnique = await _isDisplayNameUnique(newDisplayName);

    if (isUnique) {
      await FirebaseFirestore.instance.collection('users').doc(_user.uid).update({
        'displayName': newDisplayName,
        'photoUrl': imageUrl,
      });

      setState(() {
        _photoUrl = imageUrl;
        _displayName = newDisplayName;
      });
    } else {
      print('Display name is not unique. Choose another name.');
    }
  }

  Future<bool> _isDisplayNameUnique(String newDisplayName) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('displayName', isEqualTo: newDisplayName)
        .get();

    return querySnapshot.docs.isEmpty;
  }

  @override
  Widget build(BuildContext context) {
    return  Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage: _photoUrl.isNotEmpty
                  ? Image.network(_photoUrl).image
                  : AssetImage('assets/default-avatar.png'),
              child: _photoUrl.isEmpty
                  ?null
                  : null,
            ),
            SizedBox(height: 20),
            Text('Display Name: $_displayName'),
            SizedBox(height: 20),
            Text('Followers: $_followersCount'),
            Text('Following: $_followingCount'),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                await _updateUserProfile('New Image URL', 'New Display Name');
                await _loadFollowCounts();
              },
              child: Text('Change Profile'),
            ),
          ],
        );
  }
}

