import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth.dart';
import '../constants.dart';
import '../widgets/custom_text.dart';
import '../widgets/user_image_picker.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'dart:io';
import '../models/user.dart';
import '../models/common_functions.dart';

class EditProfileScreen extends StatefulWidget {
  static const routeName = '/edit-profile';
  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  var _isLoading = false;
  Map<String, String> _userData = {
    'first_name': '',
    'last_name': '',
    'email': '',
    'bio': '',
    'twitter': '',
    'facebook': '',
    'linkedin': '',
  };

  Future<void> _submit() async {
    if (!_formKey.currentState.validate()) {
      // Invalid!
      return;
    }
    _formKey.currentState.save();
    setState(() {
      _isLoading = true;
    });
    try {
      // Log user in
      final updateUser = User(
        userId: 'Temp',
        firstName: _userData['first_name'],
        lastName: _userData['last_name'],
        email: _userData['email'],
        role: 'Temp',
        biography: _userData['bio'],
        twitter: _userData['twitter'],
        facebook: _userData['facebook'],
        linkedIn: _userData['linkedin'],
      );
      await Provider.of<Auth>(context, listen: false)
          .updateUserData(updateUser);

      CommonFunctions.showSuccessToast('Người dùng cập nhật thành công');
    } on HttpException catch (error) {
      print(error);
      var errorMsg = 'Cập nhật thất bại';
      CommonFunctions.showErrorDialog(errorMsg, context);
    } catch (error) {
      print(error);
      const errorMsg = 'Cập nhật thất bại!';
      CommonFunctions.showErrorDialog(errorMsg, context);
    }
    setState(() {
      _isLoading = false;
    });
  }

  InputDecoration getInputDecoration(String hintext, IconData iconData) {
    return InputDecoration(
      enabledBorder: kDefaultInputBorder,
      focusedBorder: kDefaultFocusInputBorder,
      focusedErrorBorder: kDefaultFocusErrorBorder,
      errorBorder: kDefaultFocusErrorBorder,
      filled: true,
      hintStyle: TextStyle(color: kFormInputColor),
      hintText: hintext,
      fillColor: Colors.white70,
      prefixIcon: Icon(
        iconData,
        color: kFormInputColor,
      ),
      contentPadding: EdgeInsets.symmetric(vertical: 5),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<Auth>(context, listen: false).user;
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: kSecondaryColor, //change your color here
        ),
        title: Image.asset(
          'assets/images/logo.png',
          fit: BoxFit.contain,
          height: 32,
        ),
        backgroundColor: kBackgroundColor,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              width: double.infinity,
              child: UserImagePicker(),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Customtext(
                  text: 'Thông tin cơ bản',
                  colors: kTextColor,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            _isLoading
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(10.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          TextFormField(
                            style: TextStyle(fontSize: 16),
                            initialValue: user.firstName,
                            decoration: getInputDecoration(
                              'Họ',
                              Icons.account_circle,
                            ),
                            keyboardType: TextInputType.text,
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Không được để trống';
                              }
                              return value;
                            },
                            onSaved: (value) {
                              _userData['first_name'] = value;
                            },
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          TextFormField(
                            style: TextStyle(fontSize: 16),
                            initialValue: user.lastName,
                            decoration: getInputDecoration(
                              'Tên',
                              Icons.account_circle,
                            ),
                            keyboardType: TextInputType.text,
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Không được để trống';
                              }
                              return value;
                            },
                            onSaved: (value) {
                              _userData['last_name'] = value;
                            },
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          TextFormField(
                            style: TextStyle(fontSize: 16),
                            initialValue: user.email,
                            decoration: getInputDecoration(
                              'Email',
                              Icons.email,
                            ),
                            keyboardType: TextInputType.emailAddress,
                            validator: (value) {
                              if (value.isEmpty || !value.contains('@')) {
                                return 'Email tồn tại!';
                              }
                              return value;
                            },
                            onSaved: (value) {
                              _userData['email'] = value;
                            },
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          TextFormField(
                            style: TextStyle(fontSize: 16),
                            initialValue: user.biography,
                            decoration: getInputDecoration(
                              'Tiểu sử',
                              Icons.edit,
                            ),
                            keyboardType: TextInputType.multiline,
                            maxLines: 5,
                            onSaved: (value) {
                              _userData['bio'] = value;
                            },
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          TextFormField(
                            style: TextStyle(fontSize: 16),
                            initialValue: user.facebook,
                            decoration: getInputDecoration(
                              'Facebook Link',
                              MdiIcons.facebook,
                            ),
                            keyboardType: TextInputType.emailAddress,
                            onSaved: (value) {
                              _userData['facebook'] = value;
                            },
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          TextFormField(
                            style: TextStyle(fontSize: 16),
                            initialValue: user.twitter,
                            decoration: getInputDecoration(
                              'Twitter Link',
                              MdiIcons.twitter,
                            ),
                            keyboardType: TextInputType.emailAddress,
                            onSaved: (value) {
                              _userData['twitter'] = value;
                            },
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          TextFormField(
                            style: TextStyle(fontSize: 16),
                            initialValue: user.linkedIn,
                            decoration: getInputDecoration(
                              'LinkedIn Link',
                              MdiIcons.linkedin,
                            ),
                            keyboardType: TextInputType.emailAddress,
                            onSaved: (value) {
                              _userData['linkedin'] = value;
                            },
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          SizedBox(
                            width: double.infinity,
                            child: RaisedButton(
                              onPressed: _submit,
                              child: Text(
                                'CẬP NHẬT',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              color: kBlueColor,
                              textColor: Colors.white,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 15),
                              splashColor: Colors.blueAccent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(7.0),
                                side: BorderSide(color: kBlueColor),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                        ],
                      ),
                    ),
                  )
          ],
        ),
      ),
    );
  }
}
