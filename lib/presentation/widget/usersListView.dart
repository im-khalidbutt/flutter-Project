import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_project/presentation/component/customButton.dart';
import 'package:flutter_project/presentation/widget/userPosts.dart';
import 'package:flutter_project/presentation/widget/userTodos.dart';
import 'package:flutter_project/presentation/widget/usersAlbum.dart';
import 'package:http/http.dart' as http;

class UsersListView extends StatefulWidget {
  const UsersListView({super.key});

  @override
  State<UsersListView> createState() => _UsersListViewState();
}

class _UsersListViewState extends State<UsersListView> {
  List usersList = [];
  @override
  void initState(){
    super.initState();
    fetchUsersList();
  }

  void fetchUsersList() async {
    final userListResponse = await http.get(Uri.parse('https://jsonplaceholder.typicode.com/users'));
    if (userListResponse.statusCode == 200){
      setState(() {
        usersList = json.decode(userListResponse.body);
      });
    }else {
      throw Exception('Failed to load data');
    }
  }
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text("Users List", style: TextStyle(color: Colors.white),)),
        backgroundColor: Colors.blue,
        // leadingWidth: 20,
      ),
      body: ListView.builder(
          itemCount: usersList.length,
          itemBuilder: (context, index){
            final user = usersList[index];
            return  Card(
              child: ListTile(
                title: Text(user['name'], style: TextStyle(fontWeight: FontWeight.bold),),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(user['email']),
                    Text(
                        'Address: ${user['address']['street']}, ${user['address']['suite']}, ${user['address']['city']}'),
                    SizedBox(height: 10,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: CustomButton(
                            colorName: Colors.white,
                            btnName: "Posts",
                            onPressed:  () {
                              print('sss');
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => UserPosts(userId: user['id']),
                                ),
                              );
                            }, iconName: Icon(Icons.message,
                              color: Colors.white),
                          ),
                        ),

                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: CustomButton(
                            colorName: Colors.white,
                            btnName: "Albums",
                            onPressed:  () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AlbumsScreen(userId: user['id']),
                                ),
                              );
                            }, iconName: Icon(Icons.album,
                              color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: CustomButton(
                            colorName: Colors.white,
                            btnName: "Todos",
                            onPressed:  () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => UserTodos(userId: user['id']),
                                ),
                              );
                              print('Todos');
                            }, iconName: Icon(Icons.checklist,
                              color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                    
                  ],
                ),
                leading: Transform.translate(
                  offset: Offset(-5, -90),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                      child : Material(
                        child : InkWell(
                          child : Padding(
                              padding : const EdgeInsets.all(5),
                              child : Icon(
                              Icons.person,
                            ),
                          ),
                        // onTap : () {},
                      ),
                    ),
                  ),
                ),

                // trailing: IconButton(icon: Icon(Icons.arrow_forward), onPressed: () {
                //   print('hello');
                //     // Navigator.push(context, MaterialPageRoute(builder: (context) => DetailsPage(index: index))) ;
                // },)

              ),
            );
          }),
    );
  }
}
