
class FocusedCell {
  static final FocusedCell _focusedCell = FocusedCell._internal();
  int _key = -1;

  FocusedCell._internal();

  factory FocusedCell() {
    return _focusedCell;
  }

  void setKey(int key){
    print("  now Cell Key = $key");
    _key = key;
  }

  int getKey(){
    return _key;
  }

}
