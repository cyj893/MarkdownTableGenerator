
class CellKeyGenerator {
  static final CellKeyGenerator _cellKeyGenerator = CellKeyGenerator._internal();
  int _key = 0;

  CellKeyGenerator._internal();

  factory CellKeyGenerator() => _cellKeyGenerator;

  int generateKey() => ++_key;

  int getNowKey() => _key;

}
