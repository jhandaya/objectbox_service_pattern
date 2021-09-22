import 'dart:io';

import 'package:objectbox_stream_issue/locator.dart';
import 'package:objectbox_stream_issue/objectbox.g.dart';
import 'package:objectbox_stream_issue/service/note_repo.dart';
import 'package:objectbox/objectbox.dart';
import 'package:objectbox_sync_flutter_libs/objectbox_sync_flutter_libs.dart';

//########################################################################
//      Created By Jacob Handaya
//      jacobhandaya@gmail.com
//      as follow as ObjectBox Sync Sample
//      2021
//########################################################################

class ObjectBoxService {
  //remember must have keyword late initialization
  late Store _store;
  Store get store => _store;

  //remember must have keyword late initialization otherwise it wont work
  late NoteRepo _noteRepo = locator<NoteRepo>();
  NoteRepo get noteRepo => _noteRepo;

  Future<Directory> storeDirectory() async {
    return defaultStoreDirectory();
  }

  ObjectBoxService({required Directory dir}) {
    _store = Store(getObjectBoxModel(),
        directory: dir.path + '-sync', macosApplicationGroup: 'objectbox.demo');

    // For configuration and docs, see objectbox/lib/src/sync.dart
    // 10.0.2.2 is your host PC if an app is run in an Android emulator.
    // 127.0.0.1 is your host PC if an app is run in an iOS simulator.

    final syncServerIp = Platform.isAndroid ? '10.0.2.2' : '127.0.0.1';
    final syncClient =
        Sync.client(_store, 'ws://$syncServerIp:9999', SyncCredentials.none());

    syncClient.start();
  }

  void dispose() {
    _store.close();
  }
}
