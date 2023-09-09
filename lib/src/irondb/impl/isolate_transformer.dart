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
        // 这里把sendPort当成结束的标记使用，
        if (event == receivePort.sendPort) {
          streamController.close();
          return;
        }
        streamController.sink.add(event as S);
      }, onDone: () {
        streamController.close();
      });
    }, mainReceive.sendPort,
        // 这里注册监听异步线程内抛出的异常，
        onError: mainReceive.sendPort);

    await for (var message in mainReceive) {
      if (message is SendPort) {
        data.listen((event) {
          message.send(event);
        }, onDone: () {
          // 这里把sendPort当成结束的标记使用，
          message.send(message);
        });
        continue;
      }
      // 这里是异步线程内抛出的异常，
      if (message is Error) {
        throw message;
      }
      yield message as T;
    }
  }
}
