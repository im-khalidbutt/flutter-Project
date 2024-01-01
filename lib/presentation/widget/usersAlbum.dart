import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

// void main() {
//   runApp(MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: AlbumsScreen(),
//     );
//   }
// }

class AlbumsScreen extends StatefulWidget {
  final int userId;

  AlbumsScreen({required this.userId});


  @override
  _AlbumsScreenState createState() => _AlbumsScreenState();
}

class _AlbumsScreenState extends State<AlbumsScreen> {
  List<dynamic> albums = [];

  @override
  void initState() {
    super.initState();
    fetchAlbums();
  }

  Future<void> fetchAlbums() async {
    final response = await http.get(Uri.parse('https://jsonplaceholder.typicode.com/albums?userId=${widget.userId}'));

    if (response.statusCode == 200) {
      setState(() {
        albums = json.decode(response.body);
      });
    } else {
      throw Exception('Failed to load albums');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Albums'),
      ),
      body: ListView.builder(
        itemCount: albums.length,
        itemBuilder: (context, index) {
          final album = albums[index];

          return ListTile(
            title: Text(album['title']),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PhotosScreen(albumId: album['id'], albumTitle: album['title'])),
              );
            },
            leading: Transform.translate(
              offset: Offset(-5, 0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(50),
                child : Material(
                  child : InkWell(
                    child : Padding(
                      padding : const EdgeInsets.all(5),
                      child : Icon(
                        Icons.album,
                      ),
                    ),
                    // onTap : () {},
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class PhotosScreen extends StatefulWidget {
  final int albumId;
  final String albumTitle;

  PhotosScreen({required this.albumId, required this.albumTitle});

  @override
  _PhotosScreenState createState() => _PhotosScreenState();
}

class _PhotosScreenState extends State<PhotosScreen> {
  List<dynamic> photos = [];

  int getCrossAxisCount() {
    int kisweb;
    try{
      if(Platform.isAndroid||Platform.isIOS) {
        kisweb=2;
      } else {
        kisweb=4;
      }
    } catch(e){
      kisweb=4;
    }
    return kisweb;
    // if (Platform.isIOS || Platform.isAndroid) {
    //   return 2; // Set to 2 for iOS and Android
    // } else {
    //   return 4; // Default to 4 for other platforms
    // }
  }

  @override
  void initState() {
    super.initState();
    fetchPhotos();
  }

  Future<void> fetchPhotos() async {
    print(widget.albumId);
    print(widget.albumId);
    final response = await http.get(Uri.parse('https://jsonplaceholder.typicode.com/photos?albumId=${widget.albumId}'));

    if (response.statusCode == 200) {
      setState(() {
        photos = json.decode(response.body);
      });
    } else {
      throw Exception('Failed to load photos');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Photos'),
      ),
      body: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: getCrossAxisCount(),
          crossAxisSpacing: 8.0,
          mainAxisSpacing: 8.0,
        ),
        itemCount: photos.length,
        itemBuilder: (context, index) {
          return Card(
            elevation: 4.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.vertical(top: Radius.circular(8.0)),
                    child: Image.network(
                      photos[index]['thumbnailUrl'],
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    photos[index]['title'],
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 12.0),
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