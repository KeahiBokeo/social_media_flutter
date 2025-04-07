import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:social_media_flutter/firebase_options.dart';
import 'app.dart';

void main() async {
  //firebase setup
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  //run app
  runApp(MyApp());
}
