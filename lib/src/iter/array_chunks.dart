import 'package:rust_core/option.dart';
import 'package:rust_core/iter.dart';
import 'package:rust_core/array.dart';

/// Returns an iterator over N elements of the iterator at a time.
/// The chunks do not overlap. If N does not divide the length of the iterator, then the last up to N-1 elements will
/// be omitted and can be retrieved from the [.intoRemainder()] function of the iterator.
class ArrayChunksIterator<T> implements Iterator<Arr<T>> {
  final Iterator<T> _iterator;
  final int _chunkSize;
  late Arr<T> _currentChunk;
  late Arr<T?> _currentChunkBeingBuilt;
  int _count = 0;

  ArrayChunksIterator(this._iterator, this._chunkSize)
      :  assert(_chunkSize > 0, "Chunk size must be greater than 0");

  @override
  bool moveNext() {
    if (!_iterator.moveNext()) {
      return false;
    }
    _currentChunkBeingBuilt = Arr<T?>(null, _chunkSize);
    do {
      _currentChunkBeingBuilt[_count] = _iterator.current;
      _count++;
      if (_count == _chunkSize) {
        _currentChunk = _currentChunkBeingBuilt.cast<T>();
        _count = 0;
        return true;
      }
    } while (_iterator.moveNext());
    return false;
  }

  @override
  Arr<T> get current => _currentChunk;

  /// Returns an iterator over the remaining
  /// elements of the original iterator that are not going to be returned by this iterator.
  /// Therefore, the returned iterator will yield at most N-1 elements.
  /// i.e. Will return None If the iterator has been completely consumed or all the chunks have not yet been cosumed.
  Option<RIterator<T>> intoRemainder() {
    if (_count == 0) {
      return None;
    }
    return Some(_currentChunkBeingBuilt.iter().take(_count).cast<T>());
  }
}

/// An iterable over N elements of the iterable at a time.
class ArrayChunks<T> extends Iterable<Arr<T>> {
  final Iterable<T> _iterable;
  final int _chunkSize;

  ArrayChunks(this._iterable, this._chunkSize);

  @override
  ArrayChunksIterator<T> get iterator {
    return ArrayChunksIterator(_iterable.iterator, _chunkSize);
  }
}
