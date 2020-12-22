import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';
import '../constants.dart';
import '../providers/courses.dart';
import '../providers/auth.dart';
import '../widgets/section_list_item.dart';
import '../widgets/tab_view_details.dart';
import '../widgets/course_detail_header.dart';
import './webview_screen.dart';
import '../widgets/custom_text.dart';
import '../models/common_functions.dart';

class CourseDetailScreen extends StatefulWidget {
  static const routeName = '/course-details';

  @override
  _CourseDetailScreenState createState() => _CourseDetailScreenState();
}

class _CourseDetailScreenState extends State<CourseDetailScreen>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  var _isInit = true;
  var _isAuth = false;
  var _authToken = '';

  @override
  void initState() {
    _tabController = TabController(length: 3, vsync: this);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isAuth = Provider.of<Auth>(context, listen: false).isAuth;
        _authToken = Provider.of<Auth>(context, listen: false).token;
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final courseId = ModalRoute.of(context).settings.arguments as int;
    final loadedCourse = Provider.of<Courses>(
      context,
      listen: false,
    ).findById(courseId);

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(200),
        child: CourseDetailHeader(loadedCourse: loadedCourse),
      ),
      body: FutureBuilder(
        future: Provider.of<Courses>(context, listen: false)
            .fetchCourseDetailById(courseId),
        builder: (ctx, dataSnapshot) {
          if (dataSnapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            if (dataSnapshot.error != null) {
              //error
              return Center(
                child: Text('Có lỗi'),
              );
            } else {
              return Consumer<Courses>(
                builder: (context, courses, child) {
                  final loadedCourseDetail = courses.getCourseDetail;

                  return SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        Container(
                          alignment: Alignment.centerRight,
                          width: double.infinity,
                          padding: EdgeInsets.only(
                              right: 20, left: 20, top: 10, bottom: 5),
                          child: Customtext(
                            text: loadedCourse.price,
                            fontSize: 24,
                            colors: kTextColor,
                          ),
                        ),
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.only(
                              right: 20, left: 20, top: 0, bottom: 5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              IconButton(
                                icon: Icon(
                                  Icons.share,
                                  color: kSecondaryColor,
                                ),
                                tooltip: 'Chia sẻ',
                                onPressed: () {
                                  Share.share(loadedCourse.shareableLink);
                                  // Share.share(
                                  // 'check out my website https://example.com');
                                },
                              ),
                              IconButton(
                                icon: Icon(
                                  loadedCourseDetail.isWishlisted
                                      ? Icons.favorite
                                      : Icons.favorite_border,
                                  color: loadedCourseDetail.isWishlisted
                                      ? kDeepBlueColor
                                      : kSecondaryColor,
                                ),
                                tooltip: 'Giỏ hàng',
                                onPressed: () {
                                  if (_isAuth) {
                                    var msg = loadedCourseDetail.isWishlisted
                                        ? 'Xóa khỏi giỏi hàng'
                                        : 'Đã thêm từ giỏi hàng';
                                    CommonFunctions.showSuccessToast(msg);
                                    courses.toggleWishlist(
                                        loadedCourse.id, false);
                                  } else {
                                    CommonFunctions.showSuccessToast(
                                        'Vui lòng đăng nhập trước');
                                  }
                                },
                              ),
                              RaisedButton(
                                onPressed: () {
                                  if (!loadedCourseDetail.isPurchased) {
                                    final _url = BASE_URL +
                                        '/home/course_purchase/$_authToken/$courseId';
                                    Navigator.of(context).pushNamed(
                                        WebviewScreen.routeName,
                                        arguments: _url);
                                  }
                                },
                                child: Text(
                                  loadedCourseDetail.isPurchased
                                      ? 'Đã mua'
                                      : 'Mua ngay',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18),
                                ),
                                color: loadedCourseDetail.isPurchased
                                    ? kGreenColor
                                    : kBlueColor,
                                textColor: Colors.white,
                                padding: EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 10),
                                splashColor: Colors.blueAccent,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(7.0),
                                  // side: BorderSide(color: kBlueColor),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          color: kTabBarBg,
                          width: double.infinity,
                          padding: EdgeInsets.only(
                              right: 0, left: 0, top: 0, bottom: 0),
                          child: TabBar(
                            controller: _tabController,
                            indicatorColor: kBlueColor,
                            indicatorSize: TabBarIndicatorSize.tab,
                            indicator: BoxDecoration(color: kBlueColor),
                            unselectedLabelColor: kBlueColor,
                            labelColor: Colors.white,
                            tabs: <Widget>[
                              Tab(
                                child: Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                    "Thêm",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ),
                              Tab(
                                child: Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                    "Kết quả",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ),
                              Tab(
                                child: Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                    "Yêu cầu",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: double.infinity,
                          height: 300,
                          padding: EdgeInsets.only(
                              right: 20, left: 20, top: 10, bottom: 10),
                          child: Card(
                            elevation: 4,
                            color: kBackgroundColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: TabBarView(
                              controller: _tabController,
                              children: [
                                TabViewDetails(
                                  titleText: 'Những gì được bao gồm!',
                                  listText: loadedCourseDetail.courseIncludes,
                                  icon: Icons.present_to_all,
                                ),
                                TabViewDetails(
                                  titleText: 'Những gì sẽ được học',
                                  listText: loadedCourseDetail.courseOutcomes,
                                  icon: Icons.check,
                                ),
                                TabViewDetails(
                                  titleText: 'Yêu cầu khoá học',
                                  listText:
                                      loadedCourseDetail.courseRequirements,
                                  icon: Icons.description,
                                ),
                              ],
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: 20, horizontal: 10),
                              child: Customtext(
                                text: 'Khoá học Curriculam',
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                colors: kDarkGreyColor,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: 20, horizontal: 10),
                              child: Icon(
                                Icons.book,
                                color: kSecondaryColor,
                                size: 28,
                              ),
                            ),
                          ],
                        ),
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.only(
                              right: 20, left: 20, top: 10, bottom: 10),
                          child: Card(
                            elevation: 4,
                            color: kBackgroundColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemBuilder: (ctx, index) {
                                return SectionListItem(
                                  section: loadedCourseDetail.mSection[index],
                                );
                              },
                              itemCount: loadedCourseDetail.mSection.length,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            }
          }
        },
      ),
    );
  }
}
