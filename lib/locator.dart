import 'package:get_it/get_it.dart';
import 'package:objectbox_stream_issue/service/note_repo.dart';
import 'package:objectbox_stream_issue/service/objectbox_service.dart';

//########################################################################
//      Created By Jacob Handaya
//      jacobhandaya@gmail.com
//      as follow as ObjectBox Sync Sample
//      2021
//########################################################################

final GetIt locator = GetIt.instance;

setupLocator() {
  locator.registerLazySingleton<ObjectBoxService>(() => ObjectBoxService());
  locator.registerLazySingleton<NoteRepo>(() => NoteRepo());
}
