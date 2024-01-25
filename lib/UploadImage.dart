import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';


class UploadImages extends StatelessWidget {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final ImagePicker _picker = ImagePicker();
   UploadImages({super.key});


  @override
  Widget build(BuildContext context) {
    return  Center(
      child: ElevatedButton(
        onPressed: () {

        },
        child:const Text('Upload Image'),
      ),
    );
  }
}

//
//
// import 'dart:io';
//
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
//
// class UploadImagePage extends StatefulWidget {
//   final User user;
//
//   const UploadImagePage({Key? key, required this.user}) : super(key: key);
//
//   @override
//   _UploadImagePageState createState() => _UploadImagePageState();
// }
//
// class _UploadImagePageState extends State<UploadImagePage> {
//   final _picker = ImagePicker();
//   final _storage = FirebaseStorage.instance;
//   final _firestore = FirebaseFirestore.instance;
//
//   @override
//   Widget build(BuildContext context) {
//     // Your build logic here
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Upload Image Page'),
//       ),
//       body: Center(
//         child: ElevatedButton(
//           onPressed: () {
//             _uploadImage(context);
//           },
//           child: Text('Upload Image'),
//         ),
//       ),
//     );
//   }
//
//   void _uploadImage(BuildContext context) async {
//     try {
//       final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
//
//       if (pickedFile == null) {
//         // User canceled image selection
//         return;
//       }
//
//       var user = widget.user;
//       var timestamp = DateTime.now().millisecondsSinceEpoch;
//
//       var ref = _storage.ref().child('images/$timestamp.jpg');
//       var uploadTask = ref.putFile(File(pickedFile.path));
//
//       showDialog(
//         context: context,
//         barrierDismissible: false,
//         builder: (BuildContext context) {
//           return AlertDialog(
//             content: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Text('Uploading Image...'),
//                 SizedBox(height: 16),
//                 CircularProgressIndicator(),
//               ],
//             ),
//           );
//         },
//       );
//
//       // Listen for changes in the upload state
//       uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
//         if (snapshot.state == TaskState.success) {
//           Navigator.of(context).pop(); // Close the loading indicator
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(
//               content: Text('Image uploaded successfully!'),
//             ),
//           );
//         }
//       });
//
//       var imageUrl = await (await uploadTask).ref.getDownloadURL();
//
//       await _firestore.collection('images').add({
//         'url': imageUrl,
//         'likes': 0,
//         'uploadedBy': user.uid,
//       });
//     } catch (error) {
//       Navigator.of(context).pop(); // Close the loading indicator on error
//       print(error);
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('Error uploading image. Please try again.'),
//         ),
//       );
//     }
//   }
// }
