import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:web_project/action_service.dart';
import 'package:web_project/globalWidgetDashboard.dart';
import 'package:web_project/sign_up.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

import 'auth_service.dart';
import 'bucket_service.dart';
import 'calendar_service.dart';
import 'cloudStorage.dart';
import 'color.dart';
import 'firebase_options.dart';
import 'globalFunction.dart';
import 'global_service.dart';
import 'home.dart';
import 'lessonDetail.dart';
import 'lesson_service.dart';
import 'memberList.dart';
import 'member_service.dart';
import 'globalWidget.dart';

/// 브랜치 테스트
/// /// 브랜치 테스트222

GlobalFunction globalfunction = GlobalFunction();

late SharedPreferences prefs;

bool isLogInActiveChecked = false;

late TextEditingController emailController;
late TextEditingController passwordController;

TextEditingController switchController =
    TextEditingController(text: "이메일 / 비밀번호 기억하기");

String? userEmail;
String? userPassword;

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // main 함수에서 async 사용하기 위함
  prefs = await SharedPreferences.getInstance();

  isLogInActiveChecked = prefs.getBool("isLogInActiveChecked") ?? false;
  userEmail = prefs.getString("userEmail");
  userPassword = prefs.getString("userPassword");
  print("prefs check isLogInActiveChecked : ${isLogInActiveChecked}");
  print("prefs check userEmail : ${userEmail}");
  print("prefs check userPassword : ${userPassword}");

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  ); // firebase 앱 시작
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthService()),
        ChangeNotifierProvider(create: (context) => BucketService()),
        ChangeNotifierProvider(create: (context) => GlobalService()),
        ChangeNotifierProvider(create: (context) => MemberService()),
        ChangeNotifierProvider(create: (context) => LessonService()),
        ChangeNotifierProvider(create: (context) => CalendarService()),
        ChangeNotifierProvider(create: (context) => ActionService()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  static FirebaseAnalytics analytics = FirebaseAnalytics.instance;

  @override
  Widget build(BuildContext context) {
    final user = context.read<AuthService>().currentUser();
    emailController = TextEditingController(text: userEmail);
    passwordController = TextEditingController(text: userPassword);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorObservers: [
        FirebaseAnalyticsObserver(analytics: analytics),
      ],
      theme: ThemeData(fontFamily: 'Pretendard'),
      home: user == null ? LoginPage() : MemberList(),
    );
  }
}

