import 'package:flutter/material.dart';
import 'package:todos/shared/cubit/cubit.dart';

Widget buildTaskItem(Map model, context) => Dismissible(
      key: Key('${model['id']}'),
      onDismissed: (direction) {
        AppCubit.get(context).deleteData(id: model['id']);
      },
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 40,
              child: Text('${model['time']}'),
            ),
            const SizedBox(
              width: 10,
            ),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //title of task

                  Text(
                    '${model['title']}',
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),

                  //date of task

                  Text(
                    '${model['date']}',
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),

                  const SizedBox(
                    width: 10,
                  ),
                ],
              ),
            ),
            IconButton(
              onPressed: () {
                AppCubit.get(context)
                    .updateData(status: 'archive', id: model['id']);
              },
              icon: const Icon(
                Icons.archive,
                color: Colors.grey,
              ),
            ),
            IconButton(
              onPressed: () {
                AppCubit.get(context)
                    .updateData(status: 'done', id: model['id']);
              },
              icon: const Icon(
                Icons.check_box_outlined,
                color: Colors.green,
              ),
            ),
          ],
        ),
      ),
    );

class Empty extends StatelessWidget {
  const Empty({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.menu, size: 60, color: Colors.grey,),
            Text(
              'Empty',
              style: TextStyle(
                  fontSize: 30, color: Colors.grey, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      );
  }
}