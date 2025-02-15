enum RotationViewType {
  loose,
  compact;

  static RotationViewType? fromName(String name) {
    return RotationViewType.values.where((value) => value.name == name).firstOrNull;
  }
}
