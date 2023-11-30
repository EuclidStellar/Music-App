
import 'dart:convert';
import 'package:audioplayers/audioplayers.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:music_dev/model.dart';

class MusicApp extends StatefulWidget {
  @override
  _MusicAppState createState() => _MusicAppState();
}

class _MusicAppState extends State<MusicApp> {
  late Future<List<Track>> tracks;
  TextEditingController searchController = TextEditingController();
  AudioPlayer audioPlayer = AudioPlayer();  
  bool isPlaying = false;  

  @override
  void initState() {
    super.initState();
    tracks = fetchTracks();
  }

  Future<List<Track>> fetchTracks() async {
    var headers = {
      'X-RapidAPI-Key': '6a506bf363msh70b280c80245a2ap15b295jsn61aff7c2dc6e',
      'X-RapidAPI-Host': 'shazam.p.rapidapi.com'
    };
    var response = await http.get(
      Uri.parse('https://shazam.p.rapidapi.com/search?term=${searchController.text}&locale=en-US&limit=5&offset=0'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      final List<dynamic> hits = jsonDecode(response.body)['tracks']['hits'];
      return hits.map((hit) => Track.fromJson(hit)).toList();
    } else {
      throw Exception('Failed to load tracks');
    }
  }

  void onSearchButtonPressed() {
    setState(() {
      tracks = fetchTracks();
    });
  }

  void playPausePreview(String previewUrl) {
    if (isPlaying) {
      audioPlayer.pause();
    } else {
      audioPlayer.play(UrlSource(previewUrl));
    }
    setState(() {
      isPlaying = !isPlaying;
    });
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Music App'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: searchController,
                    decoration: InputDecoration(
                      hintText: 'Enter song name',
                    ),
                  ),
                ),
                SizedBox(width: 8),
                ElevatedButton(
                  onPressed: onSearchButtonPressed,
                  child: Text('Search'),
                ),
              ],
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Track>>(
              future: tracks,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else {
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      return MusicCard(
                        track: snapshot.data![index],
                        onPlayPressed: () => playPausePreview(snapshot.data![index].previewUrl),
                        isPlaying: isPlaying,
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

class MusicCard extends StatelessWidget {
  final Track track;
  final VoidCallback onPlayPressed;
  final bool isPlaying;

  const MusicCard({Key? key, required this.track, required this.onPlayPressed, required this.isPlaying}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CachedNetworkImage(
            imageUrl: track.imageUrl,
            placeholder: (context, url) => CircularProgressIndicator(),
            errorWidget: (context, url, error) => Icon(Icons.error),
          ),
          Padding(
            padding: EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  track.title,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 4),
                Text(
                  track.subtitle,
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
                SizedBox(height: 8),
                ElevatedButton(
                  onPressed: onPlayPressed,
                  child: Text(isPlaying ? 'Pause' : 'Play Preview'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
