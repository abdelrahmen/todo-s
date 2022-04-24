import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todos/shared/cubit/states.dart';
import '../../shared/components/components.dart';
import 'package:todos/shared/cubit/cubit.dart';
class ArchivedTaskScreen extends StatelessWidget {
  const ArchivedTaskScreen({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AppCubit cubit = AppCubit.get(context);
    return BlocConsumer<AppCubit, AppState>(
      listener: (BuildContext context, Object? state) {},
      builder: (BuildContext context, state) {
        if (cubit.archivedTasks.isEmpty) {
          return const Empty();
        }
        return ListView.separated(
          itemBuilder: (context, index) =>
              buildTaskItem(cubit.archivedTasks[index], context),
          separatorBuilder: (context, index) => Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Container(
              width: double.infinity,
              height: 1,
              color: Colors.grey.shade300,
            ),
          ),
          itemCount: cubit.archivedTasks.length,
        );
      },
    );
  }
}