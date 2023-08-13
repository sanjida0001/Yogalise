// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/controller/firestore_service.dart';
import 'package:flutter_application_1/models/model.user.dart';
import 'package:flutter_application_1/utils/my_colors.dart';
import 'package:flutter_application_1/utils/my_screensize.dart';
import 'package:flutter_application_1/widgets/my_widget.dart';
import 'package:getwidget/components/avatar/gf_avatar.dart';
import 'package:getwidget/components/card/gf_card.dart';
import 'package:getwidget/components/list_tile/gf_list_tile.dart';
import 'package:getwidget/components/text_field/gf_text_field.dart';
import 'package:getwidget/getwidget.dart';
import 'package:getwidget/shape/gf_avatar_shape.dart';
import 'package:logger/logger.dart';

import '../../../models/model.post.dart';

class CommentsPage extends StatefulWidget {
  final Post post;
  final UserData userData;
  const CommentsPage({super.key, required this.post, required this.userData});

  @override
  State<CommentsPage> createState() => _CommentsPageState();
}

class _CommentsPageState extends State<CommentsPage> {
  final TextEditingController _editingControllerComment =
      TextEditingController();
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  late Post _post;
  late UserData _userData;
  List<Commenter>? _comments;
  final ScrollController _scrollController = ScrollController();
  Logger? logger;

  @override
  void initState() {
    super.initState();
    _post = widget.post;
    _userData = widget.userData;

    mLoadData();
    // mControlListViewScrolling();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: vAppBar(),
      body: Container(
        padding: EdgeInsets.all(8),
        child: _comments == null
            ? MyWidget.vCommentShimmering(context: context)
            : Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  vInputComment(),
                  _comments!.isEmpty ? vNoResultFound() : vAllComments(),
                ],
              ),
      ),
    );
  }

  PreferredSizeWidget vAppBar() {
    return AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: MyColors.bluishBlackColor),
        // titleTextStyle: TextStyle(color: MyColors.secondColor),
        title: const Text(
          "Comments",
          style: TextStyle(color: MyColors.bluishBlackColor),
        ));
  }

  Widget vAllComments() {
    return Expanded(
        child: ListView.builder(
            controller: _scrollController,
            reverse: false,
            itemCount: _comments!.length,
            itemBuilder: (context, index) {
              Commenter commenter = _comments![index];
              return vItem(commenter);
            }));
  }

  Widget vItem(Commenter commenter) {
    return Column(
      children: [
        GFListTile(
          shadow: BoxShadow(color: Colors.white),
          padding: EdgeInsets.all(0),
          margin: EdgeInsets.only(left: 12, right: 4, top: 8),
          color: Colors.white,
          avatar: Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: MyColors.bluishBlackColor,
                  width: .8,
                )),
            child: GFAvatar(
                backgroundColor: Colors.white,
                backgroundImage: AssetImage('assets/images/user.png'),
                size: 28,
                shape: GFAvatarShape.circle),
          ),
          title: GFCard(
            elevation: 0,
            padding: EdgeInsets.symmetric(vertical: 2, horizontal: 2),
            margin: EdgeInsets.symmetric(vertical: 4, horizontal: 6),
            content: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                color: const Color.fromARGB(17, 0, 0, 0),
              ),
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.symmetric(vertical: 8, horizontal: 14),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      commenter.user!.username!,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Text(commenter.text!),
                    /*  Text(
                        "a Hindu spiritual and ascetic discipline, a part of which, including breath control, simple meditation, and the adoption of specific bodily postures, is widely practised for health and relaxation. she enjoys doing yoga to start the day"),
                   */
                  ]),
            ),
          ),
          /* titleText: commenter.user!.username,
          description:  */
        ),
        SizedBox(
          height: 6,
        ),
        Divider(
          thickness: 1,
          color: Colors.black26,
          height: 1,
        )
      ],
    );
  }

  Widget vInputComment() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: GFTextField(
        controller: _editingControllerComment,
        maxLines: 2,
        maxLength: 500,
        decoration: InputDecoration(
            contentPadding:
                EdgeInsets.only(left: 12, bottom: 24, top: 24, right: 18),
            border: OutlineInputBorder(),
            hintText: "Write a comment",
            suffixIcon: IconButton(
              onPressed: () {
                mOnClickSendComment();
              },
              icon: Icon(
                Icons.send_and_archive_outlined,
                size: 36,
                color: MyColors.pureGreenColor,
              ),
              color: Colors.black45,
            )),
        /* decoration: InputDecoration(border: OutlineInputBorder()) */
      ),
    );
  }

  void mOnClickSendComment() async {
    if (_editingControllerComment.value.text.isNotEmpty) {
      String comment = _editingControllerComment.value.text.trim();
      Commenter commenter = Commenter(
          // email: _post.email!,
          email: _userData.email!,
          text: comment,
          ts: DateTime.now().millisecondsSinceEpoch.toString());
      await MyFirestoreService.mStoreCommentData(
        firebaseFirestore: _firebaseFirestore,
        postId: _post.postId!,
        commenter: commenter,
      ).then((value) async {
        if (value) {
          // c: clear comment box
          _editingControllerComment.clear();
          // c: add current user's data to commenter object
          // commenter.user = _post.users;
          commenter.user = widget.userData;
          // c: add new commenter object into comments list
          _comments!.add(commenter);
// refresh
          setState(() {});

          await Future.delayed(Duration(milliseconds: 1000));
          // c: comments list view scrolled to up
          mScrollDown();
        }
      });
    }
  }

  void mLoadData() async {
    MyFirestoreService.mFetchAllComments(
            firebaseFirestore: _firebaseFirestore, postId: _post.postId!)
        .then((comments) {
      setState(() {
        _comments = comments;
      });
    });
  }

  Widget vNoResultFound() {
    return Expanded(
      child: Center(
        child: Text(
          "No comment found.",
          style: TextStyle(
              color: Colors.black45, fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  void mControlListViewScrolling() {
    _scrollController.addListener(mScrollListener);
  }

  void mScrollListener() {}

  // Scroll down on button click
  void mScrollDown() {
    _scrollController.animateTo(
      /* double.parse(_comments!.length.toString()) */
      _scrollController.position.maxScrollExtent,
      duration: Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

// Scroll up on button click
  void mScrollUp() {
    _scrollController.animateTo(
      0,
      duration: Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }
}
