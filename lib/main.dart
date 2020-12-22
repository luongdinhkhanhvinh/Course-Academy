import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './providers/auth.dart';
import './providers/categories.dart';
import './providers/courses.dart';
import './screens/auth_screen.dart';
import './screens/login_screen.dart';
import './constants.dart';
import './screens/webview_screen.dart';
import './screens/tabs_screen.dart';
import './screens/courses_screen.dart';
import './screens/course_detail_screen.dart';
import './screens/edit_profile_screen.dart';
import './screens/edit_password_screen.dart';
import './screens/my_course_detail_screen.dart';
import './screens/webview_screen_iframe.dart';
import './screens/temp_view_screen.dart';
import './providers/misc_provider.dart';
import './providers/my_courses.dart';

void main() {
  // SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
  //   statusBarColor: Colors.transparent,
  //   statusBarBrightness: Brightness.light,
  // ));

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => Auth(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => Categories(),
        ),
        ChangeNotifierProxyProvider<Auth, Courses>(
          create: (ctx) => Courses(null, [], []),
          update: (ctx, auth, prevoiusCourses) => Courses(
            auth.token,
            prevoiusCourses == null ? [] : prevoiusCourses.items,
            prevoiusCourses == null ? [] : prevoiusCourses.topItems,
          ),
        ),
        ChangeNotifierProxyProvider<Auth, MyCourses>(
          create: (ctx) => MyCourses(null, []),
          update: (ctx, auth, previousMyCourses) => MyCourses(
            auth.token,
            previousMyCourses == null ? [] : previousMyCourses.items,
          ),
        ),
        ChangeNotifierProvider(
          create: (ctx) => Languages(),
        ),
      ],
      child: Consumer<Auth>(
          builder: (ctx, auth, _) => MaterialApp(
                  title: 'Academy App',
                  theme: ThemeData(
                    primarySwatch: Colors.blue,
                    accentColor: kDarkButtonBg,
                    fontFamily: 'google_sans',
                  ),
                  debugShowCheckedModeBanner: false,
                  home: auth.isAuth
                      ? TabsScreen()
                      : FutureBuilder(
                          future: auth.tryAutoLogin(),
                          builder: (ctx, authResultSnapshot) =>
                              authResultSnapshot.connectionState ==
                                      ConnectionState.waiting
                                  ? Center(
                                      child: CircularProgressIndicator(),
                                    )
                                  : TabsScreen(),
                        ),
                  routes: {
                    '/home': (ctx) => TabsScreen(),
                    AuthScreen.routeName: (ctx) => AuthScreen(),
                    LoginScreen.routeName: (ctx) => LoginScreen(),
                    WebviewScreen.routeName: (ctx) => WebviewScreen(),
                    WebviewScreenIframe.routeName: (ctx) =>
                        WebviewScreenIframe(),
                    CoursesScreen.routeName: (ctx) => CoursesScreen(),
                    CourseDetailScreen.routeName: (ctx) => CourseDetailScreen(),
                    EditProfileScreen.routeName: (ctx) => EditProfileScreen(),
                    EditPasswordScreen.routeName: (ctx) => EditPasswordScreen(),
                    MyCourseDetailScreen.routeName: (ctx) =>
                        MyCourseDetailScreen(),
                    TempViewScreen.routeName: (ctx) => TempViewScreen(),
                  })),
    );
  }
}
