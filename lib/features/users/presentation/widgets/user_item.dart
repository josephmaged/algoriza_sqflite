import 'package:algoriza_task3/core/util/bloc/app/cubit.dart';
import 'package:flutter/material.dart';

class UserItem extends StatelessWidget {
  final Map item;

  const UserItem({
    Key? key,
    required this.item,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        AppBloc.get(context).selectUserToUpdate(user: item);
      },
      onHorizontalDragStart: (DragStartDetails drag) {
        AppBloc.get(context).deleteUser(user: item);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 14,
        ),
        child: Container(
          width: double.infinity,
          decoration: const BoxDecoration(
            color: Colors.white
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: 30,
                backgroundColor: Colors.blue,
                child: Text(
                  '${item['name'][0]}',
                  style: const TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.white
                  ),
                ),
              ),
              const SizedBox(
                width: 16,
              ),
              Text(
                '${item['name']}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
