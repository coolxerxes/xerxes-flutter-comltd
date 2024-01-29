import 'package:flutter/material.dart';
import '../../models/users.dart';

class NavigationService {
  final GlobalKey<NavigatorState> navigatoryKey = GlobalKey<NavigatorState>();

  showContextLessDialog(Datum data) {
    return Dialog(
      elevation: 20,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("ContextLess User Dialog"),
            const SizedBox(
              height: 16,
            ),
            Text(data.email!),
            const SizedBox(
              height: 5,
            ),
            Text(data.firstName!),
            const SizedBox(
              height: 5,
            ),
            Text(data.lastName!),
            const SizedBox(
              height: 5,
            ),
            ElevatedButton(
              child: const Text("Close"),
              onPressed: () {
                Navigator.of(navigatoryKey.currentContext!).pop();
              },
            )
          ],
        ),
      ),
    );
  }

  Future<void>? openDialog(Datum data) {
    showDialog(
        context: navigatoryKey.currentContext!,
        builder: (_) => showContextLessDialog(data));
    return null;
  }
}
