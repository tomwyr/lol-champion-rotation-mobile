sealed class DataState<T> {}

class Initial<T> extends DataState<T> {}

class Loading<T> extends DataState<T> {}

class Error<T> extends DataState<T> {}

class Data<T> extends DataState<T> {
  Data(this.value, {this.loadingMore = false});

  final T value;
  final bool loadingMore;
}
