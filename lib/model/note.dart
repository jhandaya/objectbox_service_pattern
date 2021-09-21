import 'package:intl/intl.dart';
import 'package:objectbox/objectbox.dart';

//########################################################################
//      Created By Jacob Handaya
//      jacobhandaya@gmail.com 
//      as follow as ObjectBox Sync Sample
//      2021
//########################################################################

@Entity()
@Sync()
class Note {
  int id;

  String text;
  String? comment;
  DateTime date;

  Note(this.text, {this.id = 0, this.comment, DateTime? date})
      : date = date ?? DateTime.now();

  String get dateFormat => DateFormat('dd.MM.yyyy hh:mm:ss').format(date);
}
