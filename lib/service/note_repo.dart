import 'package:objectbox/objectbox.dart';
import 'package:objectbox_stream_issue/locator.dart';
import 'package:objectbox_stream_issue/model/note.dart';
import 'package:objectbox_stream_issue/objectbox.g.dart';
import 'package:objectbox_stream_issue/service/objectbox_service.dart';
//########################################################################
//      Created By Jacob Handaya
//      jacobhandaya@gmail.com
//      as follow as ObjectBox Sync Sample
//      2021
//########################################################################

class NoteRepo {
  //remember must have keyword late initialization
  late Box<Note> _box;

  //remember must have keyword late initialization
  late ObjectBoxService _objectBoxService = locator<ObjectBoxService>();

  NoteRepo() {
    _box = Box<Note>(_objectBoxService.store);
  }

  Stream<Query<Note>> queryStream() {
    final qBuilder = _box.query()..order(Note_.date, flags: Order.descending);
    final _queryStream = qBuilder.watch(triggerImmediately: true);
    return _queryStream;
  }

  void addNote(Note note) => _box.put(note);

  void removeNote(Note note) => _box.remove(note.id);
}


///