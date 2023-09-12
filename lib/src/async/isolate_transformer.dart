import 'dart:async';
import 'dart:isolate';

class IsolateTransformer {
  Future<T> convert<S, T>(S data, Stream<T> Function(Stream<S> e) mapper) {
    return transform<S, T>(Stream.value(data), mapper).first;
  }

  Future<T> run<S, T>(S data, Future<T> Function(S data) mapper) async {
    return await transform<S, T>(
        Stream.value(data),
        (e) => e.asyncMap((event) async {
              return await mapper(event);
            })).first;
  }

  Stream<T> transform<S, T>(
      Stream<S> data, Stream<T> Function(Stream<S> e) mapper) async* {
    if (const bool.fromEnvironment('dart.library.js_util')) {
      yield* mapper(data);
      return;
    }
    var mainReceive = ReceivePort();
    await Isolate.spawn((SendPort sendPort) {
      final receivePort = ReceivePort();
      sendPort.send(receivePort.sendPort);
      final streamController = StreamController<S>();
      mapper(streamController.stream).listen((event) {
        sendPort.send(event);
      }, onDone: () {
        // 这里把sendPort当成结束的标记使用，
        sendPort.send(sendPort);
      }, onError: (Object e, s) {
        if (e is Error) {
          // 异常传到主线程再抛出，
          sendPort.send(e);
        }
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
      if (message == mainReceive.sendPort) {
        // 这里把sendPort当成结束的标记使用，
        return;
      }
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
