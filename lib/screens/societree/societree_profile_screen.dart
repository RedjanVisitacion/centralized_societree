import 'package:flutter/material.dart';
import 'package:centralized_societree/services/api_service.dart';
import 'package:centralized_societree/config/api_config.dart';
import 'package:centralized_societree/services/user_session.dart';
import 'package:centralized_societree/screens/societree/societree_profile_sheet.dart';

class SocietreeProfileScreen extends StatefulWidget {
  const SocietreeProfileScreen({super.key});

  @override
  State<SocietreeProfileScreen> createState() => _SocietreeProfileScreenState();
}

class _SocietreeProfileScreenState extends State<SocietreeProfileScreen> {
  late final ApiService _api;
  bool _loading = true;
  String? _error;
  Map<String, dynamic>? _user;

  @override
  void initState() {
    super.initState();
    _api = ApiService(baseUrl: apiBaseUrl);
    _load();
  }

  Future<void> _load() async {
    final id = (UserSession.studentId ?? '').trim();
    if (id.isEmpty) {
      setState(() {
        _loading = false;
        _error = 'Not logged in';
      });
      return;
    }
    try {
      setState(() {
        _loading = true;
        _error = null;
      });
      final res = await _api.getUser(studentId: id);
      if (res['success'] == true && res['user'] != null) {
        setState(() {
          _user = Map<String, dynamic>.from(res['user'] as Map);
          _loading = false;
        });
      } else {
        setState(() {
          _loading = false;
          _error = (res['message'] ?? 'Failed to load profile').toString();
        });
      }
    } catch (_) {
      setState(() {
        _loading = false;
        _error = 'Network error';
      });
    }
  }

  String _safe(Map<String, dynamic>? m, String k) {
    final v = m?[k];
    return v == null ? '' : v.toString();
    }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: RefreshIndicator(
        onRefresh: _load,
        child: _loading
            ? ListView(children: const [
                SizedBox(height: 220),
                Center(child: CircularProgressIndicator()),
                SizedBox(height: 300),
              ])
            : _error != null
                ? ListView(
                    padding: const EdgeInsets.all(16),
                    children: [
                      const SizedBox(height: 60),
                      Icon(Icons.error_outline, size: 48, color: theme.colorScheme.error),
                      const SizedBox(height: 12),
                      Text(_error!, textAlign: TextAlign.center),
                      const SizedBox(height: 12),
                      Center(
                        child: ElevatedButton.icon(
                          onPressed: _load,
                          icon: const Icon(Icons.refresh),
                          label: const Text('Retry'),
                        ),
                      ),
                    ],
                  )
                : SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 180,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                theme.colorScheme.primary.withOpacity(0.8),
                                theme.colorScheme.secondary.withOpacity(0.8),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                          ),
                          child: Stack(
                            alignment: Alignment.bottomLeft,
                            children: [
                              Positioned(
                                left: 16,
                                right: 16,
                                bottom: 16,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    CircleAvatar(
                                      radius: 40,
                                      backgroundColor: Colors.white,
                                      child: CircleAvatar(
                                        radius: 37,
                                        backgroundColor: theme.colorScheme.primaryContainer,
                                        backgroundImage: const AssetImage('assets/images/Icon-CRCL.png'),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                        Builder(builder: (_) {
                                          final name = _safe(_user, 'full_name');
                                          final title = name.isNotEmpty ? name : (_safe(_user, 'student_id').isNotEmpty ? _safe(_user, 'student_id') : 'Student');
                                          return Text(
                                            title,
                                            style: const TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w700,
                                              color: Colors.white,
                                            ),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            softWrap: true,
                                          );
                                        }),
                                        const SizedBox(height: 4),
                                        Builder(builder: (_) {
                                          final course = _safe(_user, 'course');
                                          final year = _safe(_user, 'year');
                                          final section = _safe(_user, 'section');
                                          final ys = [year, section].where((s) => s.isNotEmpty).join(' ');
                                          final dept = _safe(_user, 'department');
                                          final parts = <String>[];
                                          if (course.isNotEmpty) parts.add(course);
                                          if (ys.isNotEmpty) parts.add(ys);
                                          if (parts.isEmpty && dept.isNotEmpty) parts.add(dept);
                                          return Text(
                                            parts.isNotEmpty ? parts.join(' • ') : '',
                                            style: const TextStyle(color: Colors.white70),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          );
                                        }),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: ElevatedButton.icon(
                                      onPressed: () async {
                                        await showSocietreeProfileSheet(
                                          context: context,
                                          api: _api,
                                          displayName: _safe(_user, 'full_name').isNotEmpty ? _safe(_user, 'full_name') : _safe(_user, 'student_id'),
                                          primaryEmail: _safe(_user, 'email'),
                                          contactNumber: _safe(_user, 'phone'),
                                          onUpdated: (name, email, phone) async {
                                            await _load();
                                          },
                                        );
                                      },
                                      icon: const Icon(Icons.edit_outlined),
                                      label: const Text('Edit Profile'),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              Text('About', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
                              const SizedBox(height: 12),
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: const Color.fromARGB(60, 89, 98, 105)),
                                ),
                                child: Column(
                                  children: [
                                    _InfoRow(icon: Icons.badge_outlined, label: 'Student ID', value: _safe(_user, 'student_id')),
                                    const Divider(height: 1),
                                    _InfoRow(icon: Icons.menu_book_outlined, label: 'Course', value: _safe(_user, 'course')),
                                    const Divider(height: 1),
                                    _InfoRow(icon: Icons.group_outlined, label: 'Section', value: () {
                                      final y = _safe(_user, 'year');
                                      final s = _safe(_user, 'section');
                                      return [y, s].where((e) => e.isNotEmpty).join(' ');
                                    }()),
                                    const Divider(height: 1),
                                    _InfoRow(icon: Icons.workspace_premium_outlined, label: 'Role', value: _safe(_user, 'role')),
                                    const Divider(height: 1),
                                    _InfoRow(icon: Icons.school_outlined, label: 'Department', value: _safe(_user, 'department')),
                                    // const Divider(height: 1),
                                    // _InfoRow(icon: Icons.work_outline, label: 'Position', value: _safe(_user, 'position')),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 16),
                              Text('Contact', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
                              const SizedBox(height: 12),
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: const Color.fromARGB(60, 89, 98, 105)),
                                ),
                                child: Column(
                                  children: [
                                    _InfoRow(icon: Icons.email_outlined, label: 'Email', value: _safe(_user, 'email')),
                                    const Divider(height: 1),
                                    _InfoRow(icon: Icons.call_outlined, label: 'Phone', value: _safe(_user, 'phone')),
                                    const Divider(height: 1),
                                    _InfoRow(icon: Icons.calendar_month_outlined, label: 'Member since', value: _safe(_user, 'created_at')),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const _InfoRow({required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme.bodyMedium;
    return ListTile(
      leading: Icon(icon),
      title: Text(label, style: textStyle?.copyWith(fontWeight: FontWeight.w600)),
      subtitle: Text(value.isEmpty ? '—' : value),
      dense: true,
    );
  }
}
