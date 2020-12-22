import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth.dart';
import '../constants.dart';
import '../widgets/custom_text.dart';
import 'dart:io';
import '../models/common_functions.dart';

class EditPasswordScreen extends StatefulWidget {
  static const routeName = '/edit-password';
  @override
  _EditPasswordScreenState createState() => _EditPasswordScreenState();
}

class _EditPasswordScreenState extends State<EditPasswordScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  var _isLoading = false;
  Map<String, String> _passwordData = {
    'oldPassword': '',
    'newPassword': '',
  };
  final _passwordController = TextEditingController();

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
      await Provider.of<Auth>(context, listen: false).updateUserPassword(
          _passwordData['oldPassword'], _passwordData['newPassword']);

      CommonFunctions.showSuccessToast('Mật khẩu đã được cập nhật thành công');
    } on HttpException catch (error) {
      print(error);
      var errorMsg = 'Mật khẩu cập nhật thất bại';
      CommonFunctions.showErrorDialog(errorMsg, context);
    } catch (error) {
      print(error);
      const errorMsg = 'Cập nhật mật khẩu  đã thất bại!';
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
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Customtext(
                  text: 'Cập nhật mật khẩu',
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
                            decoration: getInputDecoration(
                              'Mật khẩu hiện tại',
                              Icons.vpn_key,
                            ),
                            obscureText: true,
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Không được để trống';
                              }
                              return value;
                            },
                            onSaved: (value) {
                              _passwordData['oldPassword'] = value;
                            },
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          TextFormField(
                            style: TextStyle(fontSize: 16),
                            decoration: getInputDecoration(
                              'Mật khẩu mới',
                              Icons.vpn_key,
                            ),
                            obscureText: true,
                            controller: _passwordController,
                            validator: (value) {
                              if (value.isEmpty || value.length < 4) {
                                return 'Mật khẩu quá ngắn!';
                              }
                              return value;
                            },
                            onSaved: (value) {
                              _passwordData['newPassword'] = value;
                            },
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          TextFormField(
                            style: TextStyle(fontSize: 16),
                            decoration: getInputDecoration(
                              'Mật khẩu xác nhận',
                              Icons.vpn_key,
                            ),
                            obscureText: true,
                            validator: (value) {
                              if (value != _passwordController.text) {
                                return 'Mật khẩu không trùng khớp!';
                              }
                              return value;
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
                                'CẬP NHẬP',
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
                        ],
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
