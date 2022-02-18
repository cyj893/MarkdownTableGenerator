
class FocusedCell {
  static final FocusedCell _focusedCell = FocusedCell._internal();
  int _key = -1;

  FocusedCell._internal();

  factory FocusedCell() => _focusedCell;

  int getKey() => _key;

  void setKey(int key) => _key = key;

}
