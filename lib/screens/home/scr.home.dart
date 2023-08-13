// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/const/keywords.dart';
import 'package:flutter_application_1/controller/firestore_service.dart';
import 'package:flutter_application_1/controller/my_authentication_service.dart';
import 'package:flutter_application_1/models/model.post.dart';
import 'package:flutter_application_1/models/model.user.dart';
import 'package:flutter_application_1/screens/google_map/scr.map.dart';
import 'package:flutter_application_1/screens/home/pages/comments.dart';
import 'package:flutter_application_1/screens/learn%20yoga/scr.learn_yoga.dart';
import 'package:flutter_application_1/screens/myPosts/scr.my_posts.dart';
import 'package:flutter_application_1/screens/profile/scr_profile.dart';
import 'package:flutter_application_1/screens/signin/scr_signin.dart';
import 'package:flutter_application_1/utils/my_date_format.dart';
import 'package:flutter_application_1/widgets/my_widget.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:getwidget/getwidget.dart';
import 'package:logger/logger.dart';

import '../../utils/my_colors.dart';
import '../../utils/my_screensize.dart';
import '../yoga pose detection/scr.yoga_pose_detection.dart';
import 'widgets/dlg_rating.dart';

class HomeScreen extends StatefulWidget {
  // final User user;
  final UserData userData;
  const HomeScreen(
      {super.key, /* required this.user, */ required this.userData});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // final String _imgCategory = "all category";
  final String _imgCategory = "all poses";
  final Logger logger = Logger();
  late FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  bool _isMoreDataLoading = true;
  bool _isDataLoading = false;
  bool _isNoDataExist = false;
  String _dropDownValue = "all poses";
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  List<Post>? posts;
  late ScrollController _scrollController = ScrollController();
  late CollectionReference _collectionReferencePOST;
  late CollectionReference _collectionReferenceLIKER;
  final GFBottomSheetController _gfBottomSheetController =
      GFBottomSheetController();

// >>
  @override
  void initState() {
    super.initState();
    logger.d("I am Init");
    _collectionReferencePOST = firebaseFirestore.collection(MyKeywords.POST);
    _collectionReferenceLIKER = firebaseFirestore
        .collection(MyKeywords.POST)
        .doc()
        .collection(MyKeywords.LIKER);

    mLoadData(); // c: Load latest 10 posts from firebase firestore

    mControlListViewSrolling(); // c: Post listView scroll listener for control pagination

    mAddCollectionReferencePOSTListener();
    mAddCollectionReferenceLIKERListener();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    logger.v("Build: Landing Screen");
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          iconTheme: const IconThemeData(color: MyColors.bluishBlackColor),
          backgroundColor: Colors.white,
          elevation: 0,
          actions: [
            vActionItems(),
          ],
        ),
        drawer: Drawer(
            width: MyScreenSize.mGetWidth(context, 70), child: vDrawerItems()),
        bottomSheet: mShowBottomSheet(),
        floatingActionButton: FloatingActionButton(
            backgroundColor: GFColors.SUCCESS,
            child: _gfBottomSheetController.isBottomSheetOpened
                ? Icon(Icons.keyboard_arrow_down)
                : Icon(Icons.keyboard_arrow_up),
            onPressed: () {
              _gfBottomSheetController.isBottomSheetOpened
                  ? _gfBottomSheetController.hideBottomSheet()
                  : _gfBottomSheetController.showBottomSheet();
              // c: refresh
              /* setState(() {
                
              }); */
            }),
        body: vHome());
  }

  Widget vActionItems() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          // widget.user.displayName == null ? "User 1" : widget.user.displayName!,
          widget.userData.username ?? "User 1",

          style: const TextStyle(color: MyColors.bluishBlackColor),
        ),
        const SizedBox(
          width: 12,
        ),
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: MyColors.bluishBlackColor,
                width: .8,
              )),
          child: CircleAvatar(
            backgroundColor: Colors.white,
            backgroundImage: AssetImage(
              "assets/images/user.png",
            ),
          ),
        ),
        const SizedBox(
          width: 24,
        )
      ],
    );
  }

  Widget vDrawerItems() {
    return Container(
      color: Colors.white,
      // width: MyScreenSize.mGetWidth(context, 60),
      child: ListView(
        children: [
          vDrawerHeader(),
          ListTile(
            title: const Text("Home"),
            leading: const Icon(Icons.home),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: const Text(
              "My Posts",
            ),
            leading: const Icon(Icons.newspaper),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return MyPostsScreen(userData: widget.userData);
              }));
            },
          ),
          ListTile(
            title: const Text(
              "Map Iframe",
            ),
            leading: const Icon(Icons.share),
            onTap: () {
              Navigator.pop(context);
              Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                return MapIFrameScreen();
              }));
            },
          ),
          ListTile(
            title: const Text(
              "Feedback",
            ),
            leading: const Icon(Icons.feedback),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: const Text(
              "Sign out",
            ),
            leading: const Icon(Icons.arrow_back),
            onTap: () {
              mOnClickSignOut();
            },
          ),
        ],
      ),
    );
  }

  Widget vDrawerHeader() {
    return UserAccountsDrawerHeader(
      decoration: const BoxDecoration(color: MyColors.bluishBlackColor),
      accountName: Text(
        // widget.user.displayName == null ? "User " : widget.user.displayName!,
        widget.userData.username ?? "User 1",
      ),
      accountEmail: Text(
        widget.userData.email!,
      ),
      currentAccountPicture: CircleAvatar(
        child: widget.userData.imgUri != null
            ? Image(image: NetworkImage(widget.userData.imgUri!))
            : Image(image: AssetImage("assets/images/user.png")),
      ),
    );
  }

  mShowBottomSheet() {
    return GFBottomSheet(
      controller: _gfBottomSheetController,
      animationDuration: 500,
      maxContentHeight: 128,
      stickyHeaderHeight: MyScreenSize.mGetHeight(context, 5),
      stickyHeader: vStickyHeader(),
      contentBody: vContentBody(),
      stickyFooter: vStickyFooter(),
      stickyFooterHeight: 24,
    );
    /*  showModalBottomSheet(
        context: context,
        builder: (context) {
          return MyBottomSheet(callback:
              (String imgUri, String imgCategory, String caption) async {
            Post post = Post(
                email: widget.user.email,
                caption: caption,
                imgUri: imgUri,
                category: imgCategory,
                ts: DateTime.now().millisecondsSinceEpoch.toString());

            await MyFirestoreService.mUploadPost(
                    firebaseFirestore: firebaseFirestore, post: post)
                .then((value) async {
              if (value) {
                await Future.delayed(const Duration(milliseconds: 3000))
                    .then((value) {
                  // c: dismiss bottomSheet
                  Navigator.pop(context);
                });

                setState(() {
                  _isDataLoading = true;
                });
                await MyFirestoreService.mFetchInitialPost(
                        firebaseFirestore: firebaseFirestore,
                        category: "all category")
                    .then((value) {
                  posts!.clear;
                  setState(() {
                    posts = value;
                    _isDataLoading = false;
                  });
                });
              }
            });
          });
        }); */
  }

  Widget vPostList() {
    return Expanded(
        child: ListView.builder(
            controller: _scrollController,
            itemCount: posts!.length + 1,
            itemBuilder: ((context, index) {
              return index < posts!.length
                  ? /* index == 0
                      ? Padding(
                          padding: EdgeInsets.only(
                              top: MyScreenSize.mGetHeight(context, 11)),
                          child: vItem(index))
                      : */
                  vItem(index)
                  : posts!.length > 1 && !_isNoDataExist
                      // ? MyWidget.vPostPaginationShimmering(context: context)
                      ? vLoadMoreButton()
                      : Container();
            })

            /* 
            return index < posts!.length
                ? vItem(index)
                : posts!.length > 1
                    ? MyWidget.vPostPaginationShimmering(context: context)
                    : Container();
          } */

            ));
  }

  Widget vCategoryDropdown() {
    return Container(
      height: MyScreenSize.mGetHeight(context, 6),
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.only(bottom: 8, left: 12, right: 12),
      child: DropdownButtonHideUnderline(
        child: Row(
          children: [
            Expanded(
                child: Image(
              image: AssetImage("assets/images/ic_filter.png"),
              width: 24,
              height: 24,
            )),
            Expanded(
              flex: 5,
              child: vGFDropDown(),
            ),
          ],
        ),
      ),
    );
  }

  Widget vCatAndCap(Post post) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 54, vertical: 8),
      child: Column(
        children: [
          // v: category text

          Row(
            children: [
              Container(
                // height: MyScreenSize.mGetHeight(context, 1),
                padding: EdgeInsets.symmetric(vertical: 2, horizontal: 6),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                    color: MyColors.darkYellowColor),
                child: Text(
                  post.category!,
                  style: TextStyle(color: MyColors.bluishBlackColor),
                ),
              ),
            ],
          ),

          SizedBox(
            height: 4,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(post.caption!),
            ],
          ),
        ],
      ),
    );
  }

  Widget vItem(int index) {
    Post post = posts![index];
    return GFCard(
      // color: Colors.white,
      // margin: Edgeinsets.zero,
      margin: EdgeInsets.symmetric(vertical: 8),
      padding: EdgeInsets.zero,

      elevation: 1,
      boxFit: BoxFit.cover,
      titlePosition: GFPosition.start,
      image: Image.network(
        post.imgUri!,
        fit: BoxFit.cover,
      ),
      showImage: true,
      // showImage: false,
      title: GFListTile(
        margin: EdgeInsets.only(bottom: 6),
        // padding: EdgeInsets.zero,
        shadow: BoxShadow(color: Colors.white),
        color: Colors.white,
        avatar: GFAvatar(
          size: 24,
          backgroundImage: AssetImage('assets/images/user.png'),
        ),
        titleText: post.users!.username,
        // titleText: post.postId,
        subTitleText: mFormatDateTime(post),
      ),
      content: vCatAndCap(post),
      buttonBar: GFButtonBar(
        padding: EdgeInsets.all(6),
        spacing: 16,
        children: <Widget>[
          vLikeAndCommentButton(post),

          /*   vLikeButton(post),
          vCommentButton(post), */
        ],
      ),
    );
  }

  Widget vLikeButton(Post post) {
    return InkWell(
      onTap: () async {
        mOnClickLikeButton(post);
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          GFAvatar(
            backgroundColor: post.likeStatus!
                ? Colors.deepOrange
                : Colors.black12 /* GFColors.PRIMARY */,
            size: GFSize.SMALL,
            child: Icon(
              Icons.favorite_outline,
              color:
                  post.likeStatus! ? Colors.white : MyColors.bluishBlackColor,
            ),
          ),
          /*  SizedBox(
            height: 4,
          ),
          Text(
            "Likes",
            style: TextStyle(color: Colors.black54),
          ), */
          SizedBox(
            height: 4,
          ),
          post.numOfLikes == null
              ? Text(
                  "0",
                  style: TextStyle(color: Colors.black54),
                )
              : Text(
                  "${post.numOfLikes}",
                  style: TextStyle(color: Colors.black54),
                )
        ],
      ),
    );
  }

  Widget vCommentButton(Post post) {
    return InkWell(
      onTap: () {
        mOnClickCommentButton(post);
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          GFAvatar(
            size: GFSize.SMALL,
            backgroundColor: Colors.black12,
            child: Icon(
              Icons.comment,
              color: MyColors.bluishBlackColor,
            ),
          ),
          SizedBox(
            height: 4,
          ),
          Text(
            "Comments",
            style: TextStyle(color: Colors.black54),
          ),
          SizedBox(
            height: 4,
          ),
          post.numOfComments == null
              ? Text(
                  "0",
                  style: TextStyle(color: Colors.black54),
                )
              : Text(
                  "${post.numOfComments}",
                  style: TextStyle(color: Colors.black54),
                )
        ],
      ),
    );
  }

  void mOnClickCommentButton(Post post) {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return CommentsPage(
        userData: widget.userData,
        post: post,
      );
    }));
  }

  Widget vHome() {
    return Container(
      margin: EdgeInsets.only(bottom: MyScreenSize.mGetHeight(context, 4)),
      child: Column(
        children: [
          vCategoryDropdown(),
          SizedBox(
            height: 6,
          ),
          _isMoreDataLoading
              ? MyWidget.vPostShimmering(context: context)
              : posts == null || posts!.isEmpty
                  ? vNoResultFound()
                  : vPostList(),
          SizedBox(
            height: 24,
          )
        ],
      ),
    );
  }

  void mOnClickSignOut() async {
    await MyAuthenticationService.mSignOut(firebaseAuth: _firebaseAuth)
        .then((value) {
      if (value) {
        logger.w("Sign Out");
        Navigator.pop(context);
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) {
          return LoginScreen();
        }));
      }
    });
  }

  void mLoadData() async {
    logger.d("Loading post...");
    MyFirestoreService.mFetchInitialPost(
            userData: widget.userData,
            firebaseFirestore: firebaseFirestore,
            category: _imgCategory)
        .then((value) {
      setState(() {
        posts = value;
        /*  int i = posts!
            .indexWhere((element) => element.postId == "C71CC8DQdedbivs0kbXD");
        logger.d("Index is: $i"); */
        _isMoreDataLoading = false;
      });
    });
  }

  String mFormatDateTime(Post post) {
    int currentDate = DateTime.now().day;
    int uploadedDate =
        DateTime.fromMillisecondsSinceEpoch(int.parse(post.ts!)).day;
/*     MyDateForamt.mFormateDate2(
  
        DateTime.fromMillisecondsSinceEpoch(int.parse(post.ts!))); */
    const String today = "Today";
    const String yesterday = "Yesterday";

    if (currentDate == uploadedDate) {
      return today;
    } else if (uploadedDate == currentDate - 1) {
      return yesterday;
    } else {
      return MyDateForamt.mFormateDate2(
          DateTime.fromMillisecondsSinceEpoch(int.parse(post.ts!)));
    }
  }

  void mControlListViewSrolling() {
    // c: add a scroll listener to scrollController
    _scrollController.addListener(mScrollListener);
  }

  void mScrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      // c: Reached the end of the ListView
      // c: Perform any actions or load more data
      // c: You can trigger pagination or fetch more items here

      logger.w("End of List");
      mCheckMoreDataAvailability();
    }
  }

  void mLoadMore() async {
    await MyFirestoreService.mFetchMorePosts(
            userData: widget.userData,
            firebaseFirestore: firebaseFirestore,
            category: _dropDownValue,
            lastVisibleDocumentId: posts!.last.postId!)
        .then((value) {
      logger.w(value.length);
      if (value.isNotEmpty) {
        /*     List<Post> tempPosts = posts!;
        posts!.clear(); */
        setState(() {
          posts!.addAll(value);
        });
        // posts!.addAll(value);
      } else {
        logger.w("No Data exist");
        /*  ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("No Data exist"))); */
        setState(() {
          _isNoDataExist = true;
        });
      }
      _isMoreDataLoading = false;
    });
  }

  Future<void> mOnClickLikeButton(Post post) async {
    await MyFirestoreService.mStoreLikeData(
            firebaseFirestore: firebaseFirestore,
            // email: post.email!,
            email: widget.userData.email!,
            postId: post.postId!)
        .then((like) {
      if (like != null) {
        if (like) {
          // c: like
          logger.w("Like");
          posts![posts!.indexOf(post)].likeStatus = true;
        } else {
          // c: unlike
          logger.w("UnLike");
          posts![posts!.indexOf(post)].likeStatus = false;
        }
        // c: refresh
        setState(() {});
      }
    });
  }

  void mAddCollectionReferencePOSTListener() {
    _collectionReferencePOST.snapshots().listen((snapshot) {
      for (var docChange in snapshot.docChanges) {
        //c: Handle each change type
        if (docChange.type == DocumentChangeType.added) {
          logger.w("ADDED new item id: ${docChange.doc.id}");
        } else if (docChange.type == DocumentChangeType.modified) {
          logger.w("MODIFIED Post at ${docChange.doc.id}");
          var modifiedDocId = docChange.doc.id;
          int i =
              posts!.indexWhere((element) => element.postId == modifiedDocId);
          mUpdatePostData(docChange.doc, i);
          setState(() {});
          // logger.d("Index is: $i");
        }
      }
    });
  }

  void mAddCollectionReferenceLIKERListener() {
    _collectionReferenceLIKER.snapshots().listen((snapshot) {
      for (var docChange in snapshot.docChanges) {
        //c: Handle each change type
        if (docChange.type == DocumentChangeType.added) {
          logger.w("ADDED one item ${docChange.newIndex}");
        } else if (docChange.type == DocumentChangeType.modified) {
          setState(() {
            logger
                .w("MODIFIED one item ${docChange.doc.get(MyKeywords.email)}");
          });
        } else if (docChange.type == DocumentChangeType.removed) {
          setState(() {
            logger
                .w("REMOVED one item: ${docChange.doc.get(MyKeywords.email)}");
          });
        }
      }
    });
  }

  void mUpdatePostData(DocumentSnapshot<Object?> doc, int i) {
    posts![i].numOfLikes = doc.get(MyKeywords.num_of_likes);
    posts![i].numOfComments = doc.get(MyKeywords.num_of_comments);
    posts![i].ratings = doc.get(MyKeywords.ratings);
  }

  Widget vNoResultFound() {
    return Expanded(
      child: Center(
        child: Text(
          "No result found.",
          style: TextStyle(
              color: Colors.black45, fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  vContentBody() {
    return Container(
      height: 200,
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(horizontal: 6, vertical: 10),
      child: ListView(children: [
        Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return YogaPoseDetectionScreen(
                            userData: widget.userData,
                            firebaseFirestore: firebaseFirestore,
                          );
                        }));
                      },
                      child: GFCard(
                        margin: EdgeInsets.all(4),
                        padding: EdgeInsets.all(6),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Image(image: AssetImage(""))
                            Icon(
                              Icons.document_scanner,
                              color: MyColors.pureYellowColor,
                              size: 48,
                            ),
                            SizedBox(
                              height: 16,
                            ),
                            Text(
                              "Dectect Pose",
                              style:
                                  TextStyle(color: MyColors.bluishBlackColor),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return ArtGuideScreen();
                        }));
                      },
                      child: GFCard(
                        margin: EdgeInsets.all(4),
                        padding: EdgeInsets.all(6),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Image(image: AssetImage(""))
                            Icon(
                              Icons.lightbulb,
                              color: MyColors.pureYellowColor,
                              size: 48,
                            ),
                            SizedBox(
                              height: 16,
                            ),
                            Text(
                              "Learn Yoga",
                              style:
                                  TextStyle(color: MyColors.bluishBlackColor),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return ProfilePage(userData: widget.userData);
                        }));
                      },
                      child: GFCard(
                        margin: EdgeInsets.all(4),
                        padding: EdgeInsets.all(6),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Image(image: AssetImage(""))
                            Icon(
                              Icons.person,
                              color: MyColors.pureYellowColor,
                              size: 48,
                            ),
                            SizedBox(
                              height: 16,
                            ),
                            Text(
                              "My Profile",
                              style:
                                  TextStyle(color: MyColors.bluishBlackColor),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              )
            ]),
      ]),
    );
  }

  vStickyFooter() {
    return Container(
      color: MyColors.pureGreenColor,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          /* Text(
              'Get in touch',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ), */
          Text(
            '© 2023 Shanjida. All Rights Reserved.',
            style: TextStyle(fontSize: 12, color: Colors.white),
          ),
        ],
      ),
    );
  }

  vStickyHeader() {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [BoxShadow(color: Colors.black45, blurRadius: 0)]),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          Container(
              padding: EdgeInsets.symmetric(vertical: 5),
              height: MyScreenSize.mGetHeight(context, 0.5),
              width: MyScreenSize.mGetWidth(context, 20),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    offset: Offset(.5, .5),
                    blurRadius: 1,
                  )
                ],
              ))
        ],
      ),
    );
  }

  vGFDropDown() {
    return GFDropdown(
      isExpanded: true,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      /*           borderRadius: BorderRadius.circular(5),
                border: const BorderSide(color: Colors.black12, width: 1),
             */
      dropdownButtonColor: Colors.white,
      value: _dropDownValue,
      onChanged: (newValue) async {
        _dropDownValue = newValue!;
        logger.d("Clicked: $_dropDownValue");

        setState(() {
          _isMoreDataLoading = true;
        });
        await MyFirestoreService.mFetchInitialPost(
                userData: widget.userData,
                firebaseFirestore: firebaseFirestore,
                category: _dropDownValue)
            .then((value) {
          posts!.clear;
          setState(() {
            posts = value;
            _isMoreDataLoading = false;
          });
        });
      },
      items: [
        'all poses',
        '0 downdog',
        '1 goddess',
        '2 plank',
        '3 tree',
        '4 warrior2'
      ]
          .map((value) => DropdownMenuItem(
                value: value,
                child: Text(value),
              ))
          .toList(),
    );
  }

  vLikeAndCommentButton(Post post) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          vLikeButton1(post),
          SizedBox(
            width: 12,
          ),
          vCommentButton1(post),
          SizedBox(
            width: 12,
          ),
          vRatingButton1(post),
        ],
      ),
    );
  }

  vLikeButton1(Post post) {
    return Expanded(
      child: InkWell(
        onTap: () {
          mOnClickLikeButton(post);
        },
        child: GFCard(
          margin: EdgeInsets.zero,

          color: Colors.white,
          elevation: 0,
          // padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
          padding: EdgeInsets.zero,
          title: GFListTile(
              color: Color.fromARGB(22, 0, 0, 0),
              radius: 50,
              shadow: BoxShadow(color: Colors.white),
              margin: EdgeInsets.zero,
              padding: EdgeInsets.symmetric(
                vertical: 6,
              ),
              /*  avatar: Icon(
                Icons.thumb_up_off_alt_outlined,
                color: post.likeStatus! ? Colors.blueAccent : Colors.black54,
              ), */
              title:
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Icon(
                  post.likeStatus!
                      ? Icons.thumb_up
                      : Icons.thumb_up_off_alt_outlined,
                  color: post.likeStatus! ? Colors.blueAccent : Colors.black54,
                ),
                SizedBox(
                  width: 8,
                ),
                post.numOfLikes == null
                    ? Text(
                        "0",
                        style: TextStyle(color: Colors.black54, fontSize: 18),
                      )
                    : Text(
                        "${post.numOfLikes}",
                        style: TextStyle(color: Colors.black54, fontSize: 18),
                      ),
              ])),
        ),
      ),
    );
  }

  void mShowRatingDialog(Post post) {
    showDialog(
        context: context,
        builder: (context) {
          return RatingDialog(
            ratingValue: post.ratingValue ?? 0,
            callback: (int ratingValue) {
              logger.w("Rating value input: ${ratingValue.runtimeType}");
              if (ratingValue > 0) {
                // calculate rate and store
                mStoreandUpdateRating(post, ratingValue);
              }
            },
          );
        });
  }

  void mStoreandUpdateRating(Post post, int ratingValue) async {
    await MyFirestoreService.mStoreRatingData(
            firebaseFirestore: firebaseFirestore,
            email: widget.userData.email!,
            postId: post.postId!,
            ratingValue: ratingValue)
        .then((rated) {
      if (rated) {
        // c: like
        logger.w("rated");
        posts![posts!.indexOf(post)].ratingStatus = true;
      }
      // c: refresh
      setState(() {});
    });
  }

  vRatingButton1(Post post) {
    return Expanded(
      child: InkWell(
        onTap: () {
          mShowRatingDialog(post);
        },
        child: GFCard(
          margin: EdgeInsets.zero,

          color: Colors.white,
          elevation: 0,
          // padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
          padding: EdgeInsets.zero,
          title: GFListTile(
              color: Color.fromARGB(22, 0, 0, 0),
              radius: 50,
              shadow: BoxShadow(color: Colors.white),
              margin: EdgeInsets.zero,
              padding: EdgeInsets.symmetric(
                vertical: 6,
              ),
              /*  avatar: Icon(
                Icons.thumb_up_off_alt_outlined,
                color: post.likeStatus! ? Colors.blueAccent : Colors.black54,
              ), */
              title:
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Icon(
                  post.ratingStatus!
                      ? Icons.star_border_outlined
                      : Icons.star_border_outlined,
                  color: post.ratingStatus!
                      ? MyColors.darkYellowColor
                      : Colors.black54,
                ),
                SizedBox(
                  width: 8,
                ),
                post.ratings == null
                    ? Text(
                        "0",
                        style: TextStyle(color: Colors.black54, fontSize: 18),
                      )
                    : Text(
                        "${post.ratings}",
                        style: TextStyle(color: Colors.black54, fontSize: 18),
                      ),
              ])),
        ),
      ),
    );
  }

  vCommentButton1(Post post) {
    return Expanded(
      child: InkWell(
        onTap: () {
          logger.w("Cliked Com");
          mOnClickCommentButton(post);
        },
        child: GFCard(
          margin: EdgeInsets.zero,

          color: Colors.white,
          elevation: 0,
          // padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
          padding: EdgeInsets.zero,
          title: GFListTile(
              color: Color.fromARGB(22, 0, 0, 0),
              radius: 50,
              shadow: BoxShadow(color: Colors.white),
              margin: EdgeInsets.zero,
              padding: EdgeInsets.symmetric(
                vertical: 6,
              ),
              /*  avatar: Icon(
                Icons.thumb_up_off_alt_outlined,
                color: post.likeStatus! ? Colors.blueAccent : Colors.black54,
              ), */
              title:
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Icon(
                  Icons.comment_outlined,
                  color: post.likeStatus!
                      ? MyColors.pureYellowColor
                      : Colors.black54,
                ),
                SizedBox(
                  width: 8,
                ),
                post.numOfComments == null
                    ? Text(
                        "0",
                        style: TextStyle(color: Colors.black54, fontSize: 18),
                      )
                    : Text(
                        "${post.numOfComments}",
                        style: TextStyle(color: Colors.black54, fontSize: 18),
                      )
              ])),
        ),
      ),
    );
  }

  vLoadMoreButton() {
    return InkWell(
        splashColor: Colors.white,
        onTap: () {
          /* setState(() {
            _isMoreDataLoading = true;
          }); */
          /* ToastCard(
            Text("Loading..."),
            Duration(milliseconds: 100),
          ); */
          // Toast.show("Toast plugin app", duration: Toast.lengthShort, gravity:  Toast.bottom);
          Fluttertoast.showToast(
              msg: "Loading...",
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.black87,
              textColor: Colors.white,
              fontSize: 14.0);

          mLoadMore();
        },
        child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: MyWidget.vLoadMoreButton()
            // child: MoreLoaderWidget(isMoreLoading: _isMoreDataLoading),
            ));
  }

  void mCheckMoreDataAvailability() async {
    await MyFirestoreService.mFetchMorePosts(
            userData: widget.userData,
            firebaseFirestore: firebaseFirestore,
            category: _dropDownValue,
            lastVisibleDocumentId: posts!.last.postId!)
        .then((value) {
      logger.w(value.length);
      if (value.isEmpty) {
        logger.w("No Data exist");
        /*  ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("No Data exist"))); */
        setState(() {
          _isNoDataExist = true;
        });
      }
    });
  }
}
