import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WhatWentWellActivity extends StatefulWidget {
  final ColorScheme colorScheme;

  const WhatWentWellActivity({super.key, required this.colorScheme});

  @override
  State<WhatWentWellActivity> createState() => _WhatWentWellActivityState();
}

class _WhatWentWellActivityState extends State<WhatWentWellActivity> {
  // final Map<String, Map<String, dynamic>> _moodInterventions = {
  //   'neutral': {
  //     'activities': [
  //       {
  //         'name': 'What Went Well',
  //         'icon': Icons.thumb_up,
  //         'description': 'Reflect on recent positives to reinforce gratitude',
  //         'steps': [
  //           "List 3 things that went well recently",
  //           "For each, note why it happened",
  //           "Optionally add how it made you feel"
  //         ],
  //       },
  //     ],
  //   },
  // };
  late List<Map<String, String>> _entries = [];
  final _controller = TextEditingController();
  final _prefsKey = "what_went_well_entries";

  @override
  void initState() {
    super.initState();
    _loadEntries();
  }

  Future<void> _loadEntries() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getStringList(_prefsKey);
    if (saved != null) {
      setState(() {
        _entries = saved.map((e) => Map<String, String>.from(json.decode(e))).toList();
      });
    }
  }

  Future<void> _saveEntries() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
      _prefsKey,
      _entries.map((e) => json.encode(e)).toList(),
    );
  }

  void _addEntry() {
    if (_controller.text.isNotEmpty) {
      setState(() {
        _entries.add({
          'text': _controller.text,
          'date': DateFormat('MMM dd').format(DateTime.now()),
        });
        _controller.clear();
      });
      _saveEntries();
    }
    FocusScope.of(context).unfocus();
  }

  void _deleteEntry(int index) {
    setState(() {
      _entries.removeAt(index);
    });
    _saveEntries();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("What Went Well"),
        backgroundColor: widget.colorScheme.primaryContainer,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Instructions
            Card(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "💡 Reflect on recent positives:",
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Text(
                          'List 3 things that went well recently\nFor each, note why it happened\nOptionally add how it made you feel'),
                    )
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Input Field
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: "What went well?",
                suffixIcon: IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: _addEntry,
                ),
                border: const OutlineInputBorder(),
              ),
              onSubmitted: (_) => _addEntry(),
            ),
            const SizedBox(height: 20),

            // Entries List
            Expanded(
              child: ListView.builder(
                itemCount: _entries.length,
                itemBuilder: (context, index) {
                  final entry = _entries[index];
                  return Dismissible(
                    key: Key(entry['text']!),
                    background: Container(color: Colors.red.shade100),
                    onDismissed: (_) => _deleteEntry(index),
                    child: Card(
                      margin: const EdgeInsets.only(bottom: 8),
                      child: ListTile(
                        leading: const Icon(Icons.emoji_emotions_outlined),
                        title: Text(entry['text']!),
                        subtitle: Text(entry['date']!),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () => _deleteEntry(index),
                        ),
                      ),
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