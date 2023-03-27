import 'package:mynotes/datasource/local_data_source.dart';
import 'package:mynotes/datasource/remote_data_source.dart';

class Repository {
  final LocalDataSource _localDataSource;
  final RemoteDataSource _remoteDataSource;

  const Repository(this._localDataSource, this._remoteDataSource);

  factory Repository.crud() => Repository(LocalDataSource(), RemoteDataSource());
}
