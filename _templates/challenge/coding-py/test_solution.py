from solution import sum_two


def test_positive_numbers():
    assert sum_two(2, 3) == 5


def test_negative_numbers():
    assert sum_two(-1, -1) == -2


def test_zero():
    assert sum_two(0, 0) == 0


def test_floats():
    assert sum_two(1.5, 2.5) == 4.0
