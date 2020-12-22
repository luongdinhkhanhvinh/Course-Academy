import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:share/share.dart';
import '../providers/my_courses.dart';
import '../widgets/video_player_widget.dart';
import '../widgets/my_course_header.dart';
import '../widgets/custom_text.dart';
import '../models/lesson.dart';
import '../constants.dart';
import '../models/common_functions.dart';
import '../screens/course_detail_screen.dart';
import '../widgets/my_course_detail_header.dart';
import '../widgets/youtube_player_widget.dart';
import '../screens/webview_screen.dart';
import '../screens/webview_screen_iframe.dart';
import '../screens/temp_view_screen.dart';

class MyCourseDetailScreen extends StatefulWidget {
  static const routeName = '/my-course-details';
  @override
  _MyCourseDetailScreenState createState() => _MyCourseDetailScreenState();
}

class _MyCourseDetailScreenState extends State<MyCourseDetailScreen> {
  var _isInit = true;
  // var _isAuth = false;
  var _isLoading = false;
  // ignore: avoid_init_to_null
  Lesson _activeLesson = null;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      final myCourseId = ModalRoute.of(context).settings.arguments as int;

      Provider.of<MyCourses>(context, listen: false)
          .fetchCourseSections(myCourseId)
          .then((_) {
        final activeSections =
            Provider.of<MyCourses>(context, listen: false).sectionitems;
        setState(() {
          _isLoading = false;
          _activeLesson = activeSections.first.mLesson.first;
        });
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  Widget setPageheader(Lesson activelesson) {
    if (activelesson.lessonType == 'video') {
      if (activelesson.videoTypeWeb == 'system' ||
          activelesson.videoTypeWeb == 'html5') {
        return VideoPlayerWidget(
            videoUrl: activelesson.videoUrlWeb, newKey: UniqueKey());
      } else {
        return MyCourseHeader(lesson: activelesson);
        // return CourseYoutubePlayerWidget(
        // videoUrl: activelesson.videoUrlWeb, newKey: UniqueKey());
      }
    } else {
      return MyCourseHeader(lesson: activelesson);
    }
  }

  void _showYoutubeModal(BuildContext ctx) {
    showModalBottomSheet(
      context: ctx,
      isScrollControlled: true,
      builder: (_) {
        return YoutubePlayerWidget(
          videoUrl: _activeLesson.videoUrlWeb,
          newKey: UniqueKey(),
        );
      },
    );
  }

  void lessonAction(Lesson lesson) {
    if (lesson.lessonType == 'video') {
      if (lesson.videoTypeWeb == 'system' || lesson.videoTypeWeb == 'html5') {
        Navigator.of(context)
            .pushNamed(TempViewScreen.routeName, arguments: lesson.videoUrlWeb);
      } else {
        _showYoutubeModal(context);
      }
    } else if (lesson.lessonType == 'quiz') {
      final _url = BASE_URL + '/home/quiz_mobile_web_view/${lesson.id}';
      Navigator.of(context).pushNamed(WebviewScreen.routeName, arguments: _url);
    } else {
      if (lesson.attachmentType == 'iframe') {
        final _url = lesson.attachment;
        Navigator.of(context)
            .pushNamed(WebviewScreenIframe.routeName, arguments: _url);
      } else {
        final _url = lesson.attachmentUrl;
        Navigator.of(context)
            .pushNamed(WebviewScreen.routeName, arguments: _url);
      }
    }
  }

  Widget getLessonSubtitle(Lesson lesson) {
    if (lesson.lessonType == 'video') {
      return Customtext(
        text: lesson.duration,
        fontSize: 12,
      );
    } else if (lesson.lessonType == 'quiz') {
      return RichText(
        text: TextSpan(
          children: [
            WidgetSpan(
              child: Icon(
                Icons.event_note,
                size: 12,
                color: kSecondaryColor,
              ),
            ),
            TextSpan(
                text: 'Câu hỏi',
                style: TextStyle(fontSize: 12, color: kSecondaryColor)),
          ],
        ),
      );
    } else {
      return RichText(
        text: TextSpan(
          children: [
            WidgetSpan(
              child: Icon(
                Icons.attach_file,
                size: 12,
                color: kSecondaryColor,
              ),
            ),
            TextSpan(
                text: 'Tập tin đính kèm',
                style: TextStyle(fontSize: 12, color: kSecondaryColor)),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final myCourseId = ModalRoute.of(context).settings.arguments as int;
    final myLoadedCourse =
        Provider.of<MyCourses>(context, listen: false).findById(myCourseId);
    final sections =
        Provider.of<MyCourses>(context, listen: false).sectionitems;
    var lessonCount = 0;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(200),
        child: MyCourseDetailHeader(loadedCourse: myLoadedCourse),
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              children: <Widget>[
                // _activeLesson != null
                //     ? setPageheader(_activeLesson)
                //     : Container(
                //         child: Text('No Lesson Found'),
                //       ),
                Container(
                  width: double.infinity,
                  padding:
                      EdgeInsets.only(top: 10, left: 20, right: 20, bottom: 3),
                  child: Customtext(
                    text: _activeLesson.title,
                    fontSize: 24,
                    colors: kTextColor,
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        flex: 9,
                        child: Container(
                          child: LinearPercentIndicator(
                            lineHeight: 8.0,
                            percent: myLoadedCourse.courseCompletion / 100,
                            progressColor: Colors.blue,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: PopupMenuButton(
                            onSelected: (value) {
                              if (value == 'details') {
                                Navigator.of(context).pushNamed(
                                    CourseDetailScreen.routeName,
                                    arguments: myLoadedCourse.id);
                              } else {
                                Share.share(myLoadedCourse.shareableLink);
                              }
                            },
                            icon: Icon(
                              Icons.more_vert,
                            ),
                            itemBuilder: (_) => [
                                  PopupMenuItem(
                                    child: Text('Chi tiết khoá học'),
                                    value: 'details',
                                  ),
                                  PopupMenuItem(
                                    child: Text('Chia sẻ khoá học'),
                                    value: 'share',
                                  ),
                                ]),
                      )
                    ],
                  ),
                ),
                Customtext(
                  text:
                      '${myLoadedCourse.totalNumberOfCompletedLessons}/${myLoadedCourse.totalNumberOfLessons} Bài học đã được hoàn thành',
                  fontSize: 14,
                  colors: Colors.grey,
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (ctx, index) {
                        // return Text(sections[index].title);
                        final section = sections[index];

                        return Column(
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 30),
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: kSectionTileColor,
                                boxShadow: [kDefaultShadow],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Customtext(
                                    text: 'Phần ${index + 1}',
                                    fontSize: 12,
                                  ),
                                  Customtext(
                                    text: section.title,
                                    fontSize: 14,
                                    colors: kTextColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  Customtext(
                                    text: '${section.mLesson.length} Bài',
                                    fontSize: 12,
                                  ),
                                ],
                              ),
                            ),
                            ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemBuilder: (ctx, index) {
                                // return LessonListItem(
                                //   lesson: section.mLesson[index],
                                // );
                                final lesson = section.mLesson[index];
                                lessonCount += 1;
                                return InkWell(
                                  onTap: () {
                                    setState(() {
                                      _activeLesson = lesson;
                                    });
                                    lessonAction(lesson);
                                  },
                                  child: Column(
                                    children: <Widget>[
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                            vertical: 10, horizontal: 30),
                                        width: double.infinity,
                                        child: Row(
                                          children: <Widget>[
                                            Expanded(
                                                flex: 2,
                                                child: Customtext(
                                                  text: lessonCount.toString(),
                                                  fontSize: 16,
                                                )),
                                            Expanded(
                                                flex: 8,
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: <Widget>[
                                                    Customtext(
                                                      text: lesson.title,
                                                      fontSize: 14,
                                                      colors: kTextColor,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                    getLessonSubtitle(lesson),
                                                  ],
                                                )),
                                            Expanded(
                                              flex: 2,
                                              child: Checkbox(
                                                  value:
                                                      lesson.isCompleted == '1'
                                                          ? true
                                                          : false,
                                                  onChanged: (bool value) {
                                                    print(value);

                                                    setState(() {
                                                      lesson.isCompleted =
                                                          value ? '1' : '0';
                                                      if (value) {
                                                        myLoadedCourse
                                                            .totalNumberOfCompletedLessons += 1;
                                                      } else {
                                                        myLoadedCourse
                                                            .totalNumberOfCompletedLessons -= 1;
                                                      }
                                                      var completePerc = (myLoadedCourse
                                                                  .totalNumberOfCompletedLessons /
                                                              myLoadedCourse
                                                                  .totalNumberOfLessons) *
                                                          100;
                                                      myLoadedCourse
                                                              .courseCompletion =
                                                          completePerc.round();
                                                    });
                                                    Provider.of<MyCourses>(
                                                            context,
                                                            listen: false)
                                                        .toggleLessonCompleted(
                                                            lesson.id,
                                                            value ? 1 : 0)
                                                        .then((_) => CommonFunctions
                                                            .showSuccessToast(
                                                                'Tiến trình khóa học đã cập nhật'));
                                                  }),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Divider(),
                                    ],
                                  ),
                                );
                                // return Text(section.mLesson[index].title);
                              },
                              itemCount: section.mLesson.length,
                            )
                          ],
                        );
                      },
                      itemCount: sections.length,
                    ),
                  ),
                )
              ],
            ),
    );
  }
}
