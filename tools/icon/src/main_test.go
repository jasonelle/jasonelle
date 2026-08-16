package main

import (
	"image"
	"testing"
)

func TestResize(t *testing.T) {
	src := image.NewRGBA(image.Rect(0, 0, 1024, 1024))
	dst := resize(src, 48)
	if w, h := dst.Bounds().Dx(), dst.Bounds().Dy(); w != 48 || h != 48 {
		t.Fatalf("got %dx%d, want 48x48", w, h)
	}
}
