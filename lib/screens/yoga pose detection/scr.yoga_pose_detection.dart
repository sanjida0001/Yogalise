// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_final_fields

import 'dart:io';
import 'dart:typed_data';

import 'package:bottom_sheet/bottom_sheet.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/model.post.dart';
import 'package:flutter_application_1/models/model.user.dart';
import 'package:flutter_application_1/screens/home/scr.home.dart';
import 'package:flutter_application_1/widgets/my_widget.dart';
import 'package:logger/logger.dart';
import 'package:tflite/tflite.dart';

// import 'package:tflite/tflite.dart';

import '../../const/keywords.dart';
import '../../controller/firestore_service.dart';
import '../../controller/my_services.dart';
import '../../models/model.image_details.dart';
import '../../utils/custom_text.dart';
import '../../utils/my_colors.dart';
import '../../utils/my_date_format.dart';
import '../../utils/my_screensize.dart';

class YogaPoseDetectionScreen extends StatefulWidget {
  // final Function callback;
  final UserData userData;
  final FirebaseFirestore firebaseFirestore;

  const YogaPoseDetectionScreen({
    Key? key,
    required this.userData,
    required this.firebaseFirestore,
    // required this.callback,
  }) : super(key: key);

  @override
  State<YogaPoseDetectionScreen> createState() =>
      _YogaPoseDetectionScreenState();
}

class _YogaPoseDetectionScreenState extends State<YogaPoseDetectionScreen> {
  List<ImageDetailsModel> _imgDetailModelList = [];
  late File _imgFile;
  late Map<String, dynamic> map = {};
  TextEditingController _textEditingControllerCaption =
      TextEditingController(text: '');
  bool _isVisible = false;
  bool _isUploadBtnLoading = false;
  bool _isGoogleBtnLoading = false;
  bool _isCaptionFieldVisible = false;
  bool _isReadyForUpload = false;
  bool _isScanning = false;
  bool _isModelLoading = true;
  // bool _isModelLoading = false;
  bool _isImgUploading = false;

  final Logger logger = Logger();
  List? _recognitions;

  FirebaseStorage firebaseStorage = FirebaseStorage.instance;
  late Reference storageRef;

  // bool _isShowNewBabyContents = false;

  @override
  void initState() {
    super.initState();
    /*    MyServices.determinePosition().then((value) {
      map = value;
    }); */
    // print('IsSignedIn: ${widget.isSignedIn}');
    mLoadModel();
  }

  @override
  void dispose() {
    super.dispose();
    _textEditingControllerCaption.dispose();
  }

