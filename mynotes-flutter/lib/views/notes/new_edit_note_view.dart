import 'package:flutter/material.dart';
import 'package:mynotes/assets/get_arguments.dart';

import '../../data/database.dart';
import '../../data/repository.dart';

class NewEditNoteView extends StatefulWidget {
  const NewEditNoteView({Key? key}) : super(key: key);

  @override
  State<NewEditNoteView> createState() => _NewEditNoteViewState();
}

class _NewEditNoteViewState extends State<NewEditNoteView> {
  Note? _note;
  late final TextEditingController _textController;

  Future<Note> createNewOrGetNote(BuildContext context) async {
    final widgetNote = context.getArguments<Note>();

    if (widgetNote != null) {
      _note = widgetNote;
      _textController.text = widgetNote.content;
      return widgetNote;
    }
    final existingNote = _note;
    if (existingNote != null) {
      return existingNote;
    }
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
    createNewOrGetNote(context);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('New note'),
          actions: _note != null
              ? [
                  IconButton(
                      onPressed: () => Repository.get().removeNote(_note!),
                      icon: const Icon(Icons.delete))
                ]
              : [],
        ),
        body: FutureBuilder(
          future: createNewOrGetNote(context),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.done:
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
