// ignore_for_file: must_be_immutable

import 'package:animate_do/animate_do.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:hivetodoodev/view/home/widgets/fab_button.dart';
import 'package:hivetodoodev/view/home/widgets/slider_widget.dart';

import 'package:flutter_slider_drawer/flutter_slider_drawer.dart';

///
import '../../main.dart';
import '../../models/task.dart';

import '../../view/home/widgets/task_widget.dart';

import '../../utils/strings.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  GlobalKey<SliderDrawerState> dKey = GlobalKey<SliderDrawerState>();

  /// Checking Done Tasks
  int checkDoneTask(List<Task> task) {
    int i = 0;
    for (Task doneTasks in task) {
      if (doneTasks.isCompleted) {
        i++;
      }
    }
    return i;
  }

  /// Checking The Value Of the Circle Indicator
  dynamic valueOfTheIndicator(List<Task> task) {
    if (task.isNotEmpty) {
      return task.length;
    } else {
      return 3;
    }
  }

  @override
  Widget build(BuildContext context) {
    final base = BaseWidget.of(context);
    var textTheme = Theme.of(context).textTheme;

    return ValueListenableBuilder(
        valueListenable: base.dataStore.listenToTask(),
        builder: (ctx, Box<Task> box, Widget? child) {
          var tasks = box.values.toList();

          /// Sort Task List
          tasks.sort(((a, b) => a.createdAtDate.compareTo(b.createdAtDate)));

          return Scaffold(
            backgroundColor: Color.fromARGB(255, 229, 189, 245),

            /// Floating Action Button
            floatingActionButton: const FAB(),

            /// Body
            body: SliderDrawer(
              isDraggable: false,
              key: dKey,
              animationDuration: 1000,
              // appBar: AppBar(),

              // My AppBar
              // appBar: MyAppBar(
              //   drawerKey: dKey,
              // ),

              /// My Drawer Slider
              slider: MySlider(),

              /// Main Body
              child: _buildBody(
                tasks,
                base,
                textTheme,
              ),
            ),
          );
        });
  }

  /// Main Body
  SizedBox _buildBody(
    List<Task> tasks,
    BaseWidget base,
    TextTheme textTheme,
  ) {
    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: Column(
        children: [
          /// Top Section Of Home page : Text, Progrss Indicator
          Container(
            margin: const EdgeInsets.fromLTRB(55, 0, 0, 0),
            width: double.infinity,
            height: 100,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    /// CircularProgressIndicator
                    Center(
                      child: SizedBox(
                        width: 30,
                        height: 30,
                        child: CircularProgressIndicator(
                          valueColor: const AlwaysStoppedAnimation(
                              Color.fromARGB(255, 77, 21, 245)),
                          backgroundColor: Colors.grey,
                          value:
                              checkDoneTask(tasks) / valueOfTheIndicator(tasks),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 25,
                    ),

                    /// Texts
                    Text(MyString.mainTitle, style: textTheme.headline1)
                  ],
                ),
                const SizedBox(
                  width: 50,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 60),
                      child: Text(
                          "${checkDoneTask(tasks)} 'i ${tasks.length} görevden",
                          style: textTheme.subtitle1),
                    ),
                  ],
                ),
              ],
            ),
          ),

          /// Divider
          const Padding(
            padding: EdgeInsets.only(top: 10),
            child: Divider(
              thickness: 2,
              indent: 100,
            ),
          ),

          /// Bottom ListView : Tasks
          SizedBox(
            width: double.infinity,
            height: 585,
            child: tasks.isNotEmpty
                ? ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    itemCount: tasks.length,
                    itemBuilder: (BuildContext context, int index) {
                      var task = tasks[index];

                      return Dismissible(
                        direction: DismissDirection.horizontal,
                        background: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.delete_outline,
                              color: Colors.grey,
                            ),
                            SizedBox(
                              width: 8,
                            ),
                            Text(MyString.deletedTask,
                                style: TextStyle(
                                  color: Colors.grey,
                                ))
                          ],
                        ),
                        onDismissed: (direction) {
                          base.dataStore.dalateTask(task: task);
                        },
                        key: Key(task.id),
                        child: TaskWidget(
                          task: tasks[index],
                        ),
                      );
                    },
                  )

                /// if All Tasks Done Show this Widgets
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.network(
                          'https://logos.flamingtext.com/Word-Logos/todo-design-sketch-name.png'),
                      // /// Lottie
                      // FadeIn(
                      //   child: SizedBox(
                      //     width: 200,
                      //     height: 200,
                      //     child: Lottie.asset(
                      //       lottieURL,
                      //       animate: tasks.isNotEmpty ? false : true,
                      //     ),
                      //   ),
                      // ),

                      /// Bottom Texts
                      FadeInUp(
                        from: 30,
                        child: const Text(MyString.doneAllTask),
                      ),
                    ],
                  ),
          )
        ],
      ),
    );
  }
}
