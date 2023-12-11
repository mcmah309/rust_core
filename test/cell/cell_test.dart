import 'package:rust_core/cell.dart';
import 'package:test/test.dart';

void main() {
  group('Cell Tests', () {
    test('Initial value is set correctly', () {
      var cell = Cell<int>(10);
      expect(cell.get(), 10);
    });

    test('Set method updates value correctly', () {
      var cell = Cell<int>(10);
      cell.set(20);
      expect(cell.get(), 20);
    });

    test('Replace method works correctly', () {
      var cell = Cell<String>('initial');
      var oldValue = cell.replace('new');
      expect(oldValue, 'initial');
      expect(cell.get(), 'new');
    });

    test('Swap method swaps values correctly', () {
      var cell1 = Cell<int>(10);
      var cell2 = Cell<int>(20);
      cell1.swap(cell2);
      expect(cell1.get(), 20);
      expect(cell2.get(), 10);
    });

    test('Update method updates value correctly', () {
      var cell = Cell<int>(10);
      var newValue = cell.update((val) => val * 2);
      expect(newValue, 20);
      expect(cell.get(), 20);
    });

    test('Copy method creates a shallow copy', () {
      var cell = Cell<String>('test');
      var copy = cell.copy();
      expect(copy.get(), cell.get());
      expect(identical(cell, copy), isFalse);
    });

    test('Cells with same value have same hash code and are equal', () {
      var cell1 = Cell<int>(10);
      var cell2 = Cell<int>(10);
      expect(cell1.hashCode, cell2.hashCode);
      expect(cell1 == cell2, isTrue);
    });

    test('Cells with different values are not equal', () {
      var cell1 = Cell<int>(10);
      var cell2 = Cell<int>(20);
      expect(cell1 == cell2, isFalse);
    });

    test('toString returns correct representation', () {
      var cell = Cell<int>(10);
      expect(cell.toString(), 'Cell<int>(10)');
    });
  });

  group('DoubleCellExtensions Tests', () {
    test('Addition operator works correctly', () {
      var cell1 = Cell<double>(10.0);
      var cell2 = Cell<double>(20.0);
      var result = cell1 + cell2;
      expect(result.get(), 30.0);
    });

    test('Subtraction operator works correctly', () {
      var cell1 = Cell<double>(30.0);
      var cell2 = Cell<double>(10.0);
      var result = cell1 - cell2;
      expect(result.get(), 20.0);
    });

    test('Multiplication operator works correctly', () {
      var cell1 = Cell<double>(10.0);
      var cell2 = Cell<double>(5.0);
      var result = cell1 * cell2;
      expect(result.get(), 50.0);
    });

    test('Division operator works correctly', () {
      var cell1 = Cell<double>(20.0);
      var cell2 = Cell<double>(4.0);
      var result = cell1 / cell2;
      expect(result.get(), 5.0);
    });

    test('Modulo operator works correctly', () {
      var cell1 = Cell<double>(10.0);
      var cell2 = Cell<double>(3.0);
      var result = cell1 % cell2;
      expect(result.get(), 1.0);
    });

    test('Unary minus operator works correctly', () {
      var cell = Cell<double>(10.0);
      var result = -cell;
      expect(result.get(), -10.0);
    });

    test('Add method updates value correctly', () {
      var cell = Cell<double>(10.0);
      cell.add(5.0);
      expect(cell.get(), 15.0);
    });

    test('Subtract method updates value correctly', () {
      var cell = Cell<double>(20.0);
      cell.sub(5.0);
      expect(cell.get(), 15.0);
    });

    test('Multiply method updates value correctly', () {
      var cell = Cell<double>(10.0);
      cell.mul(3.0);
      expect(cell.get(), 30.0);
    });

    test('Divide method updates value correctly', () {
      var cell = Cell<double>(20.0);
      cell.div(4.0);
      expect(cell.get(), 5.0);
    });

    test('Modulo method updates value correctly', () {
      var cell = Cell<double>(10.0);
      cell.mod(3.0);
      expect(cell.get(), 1.0);
    });

    test('Negate method negates value correctly', () {
      var cell = Cell<double>(10.0);
      cell.neg();
      expect(cell.get(), -10.0);
    });

    test('Increment method increments value correctly', () {
      var cell = Cell<double>(10.0);
      cell.inc();
      expect(cell.get(), 11.0);
    });

    test('Decrement method decrements value correctly', () {
      var cell = Cell<double>(10.0);
      cell.dec();
      expect(cell.get(), 9.0);
    });

    test('Less than operator works correctly', () {
      var cell1 = Cell<double>(10.0);
      var cell2 = Cell<double>(20.0);
      expect(cell1 < cell2, isTrue);
      expect(cell2 < cell1, isFalse);
    });

    test('Greater than operator works correctly', () {
      var cell1 = Cell<double>(20.0);
      var cell2 = Cell<double>(10.0);
      expect(cell1 > cell2, isTrue);
      expect(cell2 > cell1, isFalse);
    });

    test('Less than or equal operator works correctly', () {
      var cell1 = Cell<double>(10.0);
      var cell2 = Cell<double>(10.0);
      var cell3 = Cell<double>(20.0);
      expect(cell1 <= cell2, isTrue);
      expect(cell1 <= cell3, isTrue);
      expect(cell3 <= cell1, isFalse);
    });

    test('Greater than or equal operator works correctly', () {
      var cell1 = Cell<double>(20.0);
      var cell2 = Cell<double>(10.0);
      var cell3 = Cell<double>(20.0);
      expect(cell1 >= cell2, isTrue);
      expect(cell1 >= cell3, isTrue);
      expect(cell2 >= cell1, isFalse);
    });

    test('lt method compares correctly', () {
      var cell = Cell<double>(10.0);
      expect(cell.lt(20.0), isTrue);
      expect(cell.lt(5.0), isFalse);
    });

    test('gt method compares correctly', () {
      var cell = Cell<double>(20.0);
      expect(cell.gt(10.0), isTrue);
      expect(cell.gt(30.0), isFalse);
    });

    test('lte method compares correctly', () {
      var cell = Cell<double>(10.0);
      expect(cell.lte(10.0), isTrue);
      expect(cell.lte(20.0), isTrue);
      expect(cell.lte(5.0), isFalse);
    });

    test('gte method compares correctly', () {
      var cell = Cell<double>(20.0);
      expect(cell.gte(10.0), isTrue);
      expect(cell.gte(20.0), isTrue);
      expect(cell.gte(30.0), isFalse);
    });

    test('eq method compares correctly', () {
      var cell = Cell<double>(10.0);
      expect(cell.eq(10.0), isTrue);
      expect(cell.eq(20.0), isFalse);
    });
  });

  group('IntCellExtensions Tests', () {
    test('Addition operator works correctly', () {
      var cell1 = Cell<int>(10);
      var cell2 = Cell<int>(20);
      var result = cell1 + cell2;
      expect(result.get(), 30);
    });

    test('Subtraction operator works correctly', () {
      var cell1 = Cell<int>(30);
      var cell2 = Cell<int>(10);
      var result = cell1 - cell2;
      expect(result.get(), 20);
    });

    test('Multiplication operator works correctly', () {
      var cell1 = Cell<int>(10);
      var cell2 = Cell<int>(5);
      var result = cell1 * cell2;
      expect(result.get(), 50);
    });

    test('Integer division operator works correctly', () {
      var cell1 = Cell<int>(20);
      var cell2 = Cell<int>(4);
      var result = cell1 ~/ cell2;
      expect(result.get(), 5);
    });

    test('Modulo operator works correctly', () {
      var cell1 = Cell<int>(10);
      var cell2 = Cell<int>(3);
      var result = cell1 % cell2;
      expect(result.get(), 1);
    });

    test('Unary minus operator works correctly', () {
      var cell = Cell<int>(10);
      var result = -cell;
      expect(result.get(), -10);
    });

    test('Add method updates value correctly', () {
      var cell = Cell<int>(10);
      cell.add(5);
      expect(cell.get(), 15);
    });

    test('Subtract method updates value correctly', () {
      var cell = Cell<int>(20);
      cell.sub(5);
      expect(cell.get(), 15);
    });

    test('Multiply method updates value correctly', () {
      var cell = Cell<int>(10);
      cell.mul(3);
      expect(cell.get(), 30);
    });

    test('Truncating divide method updates value correctly', () {
      var cell = Cell<int>(20);
      cell.truncDiv(4);
      expect(cell.get(), 5);
    });

    test('Modulo method updates value correctly', () {
      var cell = Cell<int>(10);
      cell.mod(3);
      expect(cell.get(), 1);
    });

    test('Negate method negates value correctly', () {
      var cell = Cell<int>(10);
      cell.neg();
      expect(cell.get(), -10);
    });

    test('Increment method increments value correctly', () {
      var cell = Cell<int>(10);
      cell.inc();
      expect(cell.get(), 11);
    });

    test('Decrement method decrements value correctly', () {
      var cell = Cell<int>(10);
      cell.dec();
      expect(cell.get(), 9);
    });

    test('Less than operator works correctly', () {
      var cell1 = Cell<int>(10);
      var cell2 = Cell<int>(20);
      expect(cell1 < cell2, isTrue);
      expect(cell2 < cell1, isFalse);
    });

    test('Greater than operator works correctly', () {
      var cell1 = Cell<int>(20);
      var cell2 = Cell<int>(10);
      expect(cell1 > cell2, isTrue);
      expect(cell2 > cell1, isFalse);
    });

    test('Less than or equal operator works correctly', () {
      var cell1 = Cell<int>(10);
      var cell2 = Cell<int>(10);
      var cell3 = Cell<int>(20);
      expect(cell1 <= cell2, isTrue);
      expect(cell1 <= cell3, isTrue);
      expect(cell3 <= cell1, isFalse);
    });

    test('Greater than or equal operator works correctly', () {
      var cell1 = Cell<int>(20);
      var cell2 = Cell<int>(10);
      var cell3 = Cell<int>(20);
      expect(cell1 >= cell2, isTrue);
      expect(cell1 >= cell3, isTrue);
      expect(cell2 >= cell1, isFalse);
    });

    test('lt method compares correctly', () {
      var cell = Cell<int>(10);
      expect(cell.lt(20), isTrue);
      expect(cell.lt(5), isFalse);
    });

    test('gt method compares correctly', () {
      var cell = Cell<int>(20);
      expect(cell.gt(10), isTrue);
      expect(cell.gt(30), isFalse);
    });

    test('lte method compares correctly', () {
      var cell = Cell<int>(10);
      expect(cell.lte(10), isTrue);
      expect(cell.lte(20), isTrue);
      expect(cell.lte(5), isFalse);
    });

    test('gte method compares correctly', () {
      var cell = Cell<int>(20);
      expect(cell.gte(10), isTrue);
      expect(cell.gte(20), isTrue);
      expect(cell.gte(30), isFalse);
    });

    test('eq method compares correctly', () {
      var cell = Cell<int>(10);
      expect(cell.eq(10), isTrue);
      expect(cell.eq(20), isFalse);
    });
  });

  test('const cell', () {
    const constCell = ConstCell(1);
    var cell = Cell(1);
    expect(constCell, equals(cell));
    expect(constCell.hashCode, equals(cell.hashCode));
    cell = Cell(2);
    expect(constCell, isNot(equals(cell)));
    expect(constCell.hashCode, isNot(equals(cell.hashCode)));
  });
}
