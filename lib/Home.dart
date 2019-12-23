import 'dart:convert';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:youtube_extractor/youtube_extractor.dart';

class Home extends StatefulWidget{
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  var musicList=[],current_index;
  int Isplaying,Ispause;
  AudioPlayer audioPlayer = AudioPlayer();
  var extractor = YouTubeExtractor();
  final iconColour=Colors.white;
  var searchKeyword="Dj+Snake",previousSearchKeyword,searchResults,searchResultsVideo,musicLink,videoThumbnail;
  bool isSearching=false,isPlaying=false;
  void fetchSearchResults() async
  {
   searchResults=await http.get("https://api.w3hills.com/youtube/search?keyword=${searchKeyword}&api_key=0B309769-259B-E40C-0D0E-6DAB2354C322");
   searchResultsVideo=jsonDecode(searchResults.body)["videos"];
//   for(int i=0;i<searchResultsVideo.length;i++){
//     var videoData=searchResultsVideo[i];
//     musicList.add(videoData["id"]);
//     print(musicList[i]);
//   }
   setState(() {

   });
  }
  void getMusicLink (String videoId)async{
    var streamInfo = await extractor.getMediaStreamsAsync(videoId);
    videoThumbnail="https:\/\/img.youtube.com\/vi\/${videoId}\/mqdefault.jpg";
    musicLink=streamInfo.audio.first.url;
    setState(() {

    });
    play();
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Center(
          child:!isSearching? Text("LM Music",textAlign: TextAlign.center,style: TextStyle(
            color: Colors.black,
          ),):TextFormField(
            autocorrect: false,
            autofocus: true,
            onChanged: (newText){
              setState(() {
                searchKeyword=newText;
              });
            },
            decoration: InputDecoration(
              hintText: "Enter Song Name",
              focusColor: Colors.black,
              hoverColor: Colors.black,
              fillColor: Colors.black,

            )
          ),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            color: Colors.black,
            onPressed: (){
              if(isSearching==false) {
                setState(() {
                  isSearching=!isSearching;
                });
              }else{
                  fetchSearchResults();
                  setState(() {
                  isSearching=!isSearching;
                });
              }
            },
          )
        ],
      ),
      drawer: !isSearching?Drawer():null,
      body: Container(
        child: Stack(
          children: <Widget>[
            Positioned(
              child: Center(
                child: searchResultsVideo!=null? Container(
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          colors: [Colors.deepPurple,Colors.purpleAccent]
                      )
                  ),
                  child:ListView.builder(itemCount: searchResultsVideo.length,itemBuilder: (context,index) {
                    var videoData=searchResultsVideo[index];
                    var videoId="${videoData["id"]}";
                    musicList.add(videoId);
                    double time=videoData["duration"]/60;
                    return Card(
                      child: ListTile(
                        leading:CircleAvatar(

                          backgroundImage: (
                          NetworkImage(videoData["thumbnail"])
                          ),
                        ) ,
                        title: Text("${videoData["title"]}"),
                        subtitle: Text(time.toString().substring(0,3)),
                        onTap: (){
                          current_index=index;
                          getMusicLink(videoData["id"]);
                            setState(() {
                              isPlaying=false;
                            });

                        },
                      ),
                    );
                  },)
                ):Container(
                child: CircularProgressIndicator(),
                ),
              ),
            ),
//            (!isPlaying)?
            Positioned(
              bottom: 0,
              height: 60,
              width: 400,
              child: Container(
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        colors: [Colors.blue,Colors.pinkAccent]
                    )
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    CircleAvatar(
                      backgroundImage: NetworkImage("${videoThumbnail}"),
//                      radius: 50,
                    ),
//                    SizedBox(
//                      width: 6,
//                    ),
                    Row(
                      children: <Widget>[
                        IconButton(
                          icon: Icon(Icons.chevron_left,size: 40,color: iconColour),
                          onPressed: (){
                            setState(() {
                              current_index=current_index-1;
                            });
                            audioPlayer.stop();
                            if(current_index>=0) {
                              getMusicLink(musicList[current_index]);
                            }
                          },
                        ),
                        IconButton(
                          icon: Icon(isPlaying?Icons.play_arrow:Icons.pause,size: 40,color: iconColour),
                          onPressed: (){

                            if(!isPlaying){
                              setState(() {
                                audioPlayer.pause();
                                isPlaying=!isPlaying;
                                setState(() {

                                });
                              });
                            }else{
                              setState(() {
                                audioPlayer.resume();
                                isPlaying=!isPlaying;
                                setState(() {

                                });
                              });
                            }
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.chevron_right,size: 40,color: iconColour,),
                          onPressed: (){

                            setState(() {
                              current_index=current_index+1;
                            });
                            audioPlayer.stop();
                            if(current_index<=musicList.length){
                              getMusicLink(musicList[current_index]);
                            }
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            )
//                :Positioned(
//              height: 0.0,
//              width: 0.0,
//              child: Container(
//
//              ),
//            )
          ],
        ),
      ),
    );
  }
  play() async{

    Isplaying = await audioPlayer.play(musicLink);
    if (Isplaying == 1) {
      setState(() {
          isPlaying=false;
      });
    }
  }
}