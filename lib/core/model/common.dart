enum RotationViewType {
  loose,
  compact;

  static RotationViewType? fromName(String name) {
    return .values.where((value) => value.name == name).firstOrNull;
  }
}
