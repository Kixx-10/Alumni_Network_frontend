import 'package:alumni_network/data/provider/auth_provider.dart'; 
import 'package:alumni_network/data/provider/response_post_notifier.dart';
import 'package:alumni_network/widgets/create_post_bar.dart';
import 'package:alumni_network/widgets/post_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeTab extends ConsumerStatefulWidget {
  const HomeTab({super.key});

  @override
  ConsumerState<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends ConsumerState<HomeTab> {
  @override
  Widget build(BuildContext context) {
    final postState = ref.watch(responsePostProvider);
    final userIdAsync = ref.watch(currentUserIdProvider);
    final String currentUserId = userIdAsync.value ?? '';
    return Scaffold(
      //backgroundColor: Colors.grey.shade200, 
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CreatePostBar(),
            const SizedBox(height: 10),
            
            Expanded(
              child: postState.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, stack) => Center(
                  child: Text("Error: ${error.toString()}", style: const TextStyle(color: Colors.red)),
                ),
                data: (posts) {
                  if (posts.isEmpty) {
                    return const Center(child: Text("No posts available"));
                  }
                  return RefreshIndicator(
                    onRefresh: () async {
                      await ref.read(responsePostProvider.notifier).refreshPosts();
                    },
                    child: ListView.builder(
                      itemCount: posts.length,
                      itemBuilder: (context, index) {
                        return PostCard(
                          post: posts[index],
                          currentUserId: currentUserId,
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}