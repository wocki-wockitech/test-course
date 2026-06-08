package challenge

import "testing"

func TestSum_PositiveNumbers(t *testing.T) {
	if got := Sum(2, 3); got != 5 {
		t.Errorf("Sum(2, 3) = %d, want 5", got)
	}
}

func TestSum_NegativeNumbers(t *testing.T) {
	if got := Sum(-1, -1); got != -2 {
		t.Errorf("Sum(-1, -1) = %d, want -2", got)
	}
}

func TestSum_Zero(t *testing.T) {
	if got := Sum(0, 0); got != 0 {
		t.Errorf("Sum(0, 0) = %d, want 0", got)
	}
}

func TestSum_MixedSign(t *testing.T) {
	if got := Sum(10, -3); got != 7 {
		t.Errorf("Sum(10, -3) = %d, want 7", got)
	}
}
