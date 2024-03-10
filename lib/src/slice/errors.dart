sealed class GetManyError implements Exception {
  const GetManyError();

  @override
  String toString() {
    return "GetManyError";
  }

  @override
  bool operator ==(Object other) {
    return other.runtimeType == runtimeType;
  }

  @override
  int get hashCode => runtimeType.hashCode;
}

final class GetManyErrorTooManyIndices extends GetManyError {
  const GetManyErrorTooManyIndices();

  @override
  String toString() {
    return "GetManyError: The number of indices must be less than or equal to the length of the slice";
  }
}

final class GetManyErrorRequestedIndexOutOfBounds extends GetManyError {
  const GetManyErrorRequestedIndexOutOfBounds();

  @override
  String toString() {
    return "GetManyError: The requiested index out of bounds";
  }
}