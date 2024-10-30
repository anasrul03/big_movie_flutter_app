import 'package:big_movie_app/blocs/api_cubit.dart';
import 'package:big_movie_app/controls/api_controls.dart';
import 'package:big_movie_app/views/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    final ApiControls apiControls = ApiControls();
    final ApiCubit apiCubit = ApiCubit(apiControls);

    return MaterialApp(
      home: BlocProvider<ApiCubit>(
        create: (_) => apiCubit,
        child: const HomePage(),
      ),
    );
  }
}
