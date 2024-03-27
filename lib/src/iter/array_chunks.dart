part of 'iterator.dart';

/// Returns an iterator over N elements of the iterator at a time.
/// The chunks do not overlap. If N does not divide the length of the iterator, then the last up to N-1 elements will
/// be omitted and can be retrieved from the [.intoRemainder()] function of the iterator.
final class ArrayChunksRIterator<T> extends RIterator<Arr<T>> {
  Iterator<T> _iterator;
  final int _chunkSize;
  Arr<T>? _currentChunk;
  Arr<T?>? _currentChunkBeingBuilt;
  int _count = 0;

  ArrayChunksRIterator(this._iterator, this._chunkSize)
      : assert(_chunkSize > 0, "Chunk size must be greater than 0"),
        super._late() {
    _wIterator = this;
  }

  @override
  bool moveNext() {
    if (!_iterator.moveNext()) {
      return false;
    }
    _currentChunkBeingBuilt = Arr<T?>(null, _chunkSize);
    do {
      _currentChunkBeingBuilt![_count] = _iterator.current;
      _count++;
      if (_count == _chunkSize) {
        _currentChunk = _currentChunkBeingBuilt!.cast<T>();
        _currentChunkBeingBuilt = null;
        _count = 0;
        return true;
      }
    } while (_iterator.moveNext());
    return false;
  }

  @override
  Arr<T> get current => _currentChunk!;

  @override
  Iterator<Arr<T>> get iterator => this;

  /// Returns an iterator over the remaining
  /// elements of the original iterator that are not going to be returned by this iterator.
  /// Therefore, the returned iterator will yield at most N-1 elements.
  /// i.e. Will return None If the iterator has been completely consumed or all the chunks have not yet been cosumed.
  Option<RIterator<T>> intoRemainder() {
    if (_count == 0) {
      return None;
    }
    return Some(_currentChunkBeingBuilt!.iter().take(_count).cast<T>());
  }

  @override
  ArrayChunksRIterator<T> clone() {
    final temp = CloneRIterator._trackable(_iterator);
    _iterator = temp;
    return ArrayChunksRIterator(CloneRIterator._clone(temp), _chunkSize)
        .._currentChunkBeingBuilt = _currentChunkBeingBuilt?.toArr()
        .._count = _count
        .._currentChunk = _currentChunk?.toArr();
  }
}
