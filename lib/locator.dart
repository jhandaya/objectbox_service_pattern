import 'dart:io';

import 'package:get_it/get_it.dart';
import 'package:objectbox_stream_issue/service/note_repo.dart';
import 'package:objectbox_stream_issue/service/objectbox_service.dart';
import 'package:path_provider/path_provider.dart';

//########################################################################
//      Created By Jacob Handaya
//      jacobhandaya@gmail.com
//      as follow as ObjectBox Sync Sample
//      2021
//########################################################################

final GetIt locator = GetIt.instance;

setupLocator() async {
  final dir =
      Directory((await getApplicationDocumentsDirectory()).path + '/objectbox');

  locator.registerLazySingleton<ObjectBoxService>(
      () => ObjectBoxService(dir: dir));

  locator.registerLazySingleton<NoteRepo>(() => NoteRepo());
}
