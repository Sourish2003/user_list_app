import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../view_model/bookmarks_view_model.dart';

class BookmarksScreen extends StatefulWidget {
  const BookmarksScreen({super.key});

  @override
  State<BookmarksScreen> createState() => _BookmarksScreenState();
}

class _BookmarksScreenState extends State<BookmarksScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<BookmarksViewModel>().loadBookmarks();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bookmarked Posts'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          Consumer<BookmarksViewModel>(
            builder: (context, viewModel, child) {
              if (viewModel.bookmarks.isEmpty) return const SizedBox();
              return IconButton(
                icon: const Icon(Icons.delete_sweep),
                onPressed: () => _showClearConfirmation(context, viewModel),
              );
            },
          ),
        ],
      ),
      body: Consumer<BookmarksViewModel>(
        builder: (context, viewModel, child) {
          if (viewModel.bookmarks.isEmpty) {
            return const Center(child: Text('No bookmarked posts yet'));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: viewModel.bookmarks.length,
            itemBuilder: (context, index) {
              final post = viewModel.bookmarks[index];
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
                    icon: const Icon(Icons.delete),
                    onPressed: () => viewModel.removeBookmark(post.id),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _showClearConfirmation(
    BuildContext context,
    BookmarksViewModel viewModel,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear All Bookmarks'),
        content: const Text(
          'Are you sure you want to remove all bookmarked posts?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              viewModel.clearAllBookmarks();
              Navigator.pop(context);
            },
            child: const Text('Clear All'),
          ),
        ],
      ),
    );
  }
}
