import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../widgets/error_widget.dart';
import '../../../widgets/loading_widget.dart';
import '../../bookmarks/views/bookmarks_screen.dart';
import '../../user_detail/view/user_detail_screen.dart';
import '../view_model/user_list_view_model.dart';

class UsersListScreen extends StatefulWidget {
  const UsersListScreen({super.key});

  @override
  State<UsersListScreen> createState() => _UsersListScreenState();
}

class _UsersListScreenState extends State<UsersListScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<UsersViewModel>().loadUsers();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Users'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.bookmark),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const BookmarksScreen()),
              );
            },
          ),
        ],
      ),
      body: Consumer<UsersViewModel>(
        builder: (context, viewModel, child) {
          switch (viewModel.state) {
            case UsersState.initial:
            case UsersState.loading:
              return const LoadingWidget();
            case UsersState.error:
              return CustomErrorWidget(
                message: viewModel.errorMessage ?? 'An error occurred',
                onRetry: () => viewModel.loadUsers(),
              );
            case UsersState.loaded:
              return ListView.builder(
                itemCount: viewModel.users.length,
                itemBuilder: (context, index) {
                  final user = viewModel.users[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: ListTile(
                      leading: CircleAvatar(child: Text(user.name[0])),
                      title: Text(user.name),
                      subtitle: Text(user.email),
                      trailing: const Icon(Icons.arrow_forward_ios),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => UserDetailScreen(user: user),
                          ),
                        );
                      },
                    ),
                  );
                },
              );
          }
        },
      ),
    );
  }
}
