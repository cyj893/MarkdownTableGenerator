
class CellKeyGenerator {
  static final CellKeyGenerator _cellKeyGenerator = CellKeyGenerator._internal();
  int _key = 0;

  CellKeyGenerator._internal();

  factory CellKeyGenerator() {
    return _cellKeyGenerator;
  }

  int getKey(){
    _key++;
    return _key;
  }

  int nowKey(){
    return _key;
  }

}
