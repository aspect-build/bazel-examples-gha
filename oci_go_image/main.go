package main

import (
	"fmt"

	"github.com/google/go-cmp/cmp"
)

func Compare(str1, str2 string) string {
	return cmp.Diff(str1, str2)
}

func CompareInts(a, b int) string {
	return cmp.Diff(a, b)
}

func main() {
	fmt.Println(Compare("Hello World", "Hello 333"))
	fmt.Println(CompareInts(42, 99))
}
