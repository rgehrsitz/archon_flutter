import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GitView extends ConsumerStatefulWidget {
  const GitView({super.key});

  @override
  ConsumerState<GitView> createState() => GitViewState();
}

class GitViewState extends ConsumerState<GitView> {
  // The selected commit for details and diff
  // This is just a placeholder, you'll need to replace it with your actual commit data type
  Map<String, dynamic>? selectedCommit;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Commit History Panel
        Expanded(
          flex: 2,
          child: CommitHistoryPanel(
            onSelectCommit: (commitData) {
              setState(() {
                selectedCommit = commitData;
              });
            },
          ),
        ),
        const VerticalDivider(width: 1),
        // Commit Detail View and Diff Viewer
        Expanded(
          flex: 3,
          child: selectedCommit == null
              ? const Center(child: Text('Select a commit to view details'))
              : CommitDetailView(commitData: selectedCommit!),
        ),
      ],
    );
  }
}

// Placeholder Widget for Commit History Panel
class CommitHistoryPanel extends StatelessWidget {
  final Function(Map<String, dynamic>) onSelectCommit;

  const CommitHistoryPanel({super.key, required this.onSelectCommit});

  @override
  Widget build(BuildContext context) {
    // This would be your commit history data
    final List<Map<String, dynamic>> commitHistory = [
      {
        'message': 'Initial commit',
        'author': 'User A',
        'date': '2024-01-18', /* Other commit data */
      },
      // More commits...
    ];

    return ListView.builder(
      itemCount: commitHistory.length,
      itemBuilder: (context, index) {
        var commit = commitHistory[index];
        return ListTile(
          title: Text(commit['message']),
          subtitle: Text('by ${commit['author']} on ${commit['date']}'),
          onTap: () => onSelectCommit(commit),
        );
      },
    );
  }
}

// Placeholder Widget for Commit Detail View
class CommitDetailView extends StatelessWidget {
  final Map<String, dynamic> commitData;

  const CommitDetailView({super.key, required this.commitData});

  @override
  Widget build(BuildContext context) {
    // You'd replace this with the actual details of the selected commit
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            'Commit Details',
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text('Message: ${commitData['message']}'),
        ),
        // ... Add more detail widgets like author, date, file changes, etc.
        Expanded(
          child: DiffViewer(commitData: commitData), // Your diff viewer widget
        ),
      ],
    );
  }
}

// Placeholder Widget for Diff Viewer
class DiffViewer extends StatelessWidget {
  final Map<String, dynamic> commitData;

  const DiffViewer({super.key, required this.commitData});

  @override
  Widget build(BuildContext context) {
    // Placeholder for diff viewer, you'll need to implement actual diffing logic
    return const Center(
      child: Text('Diff Viewer - Show changes here'),
    );
  }
}
