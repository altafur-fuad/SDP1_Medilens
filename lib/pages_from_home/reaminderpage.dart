import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ReminderPage extends StatefulWidget {
  const ReminderPage({super.key});

  @override
  State<ReminderPage> createState() => _ReminderPageState();
}

class _ReminderPageState extends State<ReminderPage> {
  final TextEditingController _titleController = TextEditingController();
  DateTime? _selectedDateTime;

  final List<Map<String, dynamic>> _reminders = [];

  Future<void> _pickDateTime() async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (date != null) {
      final time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (time != null) {
        setState(() {
          _selectedDateTime = DateTime(
            date.year,
            date.month,
            date.day,
            time.hour,
            time.minute,
          );
        });
      }
    }
  }

  void _addReminder() {
    if (_titleController.text.isEmpty || _selectedDateTime == null) return;

    setState(() {
      _reminders.add({
        'title': _titleController.text,
        'time': _selectedDateTime!,
      });
      _titleController.clear();
      _selectedDateTime = null;
    });
  }

  void _deleteReminder(int index) {
    setState(() {
      _reminders.removeAt(index);
    });
  }

  String _formatDateTime(DateTime dateTime) {
    return DateFormat('EEE, MMM d • hh:mm a').format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 108, 158, 179),
      appBar: AppBar(
        title: const Text('Medicine Reminder'),
        backgroundColor: const Color.fromARGB(255, 90, 140, 172),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Medicine Name'),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: _pickDateTime,
              child: const Text('Pick Date & Time'),
            ),
            if (_selectedDateTime != null)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Text(
                  'Selected: ${_formatDateTime(_selectedDateTime!)}',
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
              ),
            ElevatedButton(
              onPressed: _addReminder,
              child: const Text('Add Reminder'),
            ),
            const SizedBox(height: 20),
            const Divider(),
            const Text(
              'Upcoming Reminders',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Expanded(
              child:
                  _reminders.isEmpty
                      ? const Center(child: Text('No reminders yet'))
                      : ListView.builder(
                        itemCount: _reminders.length,
                        itemBuilder: (context, index) {
                          final reminder = _reminders[index];
                          return Card(
                            child: ListTile(
                              title: Text(reminder['title']),
                              subtitle: Text(_formatDateTime(reminder['time'])),
                              trailing: IconButton(
                                icon: const Icon(
                                  Icons.delete,
                                  color: Color.fromARGB(255, 21, 72, 114),
                                ),
                                onPressed: () => _deleteReminder(index),
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
