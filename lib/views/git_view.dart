import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:git/git.dart';
import '../models/providers.dart';

class GitView extends ConsumerStatefulWidget {
  const GitView({super.key});

  @override
  ConsumerState<GitView> createState() => _GitViewState();
}

class _GitViewState extends ConsumerState<GitView> {
  GitDir? gitDir;
  bool isGitDirInitialized = false;

  @override
  void initState() {
    super.initState();
    initializeGitDir(ref);
  }

  Future<void> initializeGitDir(WidgetRef ref) async {
    String? filePath = ref.read(currentFilePathProvider);
    if (filePath != null) {
      Directory dir = Directory(filePath).parent;
      if (await GitDir.isGitDir(dir.path)) {
        gitDir = await GitDir.fromExisting(dir.path);
      } else {
        gitDir = await GitDir.init(dir.path);
      }
      if (mounted) {
        setState(() {
          isGitDirInitialized = true;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (gitDir != null && isGitDirInitialized) {
      return Row(
        children: [
          Expanded(
            flex: 1,
            child: _TagDropdown(gitDir: gitDir!),
          ),
          const VerticalDivider(width: 1),
          Expanded(
            flex: 3,
            child: _CommitHistoryView(gitDir: gitDir!),
          ),
        ],
      );
    } else {
      return const CircularProgressIndicator();
    }
  }
}

class _TagDropdown extends StatefulWidget {
  final GitDir gitDir;

  const _TagDropdown({super.key, required this.gitDir});

  @override
  _TagDropdownState createState() => _TagDropdownState();
}

class _TagDropdownState extends State<_TagDropdown> {
  String? selectedTag;
  List<String> tags = [];
  Map<String, String>? fetchedCommitDetails; // Variable for commit details
  String? additionalTagDescription; // Variable for additional tag description

  @override
  void initState() {
    super.initState();
    fetchTags();
  }

  Future<void> fetchTags() async {
    var result = await widget.gitDir.runCommand(['tag']);
    var tagList = result.stdout.toString().split('\n');
    if (mounted) {
      setState(() {
        tags = tagList;
      });
    }
  }

  Future<String?> getAdditionalTagDescription(String tag) async {
    try {
      // Fetch the annotation of the tag
      var result = await widget.gitDir.runCommand(['tag', '-l', tag, '-n']);
      String annotation = result.stdout.toString().trim();
      return annotation;
    } catch (e) {
      print('Error fetching tag annotation: $e');
      return null;
    }
  }

  Future<Map<String, String>> getCommitDetailsForTag(String tag) async {
    try {
      // Get the commit SHA for the tag
      var result =
          await widget.gitDir.runCommand(['show-ref', '--tags', '-d', tag]);
      var parts = result.stdout.toString().split(' ');
      String commitSha = parts[0];

      // Get commit details, enclosing the format string in quotes
      var commitDetailsResult = await widget.gitDir
          .runCommand(['show', '-s', "--format='%H|%an|%aD|%s'", commitSha]);
      var details = commitDetailsResult.stdout.toString();

      // Split the details into parts
      // Remove the first and last character (which will be single quotes) if present
      if (details.startsWith("'") && details.endsWith("'")) {
        details = details.substring(1, details.length - 1);
      }
      var detailsParts = details.split('|');

      return {
        'sha': detailsParts[0],
        'author': detailsParts[1],
        'date': detailsParts[2],
        'message': detailsParts[3]
      };
    } catch (e) {
      print('Error getting commit details for tag: $e');
      return {};
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        DropdownButton<String>(
          value: selectedTag,
          onChanged: (String? newValue) async {
            if (newValue != null) {
              var commitDetails = await getCommitDetailsForTag(newValue);
              String? description = await getAdditionalTagDescription(
                  newValue); // Implement this method

              setState(() {
                selectedTag = newValue;
                fetchedCommitDetails = commitDetails;
                additionalTagDescription = description;
              });
            }
          },
          items: tags.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        ),
        if (selectedTag != null && fetchedCommitDetails != null)
          TagDetailsPanel(
            tagName: selectedTag!,
            commitDetails:
                fetchedCommitDetails!, // Use ! to assert non-nullability
            additionalDescription: additionalTagDescription,
          ),
      ],
    );
  }
}

class _CommitHistoryView extends StatelessWidget {
  final GitDir gitDir;

  const _CommitHistoryView({super.key, required this.gitDir});

  @override
  Widget build(BuildContext context) {
    // Fetch and display commit history
    // For now, this is a placeholder for actual implementation
    return ListView.builder(
      itemCount: 10, // Replace with actual count of commits
      itemBuilder: (BuildContext context, int index) {
        return ListTile(
          title: Text('Commit $index'), // Replace with actual commit data
          onTap: () {
            // Handle commit selection for diffing
          },
        );
      },
    );
  }
}

class TagDetailsPanel extends StatelessWidget {
  final String tagName;
  final Map<String, String> commitDetails;
  final String?
      additionalDescription; // Additional descriptive text for the tag

  const TagDetailsPanel({
    super.key,
    required this.tagName,
    required this.commitDetails,
    this.additionalDescription,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              tagName,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const Divider(),
            Text('Commit SHA: ${commitDetails['sha']}'),
            Text('Author: ${commitDetails['author']}'),
            Text('Date: ${commitDetails['date']}'),
            Text('Message: ${commitDetails['message']}'),
          ],
        ),
      ),
    );
  }
}
