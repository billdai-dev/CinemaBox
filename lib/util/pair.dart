import 'dart:ui';

class Pair<F, S> {
  final F first;
  final S second;

  Pair(this.first, this.second);

  @override
  bool operator ==(dynamic other) {
    if (other is Pair<F, S>) {
      return this.first == other.first && second == other.second;
    } else {
      return false;
    }
  }

  @override
  int get hashCode => hashValues(first, second);

  @override
  String toString() => "Pair{${first.toString()} ${second.toString()}}";
}
