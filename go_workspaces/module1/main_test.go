package main

import (
	"github.com/stretchr/testify/assert"
	"testing"
)

func TestModule(t *testing.T) {
	assert.Equal(t, 2+2, 4, "two plus two is equal to four")
}

func TestAdd(t *testing.T) {
	assert.Equal(t, Add(3, 4), 7, "3 + 4 should equal 7")
	assert.Equal(t, Add(0, 0), 0, "0 + 0 should equal 0")
	assert.Equal(t, Add(-1, 1), 0, "-1 + 1 should equal 0")
}
