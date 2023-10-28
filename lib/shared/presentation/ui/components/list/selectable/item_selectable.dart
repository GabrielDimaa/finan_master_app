class ItemSelectable<T> {
  final T value;
  bool selected;

  ItemSelectable({required this.value, this.selected = false});
}
