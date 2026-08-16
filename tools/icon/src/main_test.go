package main

import (
	"image"
	"os"
	"path/filepath"
	"strings"
	"testing"
)

func TestResize(t *testing.T) {
	src := image.NewRGBA(image.Rect(0, 0, 1024, 1024))
	dst := resize(src, 48)
	if w, h := dst.Bounds().Dx(), dst.Bounds().Dy(); w != 48 || h != 48 {
		t.Fatalf("got %dx%d, want 48x48", w, h)
	}
}

func TestRunGeneratesIcons(t *testing.T) {
	dir := t.TempDir()
	src := filepath.Join(dir, "1024x1024.png")
	if err := writeIcon(image.NewRGBA(image.Rect(0, 0, 1024, 1024)), src, 1024); err != nil {
		t.Fatal(err)
	}
	android := filepath.Join(dir, "android")
	xcode := filepath.Join(dir, "xcode")

	if err := run([]string{"--source", src, "--android", android, "--xcode", xcode}); err != nil {
		t.Fatal(err)
	}

	want := []string{
		filepath.Join(android, "assets", "icon", "res", "mipmap-mdpi", "ic_launcher.png"),
		filepath.Join(android, "assets", "icon", "res", "mipmap-xxxhdpi", "ic_launcher_round.png"),
		filepath.Join(android, "assets", "icon", "store", "icon-512.png"),
		filepath.Join(xcode, "assets", "AppIcon.appiconset", "Contents.json"),
		filepath.Join(xcode, "assets", "AppIcon.appiconset", "icon-180.png"),
		filepath.Join(xcode, "assets", "AppIcon.appiconset", "icon-1024.png"),
	}
	for _, path := range want {
		if _, err := os.Stat(path); err != nil {
			t.Errorf("missing %s: %v", path, err)
		}
	}
}

func TestRunRequiresOutputFlag(t *testing.T) {
	if err := run(nil); err == nil || !strings.Contains(err.Error(), "xcode or -android") {
		t.Fatalf("got %v, want missing output flag error", err)
	}
}
