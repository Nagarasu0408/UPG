import 'package:flutter/material.dart';

class LikeButtonProvider extends ChangeNotifier {
  bool _isLiked = false;

  bool get isLiked => _isLiked;

  void toggleLike() {
    _isLiked = !_isLiked;
    notifyListeners();
  }
}

class LikeButton extends StatelessWidget {
  final LikeButtonProvider likeButtonProvider = LikeButtonProvider();

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        likeButtonProvider.isLiked
            ? Icons.favorite
            : Icons.favorite_border,
        color: likeButtonProvider.isLiked ? Colors.red : null,
      ),
      onPressed: () {
        likeButtonProvider.toggleLike();
      },
    );
  }
}
