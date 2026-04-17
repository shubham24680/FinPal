enum NetworkState { initial, loading, error, success }

class NetworkService<T> {
  final NetworkState state;
  final T? data;
  final String? errorMessage;

  NetworkService({
    this.state = NetworkState.initial,
    this.data,
    this.errorMessage,
  });

  NetworkService<T> copyWith({
    NetworkState? state,
    T? data,
    String? errorMessage,
  }) {
    return NetworkService<T>(
      state: state ?? this.state,
      data: data ?? this.data,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  bool get isLoading => state == NetworkState.loading;
  bool get isError => state == NetworkState.error;
  bool get isSuccess => state == NetworkState.success;
  bool get isInitial => state == NetworkState.initial;

  NetworkService<T> successState(T data) =>
      copyWith(state: NetworkState.success, data: data, errorMessage: null);
  NetworkService<T> loadingState() => copyWith(state: NetworkState.loading);
  NetworkService<T> errorState(String error) =>
      copyWith(state: NetworkState.error, errorMessage: error);
}
