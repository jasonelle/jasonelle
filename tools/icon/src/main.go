package main

import (
	"encoding/json"
	"flag"
	"fmt"
	"image"
	"image/png"
	"os"
	"path/filepath"

	"golang.org/x/image/draw"
)

type size struct {
	name string
	px   int
}

var androidLauncher = []size{
	{"mdpi", 48},
	{"hdpi", 72},
	{"xhdpi", 96},
	{"xxhdpi", 144},
	{"xxxhdpi", 192},
}

var xcodeIcons = []size{
	{"20", 20},
	{"29", 29},
	{"40", 40},
	{"58", 58},
	{"60", 60},
	{"76", 76},
	{"80", 80},
	{"87", 87},
	{"120", 120},
	{"152", 152},
	{"167", 167},
	{"180", 180},
	{"1024", 1024},
}

type appIconImage struct {
	Filename string `json:"filename"`
	Idiom    string `json:"idiom"`
	Scale    string `json:"scale"`
	Size     string `json:"size"`
}

type appIconSet struct {
	Images []appIconImage `json:"images"`
	Info   appIconInfo    `json:"info"`
}

type appIconInfo struct {
	Author  string `json:"author"`
	Version int    `json:"version"`
}

var appIconImages = []appIconImage{
	{"icon-20.png", "ipad", "1x", "20x20"},
	{"icon-40.png", "ipad", "2x", "20x20"},
	{"icon-29.png", "ipad", "1x", "29x29"},
	{"icon-58.png", "ipad", "2x", "29x29"},
	{"icon-40.png", "ipad", "1x", "40x40"},
	{"icon-80.png", "ipad", "2x", "40x40"},
	{"icon-76.png", "ipad", "1x", "76x76"},
	{"icon-152.png", "ipad", "2x", "76x76"},
	{"icon-167.png", "ipad", "2x", "83.5x83.5"},
	{"icon-40.png", "iphone", "2x", "20x20"},
	{"icon-60.png", "iphone", "3x", "20x20"},
	{"icon-58.png", "iphone", "2x", "29x29"},
	{"icon-87.png", "iphone", "3x", "29x29"},
	{"icon-80.png", "iphone", "2x", "40x40"},
	{"icon-120.png", "iphone", "3x", "40x40"},
	{"icon-120.png", "iphone", "2x", "60x60"},
	{"icon-180.png", "iphone", "3x", "60x60"},
	{"icon-1024.png", "ios-marketing", "1x", "1024x1024"},
}

func main() {
	source := flag.String("source", filepath.Join("lib", "common", "assets", "icon", "1024x1024.png"), "base 1024x1024 PNG icon")
	out := flag.String("out", "lib", "output root directory")
	flag.Parse()

	src, err := readPNG(*source)
	if err != nil {
		fatal(err)
	}
	if err := generateAndroid(src, filepath.Join(*out, "assets", "android")); err != nil {
		fatal(err)
	}
	if err := generateXcode(src, filepath.Join(*out, "assets", "xcode")); err != nil {
		fatal(err)
	}
}

func readPNG(path string) (image.Image, error) {
	f, err := os.Open(path)
	if err != nil {
		return nil, err
	}
	defer f.Close()
	return png.Decode(f)
}

func generateAndroid(src image.Image, dir string) error {
	for _, d := range androidLauncher {
		resDir := filepath.Join(dir, "res", "mipmap-"+d.name)
		if err := writeIcon(src, filepath.Join(resDir, "ic_launcher.png"), d.px); err != nil {
			return err
		}
		if err := writeIcon(src, filepath.Join(resDir, "ic_launcher_round.png"), d.px); err != nil {
			return err
		}
	}
	return writeIcon(src, filepath.Join(dir, "store", "icon-512.png"), 512)
}

func generateXcode(src image.Image, dir string) error {
	dir = filepath.Join(dir, "AppIcon.appiconset")
	for _, s := range xcodeIcons {
		if err := writeIcon(src, filepath.Join(dir, "icon-"+s.name+".png"), s.px); err != nil {
			return err
		}
	}
	data, err := json.MarshalIndent(appIconSet{
		Images: appIconImages,
		Info:   appIconInfo{Author: "xcode", Version: 1},
	}, "", "  ")
	if err != nil {
		return err
	}
	return os.WriteFile(filepath.Join(dir, "Contents.json"), append(data, '\n'), 0644)
}

func writeIcon(src image.Image, path string, px int) error {
	dst := resize(src, px)
	if err := os.MkdirAll(filepath.Dir(path), 0755); err != nil {
		return err
	}
	f, err := os.Create(path)
	if err != nil {
		return err
	}
	defer f.Close()
	return png.Encode(f, dst)
}

func resize(src image.Image, px int) *image.RGBA {
	dst := image.NewRGBA(image.Rect(0, 0, px, px))
	draw.CatmullRom.Scale(dst, dst.Bounds(), src, src.Bounds(), draw.Src, nil)
	return dst
}

func fatal(err error) {
	fmt.Fprintln(os.Stderr, err)
	os.Exit(1)
}
