// ignore_for_file: prefer_const_constructors

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:objectbox_stream_issue/locator.dart';
import 'package:objectbox_stream_issue/service/objectbox_service.dart';
import 'package:objectbox_sync_flutter_libs/objectbox_sync_flutter_libs.dart';

import 'model/note.dart';

class DisplayView extends StatefulWidget {
  const DisplayView({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<DisplayView> createState() => _DisplayViewState();
}

class _DisplayViewState extends State<DisplayView> {
  final _noteInputController = TextEditingController();
  final _listController = StreamController<List<Note>>(sync: true);

  final ObjectBoxService _objectBoxService = locator<ObjectBoxService>();

  @override
  void initState() {
    super.initState();

    defaultStoreDirectory().then((dir) {
      _objectBoxService.initStore(dir: dir);

      final _t =
          _objectBoxService.noteRepo.queryStream().map((event) => event.find());

      _t.listen((onData) {
        _listController.add(onData);
      });
    });
  }

  void _addNote() {
    if (_noteInputController.text.isEmpty) return;

    _objectBoxService.noteRepo.addNote(Note(_noteInputController.text));
    _noteInputController.text = '';
  }

  @override
  void dispose() {
    _noteInputController.dispose();
    _listController.close();
    _objectBoxService.dispose();
    super.dispose();
  }

  GestureDetector Function(BuildContext, int) _itemBuilder(List<Note> notes) =>
      (BuildContext context, int index) => GestureDetector(
            onTap: () => _objectBoxService.noteRepo.removeNote(notes[index]),
            child: Row(
              children: <Widget>[
                GestureDetector(
                  child: Text("OK BACK"),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                        border:
                            Border(bottom: BorderSide(color: Colors.black12))),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: 18.0, horizontal: 10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            notes[index].text,
                            style: TextStyle(
                              fontSize: 15.0,
                            ),
                            // Provide a Key for the integration test
                            key: Key('list_item_$index'),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 5.0),
                            child: Text(
                              'Added on ${notes[index].dateFormat}',
                              style: TextStyle(
                                fontSize: 12.0,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(children: <Widget>[
        Padding(
          padding: EdgeInsets.all(20.0),
          child: Row(
            children: <Widget>[
              Expanded(
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10.0),
                      child: TextField(
                        decoration:
                            InputDecoration(hintText: 'Enter a new note'),
                        controller: _noteInputController,
                        onSubmitted: (value) => _addNote(),
                        // Provide a Key for the integration test
                        key: Key('input'),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 10.0, right: 10.0),
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          'Tap a note to remove it',
                          style: TextStyle(
                            fontSize: 11.0,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
        Expanded(
            child: StreamBuilder<List<Note>>(
                stream: _listController.stream,
                builder: (context, snapshot) => ListView.builder(
                    shrinkWrap: true,
                    padding: EdgeInsets.symmetric(horizontal: 20.0),
                    itemCount: snapshot.hasData ? snapshot.data!.length : 0,
                    itemBuilder: _itemBuilder(snapshot.data ?? []))))
      ]),
      // We need a separate submit button because flutter_driver integration
      // test doesn't support submitting a TextField using "enter" key.
      // See https://github.com/flutter/flutter/issues/9383
      floatingActionButton: FloatingActionButton(
        key: Key('submit'),
        onPressed: _addNote,
        child: Icon(Icons.add),
      ),
    );
  }
}
