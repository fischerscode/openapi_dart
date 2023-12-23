import 'dart:async';

Future<T> anyFutureIgnoringErrors<T>(Iterable<Future<T>> futures) {
  var completer = Completer<T>.sync();
  void onValue(T value) {
    if (!completer.isCompleted) completer.complete(value);
  }

  int running = 0;
  void onError(Object error, StackTrace stack) {
    if (!completer.isCompleted) {
      running--;
      if (running == 0) {
        completer.completeError(error, stack);
      }
    }
  }

  for (var future in futures) {
    running++;
    future.then(onValue, onError: onError);
  }
  return completer.future;
}
