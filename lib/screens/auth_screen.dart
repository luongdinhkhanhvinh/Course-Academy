import '../models/common_functions.dart';
import './webview_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth.dart';
import '../models/http_exception.dart';
import '../constants.dart';

enum AuthMode { Signup, Login }

class AuthScreen extends StatelessWidget {
  static const routeName = '/auth';

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    // final transformConfig = Matrix4.rotationZ(-8 * pi / 180);
    // transformConfig.translate(-10.0);
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
      // resizeToAvoidBottomInset: false,
      body: Stack(
        children: <Widget>[
          SingleChildScrollView(
            child: Container(
              height: deviceSize.height,
              width: deviceSize.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    child: Image.asset(
                      'assets/images/academy_icon.png',
                      fit: BoxFit.cover,
                      height: 33,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(bottom: 20.0),
                    padding:
                        EdgeInsets.symmetric(vertical: 4.0, horizontal: 94.0),
                    child: Text(
                      'Đăng nhập Academy',
                      style: TextStyle(
                        color: kTextColor,
                        fontSize: 30,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ),
                  Flexible(
                    flex: deviceSize.width > 600 ? 2 : 1,
                    child: AuthCard(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AuthCard extends StatefulWidget {
  const AuthCard({
    Key key,
  }) : super(key: key);

  @override
  _AuthCardState createState() => _AuthCardState();
}

class _AuthCardState extends State<AuthCard> {
  final GlobalKey<FormState> _formKey = GlobalKey();

  Map<String, String> _authData = {
    'email': '',
    'password': '',
  };
  var _isLoading = false;
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
      // Log user in
      await Provider.of<Auth>(context, listen: false).login(
        _authData['email'],
        _authData['password'],
      );

      Navigator.pushNamedAndRemoveUntil(context, '/home', (r) => false);
      CommonFunctions.showSuccessToast('Đăng nhập thành công');
    } on HttpException catch (error) {
      print(error);
      var errorMsg = 'Đăng nhập thất bại';
      CommonFunctions.showErrorDialog(errorMsg, context);
    } catch (error) {
      print(error);
      const errorMsg = 'Không thể xác thực!';
      CommonFunctions.showErrorDialog(errorMsg, context);
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Container(
      height: 360,
      constraints: BoxConstraints(minHeight: 260),
      width: deviceSize.width * 0.8,
      padding: EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Địa chỉ Email',
                  prefixIcon: Icon(
                    Icons.mail_outline,
                    color: Colors.grey,
                  ), // myIcon is a 48px-wide widget.
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value.isEmpty || !value.contains('@')) {
                    return 'Email tồn tại!';
                  }
                  return value;
                },
                onSaved: (value) {
                  _authData['email'] = value;
                },
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Mật khẩu',
                  prefixIcon: Icon(
                    Icons.vpn_key,
                    color: Colors.grey,
                  ),
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
                  _authData['password'] = value;
                },
              ),
              SizedBox(
                height: 20,
              ),
              if (_isLoading)
                CircularProgressIndicator()
              else
                ButtonTheme(
                  minWidth: deviceSize.width * 0.8,
                  child: RaisedButton(
                    child: Text(
                      'Đăng nhập',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    onPressed: _submit,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(7.0),
                      side: BorderSide(color: kBlueColor),
                    ),
                    splashColor: Colors.blueAccent,
                    padding:
                        EdgeInsets.symmetric(horizontal: 50.0, vertical: 20),
                    color: kBlueColor,
                    textColor: Colors.white,
                  ),
                ),
              SizedBox(
                height: 20,
              ),
              ButtonTheme(
                minWidth: deviceSize.width * 0.8,
                child: RaisedButton(
                  child: Text(
                    'Tạo tài khoản',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  onPressed: () {
                    final _url = BASE_URL + '/home/sign_up';
                    Navigator.of(context)
                        .pushNamed(WebviewScreen.routeName, arguments: _url);
                  },
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(7.0),
                    side: BorderSide(color: kGreyColor),
                  ),
                  splashColor: Colors.blueAccent,
                  padding: EdgeInsets.symmetric(horizontal: 50.0, vertical: 20),
                  color: kGreyColor,
                  textColor: kTextColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
