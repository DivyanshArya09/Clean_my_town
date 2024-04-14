import 'package:app/features/home/presentation/blocs/open_request_bloc/open_req_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sl = GetIt.instance;

Future<void> init() async {
  general();
  blocs();
}

Future<void> general() async {
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerFactory<SharedPreferences>(() => sharedPreferences);
}

void blocs() {
  sl.registerSingleton<OpenReqBloc>(OpenReqBloc());
}
