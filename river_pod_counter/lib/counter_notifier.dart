import 'package:flutter_riverpod/flutter_riverpod.dart';

typedef CounterProvider = NotifierProvider<CounterNotifier,int>;
class CounterNotifier extends Notifier<int>{
  @override
  int build() {
    return 0;
  }
  void increment(){
    state = state + 1;

  }
  void decrement(){
    state = state - 1;
  }
  void customCounter(int counter){
    state = counter;
  }
  void reset(){
    state = 0;
  }

}

final CounterProvider counterProvider =CounterProvider(
        (){
      return CounterNotifier();
    }
);