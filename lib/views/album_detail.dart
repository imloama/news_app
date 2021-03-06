import 'package:flutter/material.dart';
import '../util/image_util.dart';
import '../components/cycle_list_header.dart';
import '../components/nav_button.dart';
import '../util/color_util.dart';
import '../models/album.dart';
import '../net/httpclient.dart';
import '../net/http_config.dart';
import '../models/song.dart';
import 'artist_detail.dart';
import '../components/single_photo_view.dart';
import '../components/music_player.dart';
import '../components/over_scroll_behavior.dart';

class AlbumDetailPage extends StatefulWidget {
  final Album album;
  AlbumDetailPage(this.album);
  @override
  _AlbumDetailPageState createState() => _AlbumDetailPageState();
}

class _AlbumDetailPageState extends State<AlbumDetailPage> {
  Album album;
  VoidCallback playOnTap;
  int songSize = 0;

  List<Song> songList= List.generate(0, (index) {
    return Song("$index", "", defaultMusicImage,"", null);
  });


  _getAlbum(){
    album = widget.album;
    HttpClient.get(GET_ALBUM_URL+album.id, (result){
      if(mounted){
        setState(() {
          this.songList = AlbumSong.fromJson(result).songs;
          this.songSize = songList.length;
        });
      }
    },errorCallBack: (error){
      print(error);
    });
  }

  @override
  void initState(){
    _getAlbum();
    super.initState();
  }

  Widget getSeq(int index){
    index = index + 1;
    return Padding(padding: EdgeInsets.all(10), child: Text("$index"));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading:GestureDetector(
          child: Icon(Icons.arrow_back),
          onTap: (){
            Navigator.of(context).pop();
          },
        ),
        // title: Text(cast?.name??""),
        backgroundColor: detailPageBGColor,
        elevation:0,
        actions: <Widget>[
          buildHomeNavButton(context)
        ],
      ),
      body: ScrollConfiguration(
        behavior: OverScrollBehavior(),
        child: CustomScrollView(
          slivers: <Widget>[
            SliverList(
              delegate: SliverChildBuilderDelegate((context, index){
                if(index == 0){
                  return Column(
                    children: <Widget>[
                      getItem(),
                    ],
                  );
                }
                return null;
              }
              )
            ),
            SliverToBoxAdapter(
              child: new Container(
                padding: EdgeInsets.only(top: 5, bottom: 0),
                child: CycleListHeader(
                  onTap: playOnTap,
                  count: songList.length,
                ),
                color: detailPageBGColor,
              ),
            ),
            SliverFixedExtentList(
              delegate: SliverChildListDelegate(songList.asMap().keys.map((index) {
                var tile = ListTile(
                  leading: getSeq(index),
                  title: Text(songList[index]?.name??"", overflow: TextOverflow.ellipsis, maxLines: 1,
                      style: TextStyle(fontSize: 16.0,decoration: TextDecoration.none)),
                  subtitle: Row(
                    children: <Widget>[
                      Text(album?.artistName??"", overflow: TextOverflow.ellipsis, maxLines: 1,
                          style: TextStyle(fontSize: 14.0,color:Colors.grey,fontStyle: FontStyle.normal,decoration: TextDecoration.none)),
                      Expanded(
                        child: Text(" - "+album?.name??"", overflow: TextOverflow.ellipsis, maxLines: 1,
                            style: TextStyle(fontSize: 14.0,color:Colors.grey,fontStyle: FontStyle.normal,decoration: TextDecoration.none)),
                      )
                    ],
                  ),
                  trailing: Icon(Icons.more_vert),
                );
                return GestureDetector(
                  child: tile,
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(
                        builder: (context) => MusicPlayer(songList,index)
                    ));
                  },
                );
              }).toList()),
              itemExtent: 70.0,
            ),

          ],
        ),
      ),
    );
  }

  Widget getItem() {
    var row = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  width: 200,
                  child: Text(
                    "${album?.name??""}",
                    style: TextStyle(
                        fontSize: 20,
                        color: detailPagePropTextColor
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                ),
                Row(
                  children: <Widget>[
                    Text("歌手：",
                      style: TextStyle(fontSize: 16,color: detailPagePropTextColor),
                      overflow: TextOverflow.ellipsis,maxLines: 1,
                    ),
                    GestureDetector(
                      child: Container(
                        width: 180,
                        child: Text("${album?.artistName??""} > ",
                          style: TextStyle(fontSize: 16,color: artistTextColor),
                          overflow: TextOverflow.ellipsis,maxLines: 1,
                        ),
                      ),
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(
                          builder: (context) => new ArtistDetailPage(album?.artists[0].id)
                        ));
                      },
                    ),
                  ],
                ),

              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  width: 200,
                  child: Text(
                    "发行时间：${album?.pubTime??""}",
                    style: TextStyle(
                        fontSize: 16,
                        color: detailPagePropTextColor
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
                Container(
                  width: 200,
                  child: Text(
                    "发行公司：${album?.company??""}",
                    style: TextStyle(
                        fontSize: 16,
                        color: detailPagePropTextColor
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                ),
                Container(
                  width: 200,
                  child: Text(
                    "类型：${album?.type??""}",
                    style: TextStyle(
                        fontSize: 16,
                        color: detailPagePropTextColor
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
              ],
            )
          ],
        ),
        Column(
          children: <Widget>[
            Container(height: 20,),
            GestureDetector(
              child: Stack(
                alignment: Alignment.topCenter,
                overflow: Overflow.visible,
                children: <Widget>[
                  Container(
                    height: 110,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(100.0),
                      child: Image.asset("assets/record.jpg"),
                    ),
                  ),
                  Positioned(
                    top: 20,
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(5.0),
                        child: getCachedImage(album?.picUrl??defaultCastImage, width: 110, height: 130)
                    ),
                  )
                ],
              ),
              onTap: (){
                Navigator.push(context, MaterialPageRoute(
                    builder: (context) => SinglePhotoView(
                      imageProvider:NetworkImage(album?.picUrl??defaultBookImage),
                      heroTag: 'simple',
                    )
                ));
              },
            ),
          ],
        )
      ],
    );
    return Container(
      width: MediaQuery.of(context).size.width,
      color: detailPageBGColor,
      height: 200,
      margin: EdgeInsets.all(0.0),
      child: row,
    );
  }

}


