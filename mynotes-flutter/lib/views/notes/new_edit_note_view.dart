import 'package:flutter/material.dart';
import 'package:mynotes/assets/get_arguments.dart';

import '../../assets/dialogs/delete_dialog.dart';
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

  void setNote(Note note) {
    setState(() {
      _note = note;
    });
  }

  Future<Note> createNewOrGetNote(BuildContext context) async {
    final widgetNote = context.getArguments<Note>();

    if (widgetNote != null) {
      setNote(widgetNote);
      _textController.text = widgetNote.content;
      return widgetNote;
    }
    final existingNote = _note;
    if (existingNote != null) {
      return existingNote;
    }
    final newNote = await Repository.get().createNote(_textController.value.text);
    setNote(newNote);
    return newNote;
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
          actions: _note == null
              ? [
                  IconButton(
                    onPressed: () => onDeleteBtnTap(),
                    icon: const Icon(Icons.delete),
                  )
                ]
              : [],
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: FutureBuilder(
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
          ),
        ));
  }

  void onDeleteBtnTap() async {
    final choice = await showDeleteDialog(context);
    if (choice) {
      Repository.get().removeNote(_note!);
      _note = null;
    }
    if (context.mounted) {
      Navigator.of(context).pop();
    }
  }
}
