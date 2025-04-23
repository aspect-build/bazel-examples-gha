package main

import (
	"strings"
	"testing"
)

func TestCompare(t *testing.T) {
	result := Compare("this", "that")

	if !strings.Contains(result, "this") {
		t.Error("expected a diff containing 'that' but got", result)
	}
}