/// 로그인 페이지
class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    userEmail = prefs.getString("userEmail");
    userPassword = prefs.getString("userPassword");
    print("prefs check isLogInActiveChecked : ${isLogInActiveChecked}");
    print("prefs check userEmail : ${userEmail}");
    print("prefs check userPassword : ${userPassword}");

    emailController = TextEditingController(text: userEmail);
    passwordController = TextEditingController(text: userPassword);

    return Consumer<AuthService>(
      builder: (context, authService, child) {
        final user = authService.currentUser();
        return Scaffold(
          backgroundColor: Palette.secondaryBackground,
          // 디자인적 요소 더하기 위해 appBar 제거
          // appBar: BaseAppBarMethod(context, "로그인", null),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                /// 현재 유저 로그인 상태
                Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: 20),
                      SizedBox(
                        child: Column(
                          children: [
                            Text(
                              "Better Coach",
                              style: GoogleFonts.pacifico(
                                textStyle: TextStyle(height: 1),
                                fontSize: 48,
                                color: Palette.buttonOrange,
                              ),
                            ),
                            SizedBox(height: 20),
                            Text(
                              "필라테스 강사를 위한 레슨 기록앱",
                              style: TextStyle(
                                  fontSize: 14, color: Palette.gray66),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20),
                      SizedBox(
                        height: 150,
                        child: Image.asset("assets/images/login_main.png",
                            width: 200),
                      ),
                      SizedBox(height: 10),
                      SizedBox(
                        child: Text(
                          user == null
                              ? "Pilates is complete coordination of body, mind and spirit."
                              : "${user.email}님 안녕하세요 👋",
                          style: user == null
                              ? TextStyle(fontSize: 12, color: Palette.gray66)
                              : TextStyle(fontSize: 14),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      SizedBox(height: 10),
                      SizedBox(
                        height: 40,
                        child: Text(
                          "Joseph Pilates",
                          style: user == null
                              ? TextStyle(fontSize: 12)
                              : TextStyle(fontSize: 14),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),

                Text(
                  '로그인',
                  style: TextStyle(
                      color: Palette.gray66,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),

                /// 이메일
                LoginTextField(
                  customController: emailController,
                  hint: "이메일",
                  width: 100,
                  height: 100,
                  customFunction: () {},
                  isSecure: false,
                ),
                SizedBox(height: 10),

                /// 비밀번호
                LoginTextField(
                  customController: passwordController,
                  hint: "비밀번호",
                  width: 100,
                  height: 100,
                  customFunction: () {},
                  isSecure: true,
                ),

                SizedBox(height: 10),

                Center(
                  child: SizedBox(
                    height: 40,
                    width: 250,
                    child: TextField(
                      readOnly: true,
                      controller: switchController,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        suffixIcon: Switch(
                          value: isLogInActiveChecked,
                          onChanged: (value) {
                            setState(() {
                              isLogInActiveChecked = !isLogInActiveChecked;
                              // if (isLogInActiveChecked) {
                              prefs.setString(
                                  "userEmail", emailController.text);
                              prefs.setString(
                                  "userPassword", passwordController.text);
                              // }

                              print(
                                  "isLogInActiveChecked : ${isLogInActiveChecked}");
                            });
                          },
                        ),
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 32),

                /// 로그인 버튼
                ElevatedButton(
                  child: Padding(
                    padding: const EdgeInsets.all(14.0),
                    child: Text("로그인", style: TextStyle(fontSize: 18)),
                  ),
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    backgroundColor: Palette.buttonOrange,
                  ),
                  onPressed: () {
                    loginMethod(context, authService);
                  },
                ),
                SizedBox(height: 10),

                /// 회원가입 버튼
                ElevatedButton(
                  child: Padding(
                    padding: const EdgeInsets.all(14.0),
                    child: Text("회원가입", style: TextStyle(fontSize: 18)),
                  ),
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    backgroundColor: Palette.buttonOrange,
                  ),
                  onPressed: () {
                    // 회원가입
                    print("sign up");
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => SignUp()),
                    );
                  },
                ),
                SizedBox(height: 30),

                //   // 버켓리스트 버튼
                //   ElevatedButton(
                //     child: Text("버켓리스트", style: TextStyle(fontSize: 20)),
                //     onPressed: () {
                //       // 로그인
                //       authService.signIn(
                //         email: emailController.text,
                //         password: passwordController.text,
                //         onSuccess: () {
                //           // 로그인 성공
                //           ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                //             content: Text("로그인 성공"),
                //           ));
                //           // 로그인 성공시 Home로 이동
                //           Navigator.pushReplacement(
                //             context,
                //             MaterialPageRoute(builder: (_) => HomePage()),
                //           );
                //         },
                //         onError: (err) {
                //           // 에러 발생
                //           ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                //             content: Text(err),
                //           ));
                //         },
                //       );
                //     },
                //   ),
                //   SizedBox(height: 10),

                //   /// Cloud Storage 개발화면 버튼
                //   ElevatedButton(
                //     child: Text("클라우드 스토리지", style: TextStyle(fontSize: 20)),
                //     onPressed: () {
                //       // 회원가입
                //       print("cloud storage");
                //       Navigator.push(
                //         context,
                //         MaterialPageRoute(builder: (_) => CloudStorage()),
                //       );
                //     },
                //   ),
                //   SizedBox(height: 10),

                // /// Cloud Storage 개발화면 버튼
                // ElevatedButton(
                //   child: Text("글로벌 위젯 대쉬보드", style: TextStyle(fontSize: 20)),
                //   onPressed: () {
                //     // 회원가입
                //     print("global widget");
                //     Navigator.push(
                //       context,
                //       MaterialPageRoute(
                //         builder: (_) => GlobalWidgetDashboard(),
                //       ),
                //     );
                //   },
                // ),
              ],
            ),
          ),
        );
      },
    );
  }

  void loginMethod(BuildContext context, AuthService authService) {
    if (globalfunction.textNullCheck(
          context,
          emailController,
          "이메일",
        ) &&
        globalfunction.textNullCheck(
          context,
          passwordController,
          "비밀번호",
        )) {
      // 로그인
      authService.signIn(
        email: emailController.text,
        password: passwordController.text,
        onSuccess: () {
          // 로그인 성공
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("로그인 성공"),
          ));
          // 로그인 성공시 Home로 이동
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => MemberList()),
          );

          emailController.clear();
          passwordController.clear();
        },
        onError: (err) {
          // 에러 발생
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(err),
          ));
        },
      );

      prefs.setBool("isLogInActiveChecked", isLogInActiveChecked);

      if (isLogInActiveChecked) {
        prefs.setString("userEmail", emailController.text);
        prefs.setString("userPassword", passwordController.text);
        print("switch on isLogInActiveChecked : ${isLogInActiveChecked}");
      } else {
        prefs.setString("userEmail", "");
        prefs.setString("userPassword", "");
        print("switch off isLogInActiveChecked : ${isLogInActiveChecked}");
      }
    }
  }
}

