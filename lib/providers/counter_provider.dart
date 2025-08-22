class Counter {
  int value;
  final int minValue;
  final int maxValue;
  final int step;

  Counter({
    this.value = 0,
    this.minValue = 0,
    this.maxValue = 12,
    this.step = 1,
  });

  void increment() {
    if (value + step <= maxValue) {
      value += step;
    }
  }

  void decrement() {
    if (value - step >= minValue) {
      value -= step;
    }
  }

  void setValue(int newValue) {
    if (newValue >= minValue && newValue <= maxValue) {
      value = newValue;
    }
  }
}
