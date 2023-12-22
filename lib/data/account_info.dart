class AccountInfo {
  String id = '';
  String name = '';

  AccountInfo({
    required String id,
    required String name,
  });

  @override
  String toString() {
    return 'AccountInfo{id: $id, name: $name}';
  }
}
