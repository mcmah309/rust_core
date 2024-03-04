

class GetManyError implements Exception {
  final GetManyErrorType reason;

  const GetManyError(this.reason);

  @override
  String toString() {
    return switch(reason){
      GetManyErrorType.tooManyIndices => "The number of indices must be less than or equal to the length of the slice",
      GetManyErrorType.requestedIndexOutOfBounds => "The requiested index out of bounds",
    };
  }
}

enum GetManyErrorType {
  tooManyIndices,
  requestedIndexOutOfBounds,
}