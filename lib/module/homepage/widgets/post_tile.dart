import 'package:flutter/material.dart';
import 'package:nsdevil_project/module/homepage/models/post.dart';

class PostTile extends StatelessWidget {
  const PostTile({super.key, required this.post});

  final Post post;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(child: Text(post.id.toString())),
        title: Text(
          post.title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        subtitle: Text(
          post.tags.join(', '),
          style: const TextStyle(fontStyle: FontStyle.italic),
        ),
        onTap: () {
          Navigator.pushNamed(context, "postDetailScreen", arguments: post);
        },
      ),
    );
  }
}
