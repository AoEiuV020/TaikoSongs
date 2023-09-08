import 'dart:async';
import 'dart:isolate';

class IsolateTransformer<S, T> {
  Future<T> convert(S data, Stream<T> Function(Stream<S> e) mapper) {
    return transform(Stream.value(data), mapper).first;
  }

  Stream<T> transform(
      Stream<S> data, Stream<T> Function(Stream<S> e) mapper) async* {
    var mainReceive = ReceivePort();
    await Isolate.spawn((SendPort sendPort) {
      final receivePort = ReceivePort();
      sendPort.send(receivePort.sendPort);
      final streamController = StreamController<S>();
      mapper(streamController.stream).listen((event) {
        sendPort.send(event);
      });
      receivePort.listen((event) {
        if (event == receivePort.sendPort) {
          streamController.close();
          return;
        }
        streamController.sink.add(event as S);
      }, onDone: () {
        streamController.close();
      });
    }, mainReceive.sendPort);

    await for (var message in mainReceive) {
      if (message is SendPort) {
        data.listen((event) {
          message.send(event);
        }, onDone: () {
          message.send(message);
        });
        continue;
      }
      yield message as T;
    }
  }
}