  @override
  Widget build(BuildContext context) {
    /* _imgDetailModelList.isNotEmpty
        ? print(
            'imageDetailsModelList 0th item: ${_imgDetailModelList[0].imgUri}')
        : null; */
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: MyColors.bluishBlackColor),
        elevation: 0,
        title: Text(
          "Detect Yoga Pose",
          style: TextStyle(color: MyColors.bluishBlackColor),
        ),
      ),
      body: Container(
        height: MyScreenSize.mGetHeight(context, 100),
        width: MyScreenSize.mGetWidth(context, 100),
        alignment: Alignment.center,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              /*  Container(
                color: MyColors.pureGreenColor,
                height: MyScreenSize.mGetHeight(context, 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomText(
                      text: 'Upload picture',
                      fontWeight: FontWeight.w400,
                      fontcolor: Colors.white,
                      fontsize: 20,
                    ),
                  ],
                ),
              ), */
              _isModelLoading
                  ? vModelLoading()
                  : Container(
                      padding: EdgeInsets.all(8),
                      child: Column(
                        children: [
                          vCaptionInputField(),
                          SizedBox(
                            height: 16,
                          ),
                          vSelectedImgPreview(),
                          SizedBox(
                            height: 12,
                          ),
                          vImagePickingAndShowResult(),
                          SizedBox(
                            height: 16,
                          ),
                          vDecisionButtons(),
                        ],
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }

  void mShowSaveOption() {
    showFlexibleBottomSheet(
        bottomSheetColor: Colors.white,
        minHeight: 0,
        initHeight: 0.25,
        maxHeight: 1,
        anchors: [0, 0.5, 1],
        isSafeArea: true,
        context: context,
        builder: (BuildContext context, ScrollController scrollController,
                double bottomSheetOffset) =>
            Container(
              margin: EdgeInsets.only(top: 25, left: 8, bottom: 6),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      CustomText(
                        text: 'Save to',
                        fontsize: 12,
                      )
                    ],
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  InkWell(
                    splashColor: MyColors.pureGreenColor,
                    onTap: () {},
                    child: Row(
                      children: [
                        Container(
                          margin: EdgeInsets.symmetric(
                              // vertical: 6,
                              horizontal: 14),
                          child: Icon(
                            Icons.phone_android_rounded,
                            color: MyColors.pureGreenColor,
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.all(2),
                          child: CustomText(text: 'Local album'),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  InkWell(
                    splashColor: MyColors.pureGreenColor,
                    onTap: () {
                      Navigator.pop(context);
                      MyColors.pureGreenColor;
                    },
                    child: Row(
                      children: [
                        Container(
                          margin: EdgeInsets.symmetric(
                              // vertical: 6,
                              horizontal: 14),
                          child: Icon(
                            Icons.cloud_circle_rounded,
                            color: MyColors.pureGreenColor,
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.all(2),
                          child: CustomText(text: 'Cloud album'),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ));
  }

  void mSaveToCloud() {
    /*
        //save to cloud
    if (_isSignedIn) {
    _imgDetailModelList.isNotEmpty
        ? {
            setState(() {
              _isUploadBtnLoading =
                  !_isUploadBtnLoading;
            }),
            FirebaseStorageProvider
                    .mAddImageToFirebaseStorage(
                        email: _userEmail!,
                        imgFile:
                            _imgDetailModelList
                                .first
                                .imgFile!,
                        imgName:
                            _imgDetailModelList
                                .first.imgUri!
                                .substring(
                                    6, 15))
                .then((value) {
              if (value != null) {
                print(_userEmail);
                FirestoreProvider.mAddBabyGalleryDataToFirestore(
                    email: _userEmail!,
                    caption:
                        _textEditingControllerCaption
                            .text,
                    imgUrl:
                        "$_userEmail/${Path.basename(_imgDetailModelList.first.imgFile!.path)}",
                    latitude: _imgDetailModelList
                        .first.latitude,
                    longitude:
                        _imgDetailModelList
                            .first.longitude,
                    timestamp:
                        _imgDetailModelList
                            .first.date,
                    date: _imgDetailModelList
                        .first.date,
                    imgFromCamera:
                        _imgDetailModelList
                            .first
                            .imgFromCamera!);
                widget.callback(_userEmail);
                Navigator.pop(context);

                /*    _imgDetailModelList[0]
                        .caption =
                    _textEditingControllerCaption
                        .value.text; */
              }
            })
          }
        : null;
  } else {
    setState(() {
      _isVisible = !_isVisible;
      /*   _isGoogleBtnLoading =
          !_isGoogleBtnLoading; */
    });
  }
*/
  }

  /* mCallBack() {
    widget.callback();
    Navigator.pop(context);
  } */

  mLoadModel() async {
    await Tflite.loadModel(
      model: 'assets/model.tflite',
      labels: 'assets/labels.txt',
    );
    logger.d("Model loaded");
    setState(() {
      _isModelLoading = false;
    });
  }

  mPredictImage() async {
    File image = File(_imgDetailModelList[0].getImgUrl);

    List<int> bytes = await image.readAsBytes();
    Uint8List uint8list = Uint8List.fromList(bytes);
    // var recognitions = await Tflite.runModelOnBinary(binary: uint8list);

    var recognitions = await Tflite.runModelOnImage(
      path: image.path,
      numResults: 5,
      threshold: 0.05,
    );
    setState(() {
      _recognitions = recognitions!;
      _isScanning = false;

      for (var i = 0; i < _recognitions!.length; i++) {
        logger.d(
            "Label: ${_recognitions![i]['label']} \n Confidence: ${_recognitions![i]['confidence']}");
      }
    });
  }

  vPostUploadButton() {
    return ElevatedButton(
        style:
            ElevatedButton.styleFrom(backgroundColor: MyColors.pureGreenColor),
        onPressed: () async {
          if (_isReadyForUpload) {
            setState(() {
              _isImgUploading = true;
            });

            String? value = await MyFirestoreService.mUploadImageToStorage(
                firebaseStorage: firebaseStorage,
                imgUri: _imgDetailModelList[0].getImgUrl);

            if (value != null) {
              logger.w(value);

              /* widget.callback(
                  value,
                  _recognitions![0]['label'],
                  /* confidence: 
                                                    _recognitions![0]['confidence'],  */
                  _textEditingControllerCaption.value.text); */

              Post post = Post(
                  email: widget.userData.email,
                  caption: _textEditingControllerCaption.value.text,
                  imgUri: value,
                  category: _recognitions![0]['label'],
                  ts: DateTime.now().millisecondsSinceEpoch.toString());

              await MyFirestoreService.mUploadPost(
                      firebaseFirestore: widget.firebaseFirestore, post: post)
                  .then((value) async {
                if (value) {
                  await Future.delayed(const Duration(milliseconds: 3000))
                      .then((value) {
                    // c: dismiss bottomSheet
                    Navigator.pop(context);
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) {
                      return HomeScreen(userData: widget.userData);
                    }));
                  });

                  /*  setState(() {
                  _isDataLoading = true;
                }); */
                  /*  await MyFirestoreService.mFetchInitialPost(
                        firebaseFirestore: firebaseFirestore,
                        category: "all category")
                    .then((value) {
                  posts!.clear;
                  setState(() {
                    posts = value;
                    _isDataLoading = false;
                  });
                }); */
                } else {
                  logger.w("Null");
                }
                /*  setState(() {
              _isImgUploading = false;
              Navigator.pop(context);
            }); */
              });
            }
          }
          setState(() {
            _isCaptionFieldVisible = true;
            _isReadyForUpload = true;
          });
        },
        child: _isImgUploading
            ? MyWidget.vButtonProgressLoader(labelText: "Uploading..")
            : Icon(
                Icons.arrow_forward_ios,
                color: Colors.white,
              ));
  }

  vModelLoading() {
    return Column(
      children: [
        SizedBox(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(
            color: MyColors.pureGreenColor,
            strokeWidth: 1,
          ),
        ),
        SizedBox(
          height: 6,
        ),
        Text(
          "Model Loading...",
          style: TextStyle(color: MyColors.bluishBlackColor, fontSize: 12),
        )
      ],
    );
  }

  vSelectedImgPreview() {
    return Container(
      height: _imgDetailModelList.isNotEmpty && !_isCaptionFieldVisible
          ? MyScreenSize.mGetHeight(context, 50)
          : 0,
      alignment: Alignment.center,
      child: _imgDetailModelList.isNotEmpty
          ? ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemCount: 1 /* _imgDetailModelList.length */,
              // itemCount: _imgStrList.isEmpty ? 0 : _imgStrList.length,
              itemBuilder: ((context, index) {
                return Padding(
                        padding: EdgeInsets.symmetric(horizontal: 4),
                        child: /* Utility.imageFromBase64String(
                                    _imgDetailModelList[index].imgUrl) ,*/
                            Image.file(
                          File(_imgDetailModelList[index].getImgUrl),
                          width: MyScreenSize.mGetWidth(context, 50),
                          // height: MyScreenSize.mGetHeight(context, 60),
                          fit: BoxFit.cover,
                        ))
                    // CustomText(text: 'Text $index')
                    ;
              }))
          : null,
    );
  }

  vCaptionInputField() {
    return Visibility(
      visible: _isCaptionFieldVisible,
      child: TextField(
        controller: _textEditingControllerCaption,
        maxLines: 2,
        maxLength: 200,
        decoration: InputDecoration(
            label: CustomText(
              text: 'Caption',
            ),
            border: OutlineInputBorder()),
      ),
    );
  }

  vPickImageFromLocal() {
    return Expanded(
      child: InkWell(
        onTap: () {
          _imgDetailModelList.clear();
          //* for single image pick
          /*     MyServices.mPickImgFromLocal()
                                          .then((value) {
                                        if (value != null) {
                                          setState(() { });    
                          
                                        }
                                      }); */
          // m: pick image from local storage
          MyServices.mPickMultipleImageFromLocal().then((value) {
            if (value != null) {
              // c: assign image Details Model list
              _imgDetailModelList = value;
              // c: Referesh screen for show image preview in the horizontal List view
              setState(() {});
            }
          });
        },
        child: TextField(
          decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              enabled: false,
              isDense: true,

              // contentPadding: EdgeInsets.all(2),
              prefixIcon: Icon(
                Icons.file_upload,
                size: 24,
                color: MyColors.pureGreenColor,
              ),
              label: CustomText(
                text: 'Device',
                fontWeight: FontWeight.w400,
                fontcolor: Colors.black45,
              )),
        ),
      ),
    );
  }

  vPickImageFromCamera() {
    return Expanded(
      child: InkWell(
        onTap: () {
          _imgDetailModelList.clear();

          MyServices.mPickImgCamera().then((value) {
            if (value != null) {
              // _imageString = value!;
              // _imgDetailModelList.add(value!);

              _imgDetailModelList.add(ImageDetailsModel.imageFromCamera(
                  imgUrl: value[MyKeywords.singleImgUrls],
                  latitude: map['lat'],
                  longitude: map['long'],
                  timestamp: DateTime.now().millisecondsSinceEpoch.toString(),
                  /* caption:
                                              _textEditingControllerCaption.text, */
                  date: MyDateForamt.mFormateDateDB(DateTime.now())));
              // c: Referesh screen for show image preview in the horizontal List view
              setState(() {});
            }
          });
        },
        child: TextFormField(
          decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              enabled: false,
              isDense: true,

              // contentPadding: EdgeInsets.all(2),
              prefixIcon: Icon(
                Icons.camera,
                size: 24,
                color: MyColors.pureGreenColor,
              ),
              label: CustomText(
                text: 'Camera',
                fontWeight: FontWeight.w400,
                fontcolor: Colors.black45,
              )),
        ),
      ),
    );
  }

  vScanResult() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Category",
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            SizedBox(
              width: 4,
            ),
            Text(
              ":",
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            SizedBox(
              width: 4,
            ),
            Text(
              _recognitions![0]['label'],
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
          ],
        ),
        SizedBox(
          height: 6,
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Confidence",
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            SizedBox(
              width: 4,
            ),
            Text(
              ":",
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            SizedBox(
              width: 4,
            ),
            Text(
              "${double.parse(_recognitions![0]['confidence'].toString()).toStringAsFixed(2)}%",
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
          ],
        )
      ],
    );
  }

  vImagePickingAndShowResult() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Visibility(
        visible: _isScanning == false,
        child: _recognitions == null
            ? Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  vPickImageFromLocal(),
                  SizedBox(
                    width: 32,
                  ),
                  vPickImageFromCamera(),
                ],
              )
            : vScanResult(),
      ),
    );
  }

  vDecisionButtons() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: _isScanning
          ? MyWidget.vButtonProgressLoader(
              color: MyColors.pureYellowColor,
              width: 24,
              height: 24,
              labelText: "Detecting, please wait...",
              isVertical: true)
          : Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // v: discard button
                /*  Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: MyColors.pureGreenColor),
                    onPressed: () {
                      Navigator.pop(context);
                      // mCallBack();
                    },
                    child: CustomText(
                      text: 'Discard',
                      fontcolor: Colors.white,
                    ),
                  ),
                ),
                SizedBox(
                  width: 32,
                ), */
                // v: scan button
                Expanded(
                  child: _isUploadBtnLoading
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircularProgressIndicator(
                              strokeWidth: 2.0,
                            )
                          ],
                        )
                      : _recognitions == null
                          ? ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(24)),
                                  backgroundColor: MyColors.pureGreenColor),
                              onPressed: () {
                                _imgDetailModelList.isNotEmpty
                                    ? {
                                        setState(() {
                                          _isScanning = true;
                                        }),
                                        Future.delayed(
                                                Duration(milliseconds: 3000))
                                            .then((value) => mPredictImage()),
                                      }
                                    : ScaffoldMessenger.of(context)
                                        .showSnackBar(SnackBar(
                                            content: CustomText(
                                        text: 'Pick a photo',
                                      )));

                                // c: [Deprecated] Save to Cloud
                                // mSaveToCloud();
                              },
                              child: Icon(
                                Icons.arrow_forward_ios,
                                color: Colors.white,
                                size: 24,
                              ) /* CustomText(
                                text: 'Scan',
                                fontcolor: Colors.white,
                              ) */
                              )
                          : vPostUploadButton(),
                )
              ],
            ),
    );
  }
}

/* 

  caption
""
(string)
category
"1 engraving"
email
"user.afb1@gmail.com"
img_uri
"https://firebasestorage.googleapis.com/v0/b/art-blog-app-flutter-a8029.appspot.com/o/image%2Fdata%2Fuser%2F0%2Fcom.example.flutter_application_1%2Fapp_flutter%2F403.jpg?alt=media&token=a158bed5-6c91-4797-80fe-11ce4b77a6c3"
num_of_comments
null
num_of_dislikes
null
num_of_likes
null
post_id
"1"
ts
"1684746689186"

 */
