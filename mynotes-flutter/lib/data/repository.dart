import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:mynotes/data/database.dart';
import 'package:mynotes/data/local_data_source.dart';
import 'package:mynotes/data/notes_dao.dart';
import 'package:mynotes/data/remote_data_source.dart';
import 'package:mynotes/services/auth/auth_service.dart';

class Repository extends NotesDao {
  final LocalDataSource _localDataSource;
  final RemoteDataSource _remoteDataSource;

  Repository(this._localDataSource, this._remoteDataSource);
  factory Repository.crud() => Repository(LocalDataSource(), RemoteDataSource());

  final userId = AuthService.rest().currentUser.id;

  List<Note> _notes = [];
  final _notesStreamController = StreamController<List<Note>>.broadcast();

  @override
  Future<void> createNote(String text) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      // TODO: add note to remote data source
    } else {
      // TODO: notes not synced with remote data source
    }

    await _localDataSource.createNote(text);
    // _notes.add(note);
    // _notesStreamController.add(note);
  }

  @override
  Future<void> removeNote(Note note) async {
    return _localDataSource.removeNote(note);
  }

  @override
  Future<List<Note>> selectUserNotes(int userId) async {
    // get data from local if logged in and connected
    return _localDataSource.selectUserNotes(AuthService.rest().currentUser.id);
  }

  // Future<void> _cacheNotes() async {
  //   final allNotes = await selectUserNotes(userId);
  //   _notes = allNotes.toList();
  //   _notesStreamController.add(_notes);
  // }

  @override
  Future<void> updateNote(Note note) async {
    return _localDataSource.updateNote(note);
  }
}
