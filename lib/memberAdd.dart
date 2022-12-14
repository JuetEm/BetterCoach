import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'auth_service.dart';
import 'baseTableCalendar.dart';
import 'color.dart';
import 'globalFunction.dart';
import 'globalWidget.dart';
import 'memberList.dart';
import 'member_service.dart';
import 'membershipList.dart';

GlobalFunction globalFunction = GlobalFunction();

String now = DateFormat("yyyy-MM-dd").format(DateTime.now());

class MemberAdd extends StatefulWidget {
  const MemberAdd({super.key});

  @override
  State<MemberAdd> createState() => _MemberAddState();
}

class _MemberAddState extends State<MemberAdd> {
  TextEditingController nameController = TextEditingController();
  TextEditingController registerDateController =
      TextEditingController(text: now);
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController registerTypeController = TextEditingController();
  TextEditingController goalController = TextEditingController();
  TextEditingController infoController = TextEditingController();
  TextEditingController noteController = TextEditingController();
  TextEditingController commentController = TextEditingController();

  Widget build(BuildContext context) {
    final authService = context.read<AuthService>();
    final user = authService.currentUser()!;

    String imgUrl =
        "https://newsimg.hankookilbo.com/cms/articlerelease/2021/01/07/0de90f3e-d3fa-452e-a471-aa0bec4a1252.jpg";
    return Consumer<MemberService>(
      builder: (context, memberService, child) {
        return Scaffold(
          backgroundColor: Palette.secondaryBackground,
          appBar: BaseAppBarMethod(context, "νμ μΆκ°", () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MemberList(),
              ),
            );

            globalFunction.clearTextEditController([
              nameController,
              registerDateController,
              phoneNumberController,
              registerTypeController,
              goalController,
              infoController,
              noteController,
              commentController,
            ]);
            registerDateController.text = now;
          }),
          body: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              children: [
                /// μλ ₯μ°½
                Padding(
                  padding: const EdgeInsets.all(14.0),
                  child: IntrinsicHeight(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // SizedBox(
                        //   height: 200,
                        //   width: 200,
                        //   child: ClipRRect(
                        //     borderRadius: BorderRadius.circular(100),
                        //     child: Image.network(
                        //       imgUrl,
                        //       fit: BoxFit.fill,
                        //     ),
                        //   ),
                        // ),

                        /// μ΄λ¦ μλ ₯μ°½
                        BaseTextField(
                          customController: nameController,
                          hint: "μ΄λ¦",
                          showArrow: false,
                          customFunction: () {},
                        ),

                        /// λ±λ‘μΌ μλ ₯μ°½
                        BaseTextField(
                          customController: registerDateController,
                          hint: "λ±λ‘μΌ",
                          showArrow: true,
                          customFunction: () {
                            globalFunction.getDateFromCalendar(
                                context, registerDateController, "λ±λ‘μΌ");
                          },
                        ),

                        /// μ νλ²νΈ μλ ₯μ°½
                        BaseTextField(
                          customController: phoneNumberController,
                          hint: "μ νλ²νΈ",
                          showArrow: false,
                          customFunction: () {},
                        ),

                        /// λ±λ‘νμμλ ₯μ°½
                        BaseTextField(
                          customController: registerTypeController,
                          hint: "λ±λ‘νμμλ ₯",
                          showArrow: true,
                          customFunction: () {
                            String lessonCount = registerTypeController.text;
                            _getMembership(context, lessonCount);
                          },
                        ),

                        /// μ΄λλͺ©ν μλ ₯μ°½
                        BaseTextField(
                          customController: goalController,
                          hint: "μ΄λλͺ©ν",
                          showArrow: false,
                          customFunction: () {},
                        ),

                        /// μ μ²΄ νΉμ΄μ¬ν­/μ²΄νλΆμ μλ ₯μ°½
                        BaseTextField(
                          customController: infoController,
                          hint: "ν΅μ¦/μν΄/λ³λ ₯",
                          showArrow: false,
                          customFunction: () {},
                        ),

                        /// μ²΄νλΆμ μλ ₯μ°½
                        BaseTextField(
                          customController: noteController,
                          hint: "μ²΄νλΆμ",
                          showArrow: false,
                          customFunction: () {},
                        ),

                        /// νΉμ΄μ¬ν­ μλ ₯μ°½
                        BaseTextField(
                          customController: commentController,
                          hint: "νΉμ΄μ¬ν­",
                          showArrow: false,
                          customFunction: () {},
                        ),
                        Divider(height: 1),

                        /// μΆκ° λ²νΌ
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            elevation: 0,
                            backgroundColor: Palette.buttonOrange,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Text("μ μ₯νκΈ°", style: TextStyle(fontSize: 18)),
                          ),
                          onPressed: () {
                            print("μΆκ° λ²νΌ");
                            // create bucket
                            if (globalFunction.textNullCheck(
                                context, nameController, "μ΄λ¦")) {
                              // globalFunction.textNullCheck(
                              //     context, registerDateController, "λ±λ‘μΌ") &&
                              // globalFunction.textNullCheck(
                              //     context, phoneNumberController, "μ νλ²νΈ") &&
                              // globalFunction.textNullCheck(
                              //     context, registerTypeController, "λ±λ‘νμμλ ₯") &&
                              // globalFunction.textNullCheck(
                              //     context, goalController, "μ΄λλͺ©ν") &&
                              // globalFunction.textNullCheck(
                              //     context, infoController, "ν΅μ¦/μν΄/λ³λ ₯") &&
                              // globalFunction.textNullCheck(
                              //     context, noteController, "μ²΄νλΆμ")) {
                              memberService.create(
                                  name: nameController.text,
                                  registerDate: registerDateController.text,
                                  phoneNumber: phoneNumberController.text,
                                  registerType: registerTypeController.text,
                                  goal: goalController.text,
                                  info: infoController.text,
                                  note: noteController.text,
                                  comment: commentController.text,
                                  uid: user.uid,
                                  onSuccess: () {
                                    // μ μ₯νκΈ° μ±κ³΅
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(SnackBar(
                                      content: Text("μ μ₯νκΈ° μ±κ³΅"),
                                    ));
                                    // μ μ₯νκΈ° μ±κ³΅μ Homeλ‘ μ΄λ
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (_) => MemberList()),
                                    );

                                    globalFunction.clearTextEditController([
                                      nameController,
                                      registerDateController,
                                      phoneNumberController,
                                      registerTypeController,
                                      goalController,
                                      infoController,
                                      noteController,
                                      commentController,
                                    ]);
                                    registerDateController.text = now;
                                  },
                                  onError: () {
                                    print("μ μ₯νκΈ° ERROR");
                                  });
                            } else {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                content: Text("ν­λͺ©μ λͺ¨λ μλ ₯ν΄μ£ΌμΈμ."),
                              ));
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          //bottomNavigationBar: BaseBottomAppBar(),
        );
      },
    );
  }

  void _getMembership(BuildContext context, String lessonCount) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (_) => MembershipList(
                lessonCount: lessonCount,
              )),
    );

    if (!(result == null)) {
      registerTypeController.text = result;

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("μ ν λ μκ°κΆ : ${result}"),
      ));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("μκ°κΆμ μ νν΄μ£ΌμΈμ."),
      ));
    }
  }
}
