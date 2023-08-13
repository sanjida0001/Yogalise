// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_application_1/controller/my_services.dart';
import 'package:flutter_application_1/screens/learn%20yoga/page/dlg.video_player.dart';
import 'package:flutter_application_1/utils/my_colors.dart';
import 'package:flutter_application_1/widgets/my_widget.dart';
import 'package:getwidget/getwidget.dart';

import '../../models/model.art_guide.dart';

class ArtGuideScreen extends StatefulWidget {
  const ArtGuideScreen({super.key});

  @override
  State<ArtGuideScreen> createState() => _ArtGuideScreenState();
}

class _ArtGuideScreenState extends State<ArtGuideScreen> {
  List<ArtGuide>? _listArtGuides;

  @override
  void initState() {
    super.initState();
    logger.v("init: Art Guide Screen");

    mLoadData();
  }

  @override
  Widget build(BuildContext context) {
    logger.v("Build: Art Guide Screen");
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: MyColors.bluishBlackColor),
        elevation: 0,
        title: Text(
          "Learn Yoga",
          style: TextStyle(color: MyColors.bluishBlackColor),
        ),
      ),
      body: vHome(),
    );
  }

  vHome() {
    return _listArtGuides == null
        ? MyWidget.vCommentPaginationShimmering(context: context)
        : GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 1
              /*   childAspectRatio: MediaQuery.of(context).size.width /
                  (MediaQuery.of(context).size.height / 4), */
            ),
            itemCount: _listArtGuides!.length,
            itemBuilder: (BuildContext context, int index) {
              final artGuide = _listArtGuides![index];
              return InkWell(
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return VideoPlayerScreen(
                            videoUrl: artGuide.videoUrl!,
                            title: artGuide.title!);
                      });

                },
                child: GFCard(
                  
                  margin: EdgeInsets.all(8),
                  padding: EdgeInsets.only(right: 6,left: 6, top: 10 ),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Image(image: AssetImage(""))
                      Icon(
                        Icons.play_lesson,
                        color: Colors.redAccent,
                        size: 48,
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      Text(
                        artGuide.title!,
                        style: TextStyle(color: MyColors.bluishBlackColor),
                      )
                    ],
                  ),
                ),
              );
              /* GFListTile(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => VideoPlayerScreen(
                          videoUrl: artGuide.videoUrl!, title: artGuide.title!),
                    ),
                  );
                },
                color: Colors.white,
                icon: GFAvatar(
                  backgroundColor: Colors.red,
                  shape: GFAvatarShape.standard,
                  child: Icon(
                    Icons.play_arrow,
                    color: Colors.white,
                  ),
                ),
                titleText: artGuide.title,
              ); */
              /*  ListTile(
          title: Text('Video $index'),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => VideoPlayerScreen(videoUrl: artGuide.videoUrl!, title: artGuide.title!),
              ),
            );
          },
        ); */
            },
          );
  }

  void mLoadData() async {
    MyServices.mParseJsonData().then((value) {
      if (value.isNotEmpty) {
        setState(() {
          _listArtGuides = value;
        });
      }
    });
  }
}