/// 홈페이지
class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController jobController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final authService = context.read<AuthService>();
    final user = authService.currentUser()!;
    return Consumer<BucketService>(
      builder: (context, bucketService, child) {
        return Scaffold(
          appBar: AppBar(
            title: Text("버킷 리스트"),
            actions: [
              TextButton(
                child: Text(
                  "로그아웃",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                onPressed: () {
                  print("sign out");
                  // 로그아웃
                  context.read<AuthService>().signOut();
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => LoginPage()),
                  );
                },
              ),
            ],
          ),
          body: Column(
            children: [
              /// 입력창
              Padding(
                padding: const EdgeInsets.all(8),
                child: Row(
                  children: [
                    /// 텍스트 입력창
                    Expanded(
                      child: TextField(
                        controller: jobController,
                        decoration: InputDecoration(
                          hintText: "하고 싶은 일을 입력해주세요.",
                        ),
                      ),
                    ),

                    /// 추가 버튼
                    ElevatedButton(
                      child: Icon(Icons.add),
                      onPressed: () {
                        // create bucket
                        if (jobController.text.isNotEmpty) {
                          print("create bucket");
                          bucketService.create(jobController.text, user.uid);
                        }
                      },
                    ),
                  ],
                ),
              ),
              Divider(height: 1),

              /// 버킷 리스트
              Expanded(
                child: FutureBuilder<QuerySnapshot>(
                    future: bucketService.read(user.uid),
                    builder: (context, snapshot) {
                      final docs = snapshot.data?.docs ?? []; // 문서들 가져오기
                      if (docs.isEmpty) {
                        return Center(child: Text("버킷 리스트를 작성해주세요."));
                      }
                      return ListView.builder(
                        itemCount: docs.length,
                        itemBuilder: (context, index) {
                          final doc = docs[index];
                          String job = doc.get('job');
                          bool isDone = doc.get('isDone');
                          return ListTile(
                            title: Text(
                              job,
                              style: TextStyle(
                                fontSize: 24,
                                color: isDone ? Colors.grey : Colors.black,
                                decoration: isDone
                                    ? TextDecoration.lineThrough
                                    : TextDecoration.none,
                              ),
                            ),
                            // 삭제 아이콘 버튼
                            trailing: IconButton(
                              icon: Icon(CupertinoIcons.delete),
                              onPressed: () {
                                // 삭제 버튼 클릭시
                                bucketService.delete(doc.id);
                              },
                            ),
                            onTap: () {
                              // 아이템 클릭하여 isDone 업데이트
                              bucketService.update(doc.id, !isDone);
                            },
                          );
                        },
                      );
                    }),
              ),
            ],
          ),
        );
      },
    );
  }
}
