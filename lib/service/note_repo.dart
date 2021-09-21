import 'package:objectbox/objectbox.dart';
import 'package:objectbox_stream_issue/model/note.dart';
import 'package:objectbox_stream_issue/objectbox.g.dart';

//########################################################################
//      Created By Jacob Handaya
//      jacobhandaya@gmail.com
//      as follow as ObjectBox Sync Sample
//      2021
//########################################################################

class NoteRepo {
  late Box<Note> _box;

  void initBox({required Store store}) {
    _box = Box<Note>(store);
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