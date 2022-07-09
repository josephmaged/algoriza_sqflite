import 'package:algoriza_task3/core/util/bloc/app/cubit.dart';
import 'package:algoriza_task3/core/util/bloc/app/states.dart';
import 'package:algoriza_task3/features/users/presentation/widgets/user_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UsersWidget extends StatelessWidget {
  const UsersWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppBloc, AppStetes>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              TextFormField(
                controller: AppBloc.get(context).usernameController,
                decoration: InputDecoration(
                    suffixIcon: TextButton(
                      onPressed: () {
                        AppBloc.get(context).selectedUser.isEmpty
                            ? AppBloc.get(context).insertUserData()
                            : AppBloc.get(context).updateUserData();
                      },
                      child: Text(AppBloc.get(context).selectedUser.isEmpty ? 'Save' : 'Update'),
                    ),
                    border: const OutlineInputBorder(),
                    labelText: 'Username'),
              ),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () async {
                    AppBloc.get(context).getUsersData();
                  },
                  child: ListView.separated(
                    itemBuilder: (context, index) => UserItem(
                      item: AppBloc.get(context).users[index],
                    ),
                    separatorBuilder: (context, index) => Container(
                      width: double.infinity,
                      height: 1,
                      color: Colors.black12,
                    ),
                    itemCount: AppBloc.get(context).users.length,
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
