package main

import (
	"os"
	"path/filepath"
	"strings"
	"testing"
)

func TestInvalidPlatform(t *testing.T) {
	err := run([]string{"--platform", "invalid", "--common", ".", "--platform-dir", ".", "--esbuild", ".", "--output", "."})
	if err == nil {
		t.Fatal("expected error for invalid platform")
	}
	if !strings.Contains(err.Error(), "--platform must be") {
		t.Fatalf("unexpected error: %v", err)
	}
}

func TestMissingRequiredFlags(t *testing.T) {
	err := run([]string{})
	if err == nil {
		t.Fatal("expected error for missing flags")
	}
}

func TestCopyDir(t *testing.T) {
	src := t.TempDir()
	dst := t.TempDir()

	os.WriteFile(filepath.Join(src, "test.ts"), []byte("const x = 1;"), 0644)
	os.MkdirAll(filepath.Join(src, "sub"), 0755)
	os.WriteFile(filepath.Join(src, "sub", "nested.ts"), []byte("const y = 2;"), 0644)

	if err := copyDir(src, dst); err != nil {
		t.Fatalf("copyDir failed: %v", err)
	}

	data, err := os.ReadFile(filepath.Join(dst, "test.ts"))
	if err != nil {
		t.Fatalf("failed to read copied file: %v", err)
	}
	if string(data) != "const x = 1;" {
		t.Fatalf("file content mismatch: got %q", string(data))
	}

	data, err = os.ReadFile(filepath.Join(dst, "sub", "nested.ts"))
	if err != nil {
		t.Fatalf("failed to read nested file: %v", err)
	}
	if string(data) != "const y = 2;" {
		t.Fatalf("nested file content mismatch: got %q", string(data))
	}
}

func TestCopyFile(t *testing.T) {
	src := t.TempDir()
	dst := t.TempDir()

	srcFile := filepath.Join(src, "test.ts")
	dstFile := filepath.Join(dst, "test.ts")

	os.WriteFile(srcFile, []byte("hello"), 0644)

	if err := copyFile(srcFile, dstFile); err != nil {
		t.Fatalf("copyFile failed: %v", err)
	}

	data, err := os.ReadFile(dstFile)
	if err != nil {
		t.Fatalf("failed to read copied file: %v", err)
	}
	if string(data) != "hello" {
		t.Fatalf("file content mismatch: got %q", string(data))
	}
}
