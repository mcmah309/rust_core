
import 'package:meta/meta.dart';

part 'int_cell.dart';
part 'double_cell.dart';
part 'bool_cell.dart';

class Cell<T> {
  T _val;

  Cell(T val): _val = val;

  T get() {
    return _val;
  }

  T replace(T val){
    final temp = _val;
    _val = val;
    return temp;
  }

  void set(T val){
    _val = val;
  }

  void swap(covariant Cell<T> cell){
    final temp = cell._val;
    cell._val = _val;
    _val = temp;
  }

  T update(T Function(T) fn){
    _val = fn(_val);
    return _val;
  }

  Cell<T> copy(){
    return Cell(_val);
  }

  @override
  int get hashCode => _val.hashCode;

  @override
  bool operator ==(covariant Object other) {
    return other is Cell && other._val == _val;
  }

  @override
  String toString() {
    return "$runtimeType($_val)";
  }
}

/// Defines a set of common arithmetic operations for a generic type `T`.
/// missing divide and trunc divide
abstract class _CommonArithmeticOperations<T> extends Cell<T> {
  _CommonArithmeticOperations(super.val);

  /// Adds another `ArithmeticOperations` object to this object.
  _CommonArithmeticOperations<T> operator +(covariant _CommonArithmeticOperations<T> other);

  /// Adds a value of type `T` to this object's value.
  void add(T val);

  /// Subtracts another `ArithmeticOperations` object from this object.
  _CommonArithmeticOperations<T> operator -(covariant _CommonArithmeticOperations<T> other);

  /// Subtracts a value of type `T` from this object's value.
  void subtract(T val);

  /// Multiplies this object with another `ArithmeticOperations` object.
  _CommonArithmeticOperations<T> operator *(covariant _CommonArithmeticOperations<T> other);

  /// Multiplies this object's value with a value of type `T`.
  void multiply(T val);

  /// Calculates the modulus of this object by another `ArithmeticOperations` object.
  _CommonArithmeticOperations<T> operator %(covariant _CommonArithmeticOperations<T> other);

  /// Calculates the modulus of this object's value by a value of type `T`.
  void modulo(T val);
}


/// Defines a set of comparison operations for a generic type `T`.
abstract class _ComparisonOperations<T> extends Cell<T> {
  _ComparisonOperations(super.val);

  /// Compares if this object is less than another `ComparisonOperations` object.
  bool operator <(covariant _ComparisonOperations<T> other);

  /// Compares if this object's value is less than a value of type `T`.
  bool lt(T val);

  /// Compares if this object is greater than another `ComparisonOperations` object.
  bool operator >(covariant _ComparisonOperations<T> other);

  /// Compares if this object's value is greater than a value of type `T`.
  bool gt(T val);

  /// Compares if this object is less than or equal to another `ComparisonOperations` object.
  bool operator <=(covariant _ComparisonOperations<T> other);

  /// Compares if this object's value is less than or equal to a value of type `T`.
  bool lte(T val);

  /// Compares if this object is greater than or equal to another `ComparisonOperations` object.
  bool operator >=(covariant _ComparisonOperations<T> other);

  /// Compares if this object's value is greater than or equal to a value of type `T`.
  bool gte(T val);

  /// Compares if this object is equal to another `ComparisonOperations` object.
  @override
  @mustBeOverridden
  bool operator ==(covariant _ComparisonOperations<T> other);

  /// Compares if this object's value is equal to a value of type `T`.
  bool eq(T val);

  /// Returns a hash code for this object.
  @override
  @mustBeOverridden
  int get hashCode;
}

/// Defines a set of unary operations for a generic type `T`.
abstract class _UnaryOperations<T> extends Cell<T> {
  _UnaryOperations(super.val);

  /// Negates the value of this object.
  _UnaryOperations<T> operator -();

  /// Negates this object's value.
  void negate();

  /// Increments this object's value.
  void increment();

  /// Decrements this object's value.
  void decrement();
}
