// ignore_for_file: prefer_const_constructors

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/utils/custom_text.dart';
import 'package:flutter_application_1/utils/my_colors.dart';
import 'package:getwidget/getwidget.dart';

import '../utils/my_screensize.dart';

class MyWidget {
  
  static Future<dynamic> vShowWarnigDialog(
      {required BuildContext context,
      required String message,
      String? buttonText,
      String? desc}) {
    return AwesomeDialog(
        context: context,
        // dialogType: DialogType.warning,
        dialogType: DialogType.noHeader,
        title: message,
        desc: desc ?? "",
        btnOk: ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          style: ElevatedButton.styleFrom(
              fixedSize: Size(400, MyScreenSize.mGetHeight(context, 1)),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4)),
          child: Text(buttonText ?? "Dismiss"),
        )).show();
  }

  static Widget vButtonProgressLoader(
      {double? width,
      double? height,
      Color? color,
      String? labelText,
      bool? isVertical}) {
    return isVertical != null
        ? isVertical
            ? Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                            width: width ?? 24,
                            height: height ?? 24,
                            child: CircularProgressIndicator(
                              color: color ?? Colors.white,
                              strokeWidth: 2,
                            )), // Customize the CircularProgressIndicator as needed
                        const SizedBox(
                            height:
                                8), // Add some spacing between the CircularProgressIndicator and text
                        Text(
                          labelText ?? 'Loading',
                          style: TextStyle(color: color ?? Colors.white),
                        ), // Replace with your desired text
                      ],
                    )
                  ])
            : Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                      width: width ?? 24,
                      height: height ?? 24,
                      child: CircularProgressIndicator(
                        color: color ?? Colors.white,
                        strokeWidth: 2,
                      )), // Customize the CircularProgressIndicator as needed
                  const SizedBox(
                      width:
                          8), // Add some spacing between the CircularProgressIndicator and text
                  Text(
                    labelText ?? 'Loading',
                    style: TextStyle(color: color ?? Colors.white),
                  ), // Replace with your desired text
                ],
              )
        : Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                  width: width ?? 24,
                  height: height ?? 24,
                  child: CircularProgressIndicator(
                    color: color ?? Colors.white,
                    strokeWidth: 2,
                  )), // Customize the CircularProgressIndicator as needed
              const SizedBox(
                  width:
                      8), // Add some spacing between the CircularProgressIndicator and text
              Text(
                labelText ?? 'Loading',
                style: TextStyle(color: color ?? Colors.white),
              ), // Replace with your desired text
            ],
          );
  }

  static Widget vPostShimmering({required BuildContext context}) {
    return GFShimmer(
        child: Container(
      margin: EdgeInsets.all(12),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                  height: MyScreenSize.mGetHeight(context, 8),
                  width: MyScreenSize.mGetWidth(context, 12),
                  decoration: BoxDecoration(
                      shape: BoxShape.circle, color: Colors.black26)),
              SizedBox(
                width: 24,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                      height: MyScreenSize.mGetHeight(context, 3),
                      width: MyScreenSize.mGetWidth(context, 60),
                      decoration: BoxDecoration(
                          shape: BoxShape.rectangle, color: Colors.black26)),
                  SizedBox(
                    height: 8,
                  ),
                  Container(
                    height: MyScreenSize.mGetHeight(context, 2),
                    width: MyScreenSize.mGetWidth(context, 35),
                    decoration: BoxDecoration(
                        shape: BoxShape.rectangle, color: Colors.black26),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(
            height: 24,
          ),
          Container(
              height: MyScreenSize.mGetHeight(context, 48),
              width: MyScreenSize.mGetWidth(context, 80),
              decoration: BoxDecoration(
                  shape: BoxShape.rectangle, color: Colors.black26)),
        ],
      ),
    ));
  }

  // static Widget vLoadMoreButton(bool isMoreDataLoading) {
  static Widget vLoadMoreButton() {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      decoration: BoxDecoration(
          color: Colors.blue, borderRadius: BorderRadius.circular(16)),
      child:/*  isMoreDataLoading
          ? Container(

              child: CircularProgressIndicator(backgroundColor: Colors.white),
            )
          : */ CustomText(
              text: "More",
              fontcolor: Colors.white,
            ),
    );
  }

  static Widget vPostPaginationShimmering({required BuildContext context}) {
    return GFShimmer(
        child: Container(
      margin: EdgeInsets.all(12),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                  height: MyScreenSize.mGetHeight(context, 8),
                  width: MyScreenSize.mGetWidth(context, 12),
                  decoration: BoxDecoration(
                      shape: BoxShape.circle, color: Colors.black26)),
              SizedBox(
                width: 24,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                      height: MyScreenSize.mGetHeight(context, 3),
                      width: MyScreenSize.mGetWidth(context, 60),
                      decoration: BoxDecoration(
                          shape: BoxShape.rectangle, color: Colors.black26)),
                  SizedBox(
                    height: 8,
                  ),
                  Container(
                    height: MyScreenSize.mGetHeight(context, 2),
                    width: MyScreenSize.mGetWidth(context, 35),
                    decoration: BoxDecoration(
                        shape: BoxShape.rectangle, color: Colors.black26),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(
            height: 24,
          ),
          Container(
              height: MyScreenSize.mGetHeight(context, 10),
              width: MyScreenSize.mGetWidth(context, 80),
              decoration: BoxDecoration(
                  shape: BoxShape.rectangle, color: Colors.black26)),
        ],
      ),
    ));
  }

  static vCommentShimmering({required BuildContext context}) {
    return GFShimmer(
        child: Container(
      margin: EdgeInsets.all(12),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                  height: MyScreenSize.mGetHeight(context, 8),
                  width: MyScreenSize.mGetWidth(context, 12),
                  decoration: BoxDecoration(
                      shape: BoxShape.circle, color: Colors.black26)),
              SizedBox(
                width: 24,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                      height: MyScreenSize.mGetHeight(context, 3),
                      width: MyScreenSize.mGetWidth(context, 60),
                      decoration: BoxDecoration(
                          shape: BoxShape.rectangle, color: Colors.black26)),
                  SizedBox(
                    height: 8,
                  ),
                  Container(
                    height: MyScreenSize.mGetHeight(context, 2),
                    width: MyScreenSize.mGetWidth(context, 35),
                    decoration: BoxDecoration(
                        shape: BoxShape.rectangle, color: Colors.black26),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(
            height: 24,
          ),
          Container(
              height: MyScreenSize.mGetHeight(context, 10),
              width: MyScreenSize.mGetWidth(context, 80),
              decoration: BoxDecoration(
                  shape: BoxShape.rectangle, color: Colors.black26)),
          SizedBox(
            height: 36,
          ),
          Row(
            children: [
              Container(
                  height: MyScreenSize.mGetHeight(context, 8),
                  width: MyScreenSize.mGetWidth(context, 12),
                  decoration: BoxDecoration(
                      shape: BoxShape.circle, color: Colors.black26)),
              SizedBox(
                width: 24,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                      height: MyScreenSize.mGetHeight(context, 3),
                      width: MyScreenSize.mGetWidth(context, 60),
                      decoration: BoxDecoration(
                          shape: BoxShape.rectangle, color: Colors.black26)),
                  SizedBox(
                    height: 8,
                  ),
                  Container(
                    height: MyScreenSize.mGetHeight(context, 2),
                    width: MyScreenSize.mGetWidth(context, 35),
                    decoration: BoxDecoration(
                        shape: BoxShape.rectangle, color: Colors.black26),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(
            height: 24,
          ),
          Container(
              height: MyScreenSize.mGetHeight(context, 10),
              width: MyScreenSize.mGetWidth(context, 80),
              decoration: BoxDecoration(
                  shape: BoxShape.rectangle, color: Colors.black26)),
          SizedBox(
            height: 36,
          ),
          Row(
            children: [
              Container(
                  height: MyScreenSize.mGetHeight(context, 8),
                  width: MyScreenSize.mGetWidth(context, 12),
                  decoration: BoxDecoration(
                      shape: BoxShape.circle, color: Colors.black26)),
              SizedBox(
                width: 24,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                      height: MyScreenSize.mGetHeight(context, 3),
                      width: MyScreenSize.mGetWidth(context, 60),
                      decoration: BoxDecoration(
                          shape: BoxShape.rectangle, color: Colors.black26)),
                  SizedBox(
                    height: 8,
                  ),
                  Container(
                    height: MyScreenSize.mGetHeight(context, 2),
                    width: MyScreenSize.mGetWidth(context, 35),
                    decoration: BoxDecoration(
                        shape: BoxShape.rectangle, color: Colors.black26),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(
            height: 24,
          ),
          Container(
              height: MyScreenSize.mGetHeight(context, 10),
              width: MyScreenSize.mGetWidth(context, 80),
              decoration: BoxDecoration(
                  shape: BoxShape.rectangle, color: Colors.black26)),
        ],
      ),
    ));
  }

  static vCommentPaginationShimmering({required BuildContext context}) {
    return GFShimmer(
        child: Container(
      margin: EdgeInsets.all(12),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                  height: MyScreenSize.mGetHeight(context, 8),
                  width: MyScreenSize.mGetWidth(context, 12),
                  decoration: BoxDecoration(
                      shape: BoxShape.circle, color: Colors.black26)),
              SizedBox(
                width: 24,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                      height: MyScreenSize.mGetHeight(context, 3),
                      width: MyScreenSize.mGetWidth(context, 60),
                      decoration: BoxDecoration(
                          shape: BoxShape.rectangle, color: Colors.black26)),
                  SizedBox(
                    height: 8,
                  ),
                  Container(
                    height: MyScreenSize.mGetHeight(context, 2),
                    width: MyScreenSize.mGetWidth(context, 35),
                    decoration: BoxDecoration(
                        shape: BoxShape.rectangle, color: Colors.black26),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(
            height: 24,
          ),
          Container(
              height: MyScreenSize.mGetHeight(context, 6),
              width: MyScreenSize.mGetWidth(context, 80),
              decoration: BoxDecoration(
                  shape: BoxShape.rectangle, color: Colors.black26)),
        ],
      ),
    ));
  }
}
