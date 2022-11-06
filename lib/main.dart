import 'package:codyo/src/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: 'asset/.env');
  await Supabase.initialize(
    url: dotenv.env['URL'].toString(),
    anonKey: dotenv.env['API_KEY'].toString(),
  );

  runApp(const ProviderScope(child: App()));
}
