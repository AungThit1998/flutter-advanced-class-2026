import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:river_pod_counter/network_state.dart';

typedef NetworkProvider = NotifierProvider<NetworkNotifier,NetworkState>;
class NetworkNotifier extends Notifier<NetworkState>{
  @override
  NetworkState build() {
    return NetWorkLoadingState();
  }
  void setLoading(){
    state = NetWorkLoadingState();
  }
  void setSuccess(){
    List<String> data = List.generate(100, (data) =>"Item $data");
    state = NetWorkSuccessState(data: data);
  }
  void setFailed(){
    state = NetworkFailedState(errorMessage: "Error due to network connection");
  }

  void load()async{
    setLoading();
    await Future.delayed(Duration(seconds: 2));
    setSuccess();
  }

}

NetworkProvider networkProvider =NetworkProvider((){
  return NetworkNotifier();
});