import 'package:flutter/material.dart';

import '../model/post.dart';

class PostItem extends StatelessWidget {
  final Post post;
  PostItem(this.post);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Text("${post.id}"),
      title: Text(post.title),
      subtitle: Text(post.body),
    );
  }
}
