import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:todos/shared/cubit/cubit.dart';
import 'package:todos/shared/cubit/states.dart';

class HomeScreen extends StatelessWidget {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final timeController = TextEditingController();
  final dateController = TextEditingController();

  HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //1st wrap the scaffold with BlocProvider
    return BlocProvider(
      //2nd give the create the appcubit class you made
      create: (context) => AppCubit()..creatDatabase(),
      //3rd wrap the scaffold with a BlocConsumer
      child: BlocConsumer<AppCubit, AppState>(
        listener: (BuildContext context, state) {
          if (state is InsertDatabaseState) {
            Navigator.pop(context);
          }
        },
        //4th return the scaffold in the builder
        builder: (BuildContext context, Object? state) {
          AppCubit cubit = AppCubit.get(context);
          return Scaffold(
            key: scaffoldKey,
            appBar: AppBar(
              title: Text(cubit.titleString[cubit.currentIndex]),
            ),
            body: state is! GetDatabaseLoadingState
                ? cubit.screens[cubit.currentIndex]
                : const Center(child: CircularProgressIndicator()),
            bottomNavigationBar: BottomNavigationBar(
              onTap: (value) {
                cubit.changeIndex(value);
              },
              currentIndex: cubit.currentIndex,
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.menu),
                  label: 'Tasks',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.check),
                  label: 'Done',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.archive_outlined),
                  label: 'Archive',
                ),
              ],
              type: BottomNavigationBarType.fixed,
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                if (cubit.isBottomSheetShown) {
                  if (formKey.currentState!.validate()) {
                    cubit.insertToDatabase(
                        title: titleController.text,
                        date: dateController.text,
                        time: timeController.text);
                  }
                  //show the bottom sheet
                } else {
                  scaffoldKey.currentState!
                      .showBottomSheet(
                        (context) => Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Form(
                            key: formKey,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                //title form field
                                TextFormField(
                                  controller: titleController,
                                  decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                      label: const Text('task title'),
                                      prefixIcon: const Icon(Icons.title)),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'title cannot be empty';
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                                //time form field
                                TextFormField(
                                  controller: timeController,
                                  decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                      label: const Text('Task time'),
                                      prefixIcon:
                                          const Icon(Icons.watch_later)),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'time cannot be empty';
                                    }
                                    return null;
                                  },
                                  onTap: () {
                                    showTimePicker(
                                            context: context,
                                            initialTime: TimeOfDay.now())
                                        .then((value) {
                                      timeController.text =
                                          value!.format(context);
                                    });
                                  },
                                  keyboardType: TextInputType.datetime,
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                                //date form field
                                TextFormField(
                                  controller: dateController,
                                  decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                      label: const Text('task date'),
                                      prefixIcon:
                                          const Icon(Icons.calendar_today)),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'date cannot be empty';
                                    }
                                    return null;
                                  },
                                  onTap: () {
                                    showDatePicker(
                                      context: context,
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime.now(),
                                      lastDate: DateTime.parse('2022-05-17'),
                                    ).then((value) {
                                      dateController.text =
                                          DateFormat.yMMMd().format(value!);
                                    });
                                  },
                                  keyboardType: TextInputType.datetime,
                                ),
                              ],
                            ),
                          ),
                        ),
                        elevation: 15,
                      )
                      .closed
                      .then((value) {
                    cubit.changeBottomSheet(
                      showsheet: false,
                      icon: Icons.edit,
                    );
                  });
                  cubit.changeBottomSheet(showsheet: true, icon: Icons.add);
                }
              },
              child: Icon(cubit.floatingbuttonIcon),
            ),
          );
        },
      ),
    );
  }

  Future<String> getName() async {
    return 'abdelrahman anwar';
  }
}
