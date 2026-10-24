import 'package:flutter/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

import 'app.dart';
import 'features/auth/data/firebase_auth_service.dart';
import 'features/practice/data/practice_store.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  final auth = FirebaseAuthService(FirebaseAuth.instance);
  runApp(
    BrassCoachApp(
      authService: auth,
      practiceStore: FirestorePracticeStore(FirebaseFirestore.instance, auth),
    ),
  );
}
