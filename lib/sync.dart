library sync;

// Isolates not supported on web. https://dart.dev/language/concurrency#concurrency-on-the-web
export 'src/sync/isolate_channel.dart'
    if (dart.library.html) ''
    if (dart.library.js) '';
// Int64 accessor not supported by dart2js.
export 'src/sync/send_codec.dart'
    if (dart.library.html) ''
    if (dart.library.js) '';
export 'src/sync/channel.dart';
export 'src/sync/mutex.dart';
