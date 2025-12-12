import 'package:flutter/material.dart';
import 'package:centralized_societree/services/user_session.dart';
import 'package:centralized_societree/services/api_service.dart';

Future<void> showSocietreeProfileSheet({
  required BuildContext context,
  required ApiService api,
  required String displayName,
  required String primaryEmail,
  required String contactNumber,
  required void Function(String name, String email, String phone) onUpdated,
}) async {
  final studentId = (UserSession.studentId ?? '').trim();
  final nameCtrl = TextEditingController(text: displayName);
  final emailCtrl = TextEditingController(text: primaryEmail);
  final contactCtrl = TextEditingController(text: contactNumber);

  await showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    builder: (ctx) {
      return Padding(
        padding: EdgeInsets.only(
          left: 16,
          right: 16,
          top: 20,
          bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 38,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade400,
                  borderRadius: BorderRadius.circular(40),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Update Profile',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: TextEditingController(text: studentId),
              enabled: false,
              decoration: const InputDecoration(
                labelText: 'Student ID',
                prefixIcon: Icon(Icons.badge_outlined),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: nameCtrl,
              decoration: const InputDecoration(
                labelText: 'Full name',
                prefixIcon: Icon(Icons.badge_outlined),
              ),
              textCapitalization: TextCapitalization.words,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: emailCtrl,
              decoration: const InputDecoration(
                labelText: 'Email address',
                prefixIcon: Icon(Icons.email_outlined),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: contactCtrl,
              decoration: const InputDecoration(
                labelText: 'Contact number',
                prefixIcon: Icon(Icons.call_outlined),
              ),
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.save_outlined),
                label: const Text('Save Changes'),
                onPressed: () async {
                  final email = emailCtrl.text.trim();
                  final phone = contactCtrl.text.trim();
                  if (email.isNotEmpty && !RegExp(r'^.+@.+\..+$').hasMatch(email)) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Enter a valid email')));
                    return;
                  }
                  if (phone.isNotEmpty && phone.replaceAll(RegExp(r'\D+'), '').length < 10) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Enter a valid phone number')));
                    return;
                  }
                  try {
                    final res = await api.updateUserContact(
                      studentId: studentId,
                      email: email.isNotEmpty ? email : null,
                      phone: phone.isNotEmpty ? phone : null,
                    );
                    if (res['success'] == true) {
                      onUpdated(nameCtrl.text.trim(), email, phone);
                      Navigator.of(ctx).pop();
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Contact updated successfully')));
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text((res['message'] ?? 'Update failed').toString())));
                    }
                  } catch (_) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Network error while updating contact')));
                  }
                },
              ),
            ),
          ],
        ),
      );
    },
  );
}
