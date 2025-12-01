import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:centralized_societree/config/api_config.dart';
import 'package:centralized_societree/services/user_session.dart';

class VoteWindowScreen extends StatefulWidget {
  const VoteWindowScreen({super.key});

  @override
  State<VoteWindowScreen> createState() => _VoteWindowScreenState();
}

class _VoteWindowScreenState extends State<VoteWindowScreen> {
  final _formKey = GlobalKey<FormState>();
  DateTime? _start;
  DateTime? _end;
  DateTime? _results;
  final TextEditingController _noteCtrl = TextEditingController();
  final TextEditingController _passwordCtrl = TextEditingController();
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() { _loading = true; _error = null; });
    try {
      final uri = Uri.parse('$apiBaseUrl/get_vote_window.php');
      final res = await http.get(uri).timeout(const Duration(seconds: 12));
      final decoded = jsonDecode(res.body);
      if (decoded is Map && decoded['success'] == true) {
        final w = decoded['window'];
        if (w != null && w is Map) {
          _start = _parseDt(w['start_at']);
          _end = _parseDt(w['end_at']);
          _results = _parseDt(w['results_at']);
          _noteCtrl.text = (w['note'] ?? '').toString();
        }
      } else {
        _error = (decoded['message'] ?? 'Failed to load').toString();
      }
    } catch (_) {
      _error = 'Network error';
    } finally {
      if (mounted) setState(() { _loading = false; });
    }
  }

  DateTime? _parseDt(dynamic v) {
    if (v == null) return null;
    try { return DateTime.parse(v.toString()); } catch (_) { return null; }
  }

  Future<void> _pickDateTime({required bool isStart}) async {
    final initial = isStart ? (_start ?? DateTime.now()) : (_end ?? DateTime.now());
    final date = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (date == null) return;
    final timeOfDay = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(initial),
    );
    if (timeOfDay == null) return;
    final dt = DateTime(date.year, date.month, date.day, timeOfDay.hour, timeOfDay.minute);
    setState(() {
      if (isStart) { _start = dt; } else { _end = dt; }
    });
  }

  Future<void> _pickResults() async {
    final initial = _results ?? (_end ?? DateTime.now());
    final date = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (date == null) return;
    final timeOfDay = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(initial),
    );
    if (timeOfDay == null) return;
    final dt = DateTime(date.year, date.month, date.day, timeOfDay.hour, timeOfDay.minute);
    setState(() { _results = dt; });
  }

  String _fmt(DateTime? dt) {
    if (dt == null) return '';
    return DateFormat('MM/dd/yyyy hh:mm a').format(dt);
    
  }

  Future<void> _save() async {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }
    if (UserSession.studentId == null || (UserSession.role ?? '').toLowerCase() != 'admin') {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Admin session required')));
      return;
    }
    if (_passwordCtrl.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Enter admin password to confirm')));
      return;
    }
    setState(() { _loading = true; _error = null; });
    try {
      final body = {
        'student_id': UserSession.studentId,
        'password': _passwordCtrl.text,
        'start_at': _start != null ? DateFormat('yyyy-MM-dd HH:mm:ss').format(_start!) : '',
        'end_at': _end != null ? DateFormat('yyyy-MM-dd HH:mm:ss').format(_end!) : '',
        'results_at': _results != null ? DateFormat('yyyy-MM-dd HH:mm:ss').format(_results!) : '',
        'note': _noteCtrl.text,
      };
      final uri = Uri.parse('$apiBaseUrl/set_vote_window.php');
      final res = await http.post(uri, headers: {'Content-Type':'application/json'}, body: jsonEncode(body)).timeout(const Duration(seconds: 15));
      final decoded = jsonDecode(res.body);
      if (decoded is Map && decoded['success'] == true) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Saved')));
          Navigator.of(context).pop(true);
        }
      } else {
        final msg = (decoded['message'] ?? 'Failed to save').toString();
        setState(() { _error = msg; });
      }
    } catch (_) {
      setState(() { _error = 'Network error'; });
    } finally {
      if (mounted) setState(() { _loading = false; });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final chipTextStyle = theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onPrimary);
    return Scaffold(
      appBar: AppBar(title: const Text('Set Election Dates')),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
          child: SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: _loading ? null : _save,
              child: const Text('Save Dates'),
            ),
          ),
        ),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : SafeArea(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return SingleChildScrollView(
                    padding: EdgeInsets.only(
                      left: 16, right: 16, top: 16,
                      bottom: MediaQuery.of(context).viewInsets.bottom + 24,
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (_error != null)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: Text(_error!, style: const TextStyle(color: Colors.red)),
                            ),
                          Card(
                            elevation: 1,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      const Icon(Icons.how_to_vote, size: 18),
                                      const SizedBox(width: 8),
                                      Text('Election Window', style: theme.textTheme.titleMedium),
                                      const Spacer(),
                                      if (_start != null && _end != null)
                                        Flexible(
                                          child: Container(
                                            constraints: BoxConstraints(
                                              // Limit to roughly half width to avoid overflow on small screens
                                              maxWidth: MediaQuery.of(context).size.width * 0.55,
                                            ),
                                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                            decoration: BoxDecoration(
                                              color: theme.colorScheme.primary,
                                              borderRadius: BorderRadius.circular(30),
                                            ),
                                            child: Text(
                                              'From ${_fmt(_start)} to ${_fmt(_end)}',
                                              style: chipTextStyle,
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                  const SizedBox(height: 16),
                                  _DateField(
                                    label: 'Start Date & Time',
                                    value: _fmt(_start),
                                    onTap: () => _pickDateTime(isStart: true),
                                    validator: (_) {
                                      if (_start == null) return 'Select start date/time';
                                      return null;
                                    },
                                  ),
                                  const SizedBox(height: 12),
                                  _DateField(
                                    label: 'End Date & Time',
                                    value: _fmt(_end),
                                    onTap: () => _pickDateTime(isStart: false),
                                    validator: (_) {
                                      if (_end == null) return 'Select end date/time';
                                      if (_start != null && _end!.isBefore(_start!)) {
                                        return 'End must be after start';
                                      }
                                      return null;
                                    },
                                  ),
                                  const SizedBox(height: 12),
                                  _DateField(
                                    label: 'Results Date & Time',
                                    value: _fmt(_results),
                                    onTap: _pickResults,
                                    validator: (_) {
                                      if (_results != null && _end != null && _results!.isBefore(_end!)) {
                                        return 'Results must be after the end';
                                      }
                                      return null;
                                    },
                                  ),
                                  const SizedBox(height: 16),
                                  TextFormField(
                                    controller: _noteCtrl,
                                    decoration: const InputDecoration(
                                      labelText: 'Note (optional)',
                                      border: UnderlineInputBorder(),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Card(
                            elevation: 1,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      const Icon(Icons.lock_outline, size: 18),
                                      const SizedBox(width: 8),
                                      Text('Confirmation', style: theme.textTheme.titleMedium),
                                    ],
                                  ),
                                  const SizedBox(height: 12),
                                  TextFormField(
                                    controller: _passwordCtrl,
                                    obscureText: true,
                                    decoration: const InputDecoration(
                                      labelText: 'Admin Password',
                                      hintText: 'Required to save',
                                    ),
                                    validator: (v) => (v == null || v.isEmpty) ? 'Enter admin password' : null,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
    );
  }
}

class _DateField extends StatelessWidget {
  final String label;
  final String value;
  final VoidCallback onTap;
  final String? Function(String?)? validator;
  const _DateField({required this.label, required this.value, required this.onTap, this.validator});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AbsorbPointer(
        child: TextFormField(
          readOnly: true,
          validator: validator,
          decoration: InputDecoration(
            labelText: label,
            suffixIcon: const Icon(Icons.calendar_month),
          ),
          controller: TextEditingController(text: value),
        ),
      ),
    );
  }
}
