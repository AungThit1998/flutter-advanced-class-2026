sealed class NetworkState {}

class NetWorkLoadingState extends NetworkState{}
class NetWorkSuccessState extends NetworkState{
  final List<String> data;
  NetWorkSuccessState({required this.data});
}
class NetworkFailedState extends NetworkState{
  final String errorMessage;
  NetworkFailedState({required this.errorMessage});
}