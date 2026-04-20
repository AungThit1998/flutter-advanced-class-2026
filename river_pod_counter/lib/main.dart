import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:river_pod_counter/counter_notifier.dart';
import 'package:river_pod_counter/network_notifier.dart';
import 'package:river_pod_counter/network_state.dart';

//1. provider scope
//2. Consumer Widget
//3  ref.read , read.watch , (provider) (provider.notifier)
//4. ref.listen

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(colorScheme: .fromSeed(seedColor: Colors.deepPurple)),
        home: Home(),
      ),
    );
  }
}

class Home extends ConsumerStatefulWidget {
  const Home({super.key});

  @override
  ConsumerState<Home> createState() => _HomeState();
}

class _HomeState extends ConsumerState<Home> {
  @override
  Widget build(BuildContext context) {
    int counter = ref.watch(counterProvider);
    NetworkState networkState = ref.watch(networkProvider);

    CounterNotifier notifier = ref.read(counterProvider.notifier);
    NetworkNotifier networkNotifier = ref.read(networkProvider.notifier);

    ref.listen(counterProvider, (int? oldCounter, int newCounter) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "old counter is $oldCounter new counter is $newCounter",
          ),
        ),
      );
    });
    return Scaffold(
      appBar: AppBar(title: Text("Riverpod counter")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Counter is $counter", style: TextStyle(fontSize: 30)),
            SizedBox(height: 50),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FilledButton(
                  onPressed: () {
                    notifier.increment();
                  },
                  child: Text("Increment"),
                ),
                SizedBox(width: 50),
                OutlinedButton(
                  onPressed: () {
                    notifier.reset();
                  },
                  child: Text("Reset"),
                ),
                SizedBox(width: 50),
                FilledButton(
                  onPressed: () {
                    notifier.decrement();
                  },
                  child: Text("Decrement"),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Enter Custom Counter',
                ),
                onSubmitted: (str) {
                  int? counter = int.tryParse(str);
                  if (counter != null) {
                    notifier.customCounter(counter);
                  }
                },
              ),
            ),
            SizedBox(height: 16),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (networkState is NetWorkLoadingState)
                    CircularProgressIndicator(),
                  if (networkState is NetWorkSuccessState)
                    Expanded(
                      child: ListView.builder(
                        itemCount: networkState.data.length,
                        itemBuilder: (context, index) {
                          return ListTile(title: Text(networkState.data[index]));
                        },
                      ),
                    ),
                  if (networkState is NetworkFailedState)
                    Text("Error ${networkState.errorMessage}"),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FilledButton(onPressed: (){
                    networkNotifier.load();
                  }, child: Text("Load Data"))
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
