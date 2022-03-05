
class CellKeyGenerator {
  static final CellKeyGenerator _cellKeyGenerator = CellKeyGenerator._internal();

  CellKeyGenerator._internal();

  factory CellKeyGenerator() => _cellKeyGenerator;

  int _key = 0;

  int generateKey() => ++_key;

}
