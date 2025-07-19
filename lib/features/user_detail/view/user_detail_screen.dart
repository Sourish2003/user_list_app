import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../widgets/error_widget.dart';
import '../../../widgets/loading_widget.dart';
import '../../user_list/model/user_model.dart';
import '../view_model/user_detail_view_model.dart';

class UserDetailScreen extends StatefulWidget {
  final User user;

  const UserDetailScreen({super.key, required this.user});

  @override
  State<UserDetailScreen> createState() => _UserDetailScreenState();
}

class _UserDetailScreenState extends State<UserDetailScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final viewModel = context.read<UserDetailViewModel>();
      viewModel.setUser(widget.user);
      viewModel.loadUserPosts(widget.user.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.user.name),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Consumer<UserDetailViewModel>(
        builder: (context, viewModel, child) {
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildUserInfo(),
                const Divider(),
                _buildPostsSection(viewModel),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildUserInfo() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'User Information',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 16),
              _buildInfoRow('Username', widget.user.username),
              _buildInfoRow('Email', widget.user.email),
              _buildInfoRow('Phone', widget.user.phone),
              _buildInfoRow('Website', widget.user.website),
              _buildInfoRow('Address', widget.user.address.fullAddress),
              _buildInfoRow('Company', widget.user.company.name),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  Widget _buildPostsSection(UserDetailViewModel viewModel) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Posts', style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 16),
          switch (viewModel.state) {
            UserDetailState.initial ||
            UserDetailState.loading => const LoadingWidget(),
            UserDetailState.error => CustomErrorWidget(
              message: viewModel.errorMessage ?? 'Failed to load posts',
              onRetry: () => viewModel.loadUserPosts(widget.user.id),
            ),
            UserDetailState.loaded => _buildPostsList(viewModel),
          },
        ],
      ),
    );
  }

  Widget _buildPostsList(UserDetailViewModel viewModel) {
    if (viewModel.posts.isEmpty) {
      return const Center(child: Text('No posts available'));
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: viewModel.posts.length,
      itemBuilder: (context, index) {
        final post = viewModel.posts[index];
        final isBookmarked = viewModel.isPostBookmarked(post.id);

        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            title: Text(
              post.title,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                post.body,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            trailing: IconButton(
              icon: Icon(
                isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                color: isBookmarked ? Colors.blue : null,
              ),
              onPressed: () => viewModel.toggleBookmark(post),
            ),
          ),
        );
      },
    );
  }
}
