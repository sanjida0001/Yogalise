// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/model.user.dart';
import 'package:flutter_application_1/screens/profile/pages/edit_profile.dart';
import 'package:flutter_application_1/utils/my_screensize.dart';
import 'package:getwidget/components/card/gf_card.dart';

import '../../utils/my_colors.dart';

class ProfilePage extends StatefulWidget {
  final UserData userData;
  const ProfilePage({super.key, required this.userData});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "My Profile",
          style: TextStyle(color: MyColors.bluishBlackColor),
        ),
        iconTheme: const IconThemeData(color: MyColors.bluishBlackColor),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      backgroundColor: Colors.white,

      /* appBar: AppBar(
        elevation: 0.0,
        backgroundColor: const Color(0xff555555),
        
      ), */
      body: Container(
        // padding: const EdgeInsets.all(8),
        height: MyScreenSize.mGetHeight(context, 100),
        width: MyScreenSize.mGetWidth(context, 100),
        child: SingleChildScrollView(
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              vUpperPart(),
              // vUserPhone(),
              SizedBox(
                height: 20,
              ),
              vLowerPart(),
            ],
          ),
        ),
      ),
    );
  }

  vProfileImage(double height, double width) {
    return Container(
      width: height,
      height: width,
      decoration: BoxDecoration(
        border: Border.all(color: MyColors.fourthColor, width: 5),
        shape: BoxShape.circle,
        color: MyColors.fourthColor,
        image: const DecorationImage(
            fit: BoxFit.contain,
            // image: AssetImage('images/profile.png'),
            image: AssetImage("assets/images/user.png")),
      ),
    );
  }

  vUserName() {
    return Text(
      widget.userData.username!,
      style: TextStyle(
          color: MyColors.bluishBlackColor,
          fontSize: 24,
          fontWeight: FontWeight.bold),
    );
  }

  vUserEmail() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.email_outlined,
          color: Colors.black26,
        ),
        SizedBox(
          width: 8,
        ),
        Container(
          alignment: Alignment.centerLeft,
          child: Text(
            widget.userData.email!,
            style: TextStyle(color: MyColors.bluishBlackColor),
          ),
        )
      ],
    );
  }

  vUserPhone() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: Container(
            alignment: Alignment.centerRight,
            child: Icon(
              Icons.phone_outlined,
              color: Colors.black26,
            ),
          ),
        ),
        SizedBox(
          width: 8,
        ),
        Expanded(
          flex: 2,
          child: Container(
            alignment: Alignment.centerLeft,
            child: Text(
              "+88${widget.userData.phone!}",
              style: TextStyle(color: MyColors.bluishBlackColor),
            ),
          ),
        )
      ],
    );
  }

  vAbout() {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "About",
                style: TextStyle(
                    color: MyColors.bluishBlackColor,
                    fontSize: 18,
                    fontWeight: FontWeight.w500),
              ),
              SizedBox(
                height: 4,
              ),
              GFCard(
                elevation: 0,
                // padding: EdgeInsets.symmetric(vertical: 2, horizontal: 2),
                // margin: EdgeInsets.symmetric(vertical: 4, horizontal: 6),
                padding: EdgeInsets.zero,
                margin: EdgeInsets.zero,
                content: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(width: .5, color: Colors.black38),
                    // color: Color.fromARGB(8, 0, 0, 0),
                    color: Colors.white,
                  ),
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.symmetric(vertical: 8, horizontal: 14),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        /* Text(
                        commenter.user!.username!,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 8,
                      ), */
                        // Text(commenter.text!),
                        Text(
                            "A funny person is someone who has the ability to make others laugh or smile with their witty humor, creative jokes, amusing stories or comical actions. They have a natural talent for seeing the humor in everyday situations and can easily lighten up the mood")
                      ]),
                ),
              )
            ],
          ),
        )
      ],
    );
  }

  vUserOtherDetails() {
    return Row(
      children: [
        Expanded(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Others",
              style: TextStyle(
                  color: MyColors.bluishBlackColor,
                  fontSize: 18,
                  fontWeight: FontWeight.w500),
            ),
            SizedBox(
              height: 4,
            ),
            Divider(
              height: 1,
              color: Colors.black12,
            ),
            SizedBox(
              height: 12,
            ),
            vUserDob(),
            SizedBox(
              height: 4,
            ),
            vUserAddress(),
            SizedBox(
              height: 4,
            ),
            vUserContact(),
            SizedBox(
              height: 4,
            ),
          ],
        ))
      ],
    );
  }

    vUserDob() {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Container(
              alignment: Alignment.centerLeft,
              child: Icon(
                Icons.calendar_month,
                color: Colors.black26,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Container(
                alignment: Alignment.centerLeft, child: Text("Date of birth")),
          ),
          Expanded(
              child:
                  Container(alignment: Alignment.centerLeft, child: Text(":"))),
          Expanded(
            flex: 6,
            child: Container(
              alignment: Alignment.centerLeft,
              child: Text(
                widget.userData.dob!,
                style: TextStyle(color: MyColors.bluishBlackColor),
              ),
            ),
          )
        ],
      );
    }

    vUserAddress() {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Container(
              alignment: Alignment.centerLeft,
              child: Icon(
                Icons.location_pin,
                color: Colors.black26,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Container(
                alignment: Alignment.centerLeft, child: Text("Location")),
          ),
          Expanded(
              child:
                  Container(alignment: Alignment.centerLeft, child: Text(":"))),
          Expanded(
            flex: 6,
            child: Container(
              alignment: Alignment.centerLeft,
              child: Text(
                "Jobra, University of Chittagong, Hathazari Road",
                style: TextStyle(color: MyColors.bluishBlackColor),
              ),
            ),
          )
        ],
      );
    }

    vUserContact() {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Container(
              alignment: Alignment.centerLeft,
              child: Icon(
                Icons.phone,
                color: Colors.black26,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Container(
                alignment: Alignment.centerLeft, child: Text("Contact No")),
          ),
          Expanded(
              child:
                  Container(alignment: Alignment.centerLeft, child: Text(":"))),
          Expanded(
            flex: 6,
            child: Container(
              alignment: Alignment.centerLeft,
              child: Text(
                "+88${widget.userData.phone!}",
                style: TextStyle(color: MyColors.bluishBlackColor),
              ),
            ),
          )
        ],
      );
    }

  vUpperPart() {
    return Container(
      padding: EdgeInsets.only(left: 8, top: 8, right: 8, bottom: 16),
      decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
                color: Colors.black26, offset: Offset(1, 1), blurRadius: 1)
          ],
          color: Colors.white,
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(32),
              bottomRight: Radius.circular(32))),
      child: Column(
        children: [
          vProfileImage(
            MyScreenSize.mGetWidth(context, 32),
            MyScreenSize.mGetHeight(context, 24),
          ),
          vUserName(),
          vUserEmail(),
        ],
      ),
    );
  }

  vLowerPart() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
      child: Column(children: [
        vAbout(),
        SizedBox(
          height: 18,
        ),
        vUserOtherDetails(),
        SizedBox(
          height: 18,
        ),
        vEditButton(),
      ]),
    );
  }

  vEditButton() {
    return ElevatedButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return EditProfilePage(userData: widget.userData);
          }));
        },
        style: ElevatedButton.styleFrom(
          alignment: Alignment.center,
          backgroundColor: MyColors.pureYellowColor,
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 4),
          fixedSize: Size(MyScreenSize.mGetWidth(context, 60), 0),
        ),
        child: Row(
          children: [
            Icon(
              Icons.edit,
              size: 24,
              color: Colors.black87,
            ),
            SizedBox(
              width: 12,
            ),
            Text(
              "Edit Infomation",
              style: TextStyle(
                  color: Colors.black87,
                  fontSize: 18,
                  fontWeight: FontWeight.w500),
            )
          ],
        ));
  }
}

/* class HeaderCurvedContainer extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()..color = MyColors.thirdColor;
    Path path = Path()
      ..relativeLineTo(0, 50)
      ..quadraticBezierTo(size.width / 2, 225, size.width, 50)
      ..relativeLineTo(0, -50)
      ..close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
} */
