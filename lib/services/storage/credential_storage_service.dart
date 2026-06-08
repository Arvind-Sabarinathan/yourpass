import 'package:yourpass/models/credential.dart';
import 'package:yourpass/services/storage/credential_dao.dart';

class CredentialStorageService {
  final CredentialDao _dao;

  CredentialStorageService({CredentialDao? dao})
    : _dao = dao ?? CredentialDao();

  Future<List<Credential>> loadCredentials({
    String? searchQuery,
    CredentialCategory? category,
  }) async {
    return _dao.getAll(searchQuery: searchQuery, category: category);
  }

  Future<void> addCredential(Credential credential) async {
    await _dao.insert(credential);
  }

  Future<void> updateCredential(Credential updated) async {
    await _dao.update(updated);
  }

  Future<void> deleteCredential(String id) async {
    await _dao.delete(id);
  }

  Future<void> deleteAll() async {
    await _dao.deleteAll();
  }
}
