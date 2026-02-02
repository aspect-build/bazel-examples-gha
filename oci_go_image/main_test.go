package main

import (
	"strings"
	"testing"
)

func TestCompare(t *testing.T) {
	result := Compare("this", "that")

	if !strings.Contains(result, "this") {
		t.Error("expected a diff containing 'this' but got", result)
	}
}

func TestCompareInts(t *testing.T) {
	result := CompareInts(42, 99)

	if !strings.Contains(result, "42") {
		t.Error("expected a diff containing '42' but got", result)
	}
}
