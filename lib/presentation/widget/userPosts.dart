// import 'package:flutter/material.dart';
//
// class UserPosts extends StatelessWidget {
//   final int userId;
//
//   UserPosts({required this.userId});
//
//   // Implement the logic to fetch and display user posts here
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('User Posts'),
//       ),
//       body: Center(
//         child: Text('Implement logic to fetch and display user posts here'),
//       ),
//     );
//   }
// }
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class UserPosts extends StatefulWidget {
  final int userId;

  const UserPosts({super.key, required this.userId});

  @override
  State<UserPosts> createState() => _UserPostsState();
}

class _UserPostsState extends State<UserPosts> {
  List<dynamic> posts = [];
  Map<int, List<dynamic>> commentsByPostId = {};
  List<dynamic> comments = [];
  Map<int, bool> isExpandedMap = {};

  @override
  void initState() {
    super.initState();
    fetchPosts();
    fetchComments();
  }

  Future<void> fetchPosts() async {
    final response = await http.get(Uri.parse('https://jsonplaceholder.typicode.com/posts?userId=${widget.userId}'));

    if (response.statusCode == 200) {
      setState(() {
        posts = json.decode(response.body);
        isExpandedMap = Map<int, bool>.fromIterable(posts, key: (post) => post['id'], value: (_) => false);
      });
    } else {
      throw Exception('Failed to load posts');
    }
  }

  Future<void> fetchComments() async {
    final response = await http.get(Uri.parse('https://jsonplaceholder.typicode.com/comments'));

    if (response.statusCode == 200) {
      setState(() {
        comments = json.decode(response.body);
        commentsByPostId = groupCommentsByPostId(comments);

      });
    } else {
      throw Exception('Failed to load comments');
    }
  }
  List<dynamic> getCommentsForPost(int postId) {
    return comments.where((comment) => comment['postId'] == postId).take(3).toList();
  }


  Map<int, List<dynamic>> groupCommentsByPostId(List<dynamic> allComments) {
    Map<int, List<dynamic>> groupedComments = {};
    for (var comment in allComments) {
      final postId = comment['postId'];
      groupedComments.putIfAbsent(postId, () => []);
      groupedComments[postId]!.add(comment);
    }
    return groupedComments;
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Posts'),
      ),
      body: ListView.builder(
        itemCount: posts.length,
        itemBuilder: (context, index) {
          final post = posts[index];
          final postId = post['id'];

          return Card(
            margin: EdgeInsets.all(8.0),
            child: ExpansionPanelList.radio(
              elevation: 1,
              expandedHeaderPadding: EdgeInsets.all(0),
              expansionCallback: (int panelIndex, bool isExpanded) {
                setState(() {
                  isExpandedMap[postId] = !isExpanded;
                });
              },
              children: [
                ExpansionPanelRadio(
                  headerBuilder: (BuildContext context, bool isExpanded) {
                    return ListTile(
                      title: Text(post['title'], style: TextStyle(fontSize: 20),),
                    );
                  },
                  value: post['body'],
                  body: Column(
                    children: (commentsByPostId[postId] ?? []).take(3).map((comment) {
                      return ListTile(

                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(comment['name'], style: TextStyle(fontWeight: FontWeight.bold)),
                            SizedBox(height: 10,),
                            Text(comment['body']),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
