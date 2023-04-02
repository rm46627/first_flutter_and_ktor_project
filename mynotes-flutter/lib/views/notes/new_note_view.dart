import 'package:flutter/material.dart';

import '../../data/database.dart';
import '../../data/repository.dart';

class NewNoteView extends StatefulWidget {
  const NewNoteView({Key? key}) : super(key: key);

  @override
  State<NewNoteView> createState() => _NewNoteViewState();
}

class _NewNoteViewState extends State<NewNoteView> {
  Note? _note;
  late final TextEditingController _textController;

  Future<Note> createNewNote() async {
    final existingNote = _note;
    if (existingNote != null) {
      // or update existing note
      return existingNote;
    }
    print("new text: $_textController.value.text");
    _note = await Repository.get().createNote(_textController.value.text);
    return _note!;
  }

  void _setupTextControllerListener() async {
    _textController.removeListener(_textControllerListener);
    _textController.addListener(_textControllerListener);
  }

  void _textControllerListener() async {
    var note = _note;
    if (note == null) {
      return;
    }
    final text = _textController.value.text;
    if (note.content != text) {
      note = note.copyWith(content: text);
      await Repository.get().updateNote(note);
    }
  }

  @override
  void initState() {
    _textController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    createNewNote();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('New note')),
        body: FutureBuilder(
          future: createNewNote(),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.done:
                _note = snapshot.data as Note;
                _setupTextControllerListener();
                return TextField(
                  controller: _textController,
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  decoration: const InputDecoration(hintText: 'Type your note...'),
                );
              default:
                return const CircularProgressIndicator();
            }
          },
        ));
  }
}
