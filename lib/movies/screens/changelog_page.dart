import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:go_router/go_router.dart';
import 'package:my_movie_search/movies/screens/widgets/app_scaffold.dart';

class ChangelogPage extends StatelessWidget {
  const ChangelogPage({super.key});

  static MaterialPage<dynamic> goRoute(_, __) => const MaterialPage(
        restorationId: 'ChangelogPage',
        child: ChangelogPage(),
      );

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: AppBar(
        title: const Text('Changelog'),
        leading: BackButton(
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go('/');
            }
          },
        ),
      ),
      body: FutureBuilder<String>(
        future: rootBundle.loadString('changelog.md'),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error loading changelog: ${snapshot.error}'));
          }
          return Markdown(
            data: snapshot.data ?? 'No changelog found.',
            selectable: true,
            padding: const EdgeInsets.all(16),
          );
        },
      ),
    );
  }
}
