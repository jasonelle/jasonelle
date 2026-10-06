package main

import (
	"os"
	"path/filepath"
	"strings"
	"testing"
)

func TestRubyValue(t *testing.T) {
	tests := []struct {
		name string
		in   any
		want string
	}{
		{"string", "internal", `"internal"`},
		{"quoted string", `say "hi"`, `"say \"hi\""`},
		{"true", true, "true"},
		{"false", false, "false"},
		{"integer", float64(1), "1"},
		{"fraction", float64(1.5), "1.5"},
		{"hash sorted", map[string]any{"b": false, "a": true}, "{\n  a: true,\n  b: false\n}"},
	}
	for _, tc := range tests {
		if got := rubyValue(tc.in); got != tc.want {
			t.Errorf("%s: rubyValue(%v) = %q, want %q", tc.name, tc.in, got, tc.want)
		}
	}
}

const xcodeConfig = `{
  "appfile": {
    "app_identifier": "com.example.application",
    "apple_id": "developer@example.com",
    "itc_team_id": "12345678",
    "team_id": "XXXXXXXXXX",
    "team_name": "Example Team"
  },
  "deliver": {
    "app_rating_config_path": "lib/xcode/config/rating.json",
    "edit_live": false,
    "force": false,
    "phased_release": true,
    "platform": "ios",
    "price_tier": 0,
    "reset_ratings": false,
    "skip_app_version_update": false,
    "skip_binary_upload": false,
    "skip_metadata": false,
    "skip_screenshots": false,
    "submission_information": {
      "export_compliance_uses_encryption": false,
      "add_id_info_uses_idfa": false
    }
  },
  "gym": {
    "clean": true,
    "export_method": "app-store",
    "scheme": "Application"
  },
  "match": {
    "git_url": "git@github.com:example/certificates.git",
    "readonly": true,
    "shallow_clone": true,
    "storage_mode": "git",
    "type": "appstore"
  },
  "metadata": {
    "default_language": "en-US",
    "en-US": {
      "title": "Jasonelle v4",
      "subtitle": "Web to Native Wrapper",
      "promotional_text": "Experience Jasonelle v4.",
      "description": "The full description.",
      "keywords": "jasonelle, mobile",
      "privacy_url": "https://jasonelle.com/privacy",
      "support_url": "https://jasonelle.com/support",
      "marketing_url": "https://jasonelle.com",
      "release_notes": "Initial release of Jasonelle v4."
    }
  }
}`

const androidConfig = `{
  "appfile": {
    "package_name": "com.example.application",
    "json_key_file": "lib/android/config/play-store-key.json"
  },
  "supply": {
    "track": "internal",
    "rollout": 1.0,
    "skip_upload_apk": true,
    "skip_upload_aab": false,
    "skip_upload_metadata": false,
    "skip_upload_changelogs": false,
    "skip_upload_images": false,
    "skip_upload_screenshots": false,
    "validate_only": false,
    "changes_not_sent_for_review": false,
    "ack_bundle_installation_warning": true
  },
  "metadata": {
    "default_language": "en-US",
    "en-US": {
      "title": "Jasonelle v4",
      "description": "The full description.",
      "short_description": "Build native apps with web technologies.",
      "video": "https://www.youtube.com/watch?v=example",
      "release_notes": "Initial release of Jasonelle v4."
    }
  },
  "gradle": {
    "task": "bundleRelease",
    "build_type": "Release"
  }
}`

func parse(t *testing.T, content string) map[string]any {
	t.Helper()
	cfg, err := parseConfigJSON([]byte(content))
	if err != nil {
		t.Fatalf("parse: %v", err)
	}
	return cfg
}

func TestRenderXcode(t *testing.T) {
	dir := t.TempDir()
	if err := renderXcode(parse(t, xcodeConfig), dir); err != nil {
		t.Fatalf("renderXcode: %v", err)
	}

	wantFile(dir, t, filepath.Join("Appfile"), `app_identifier("com.example.application")
apple_id("developer@example.com")
team_id("XXXXXXXXXX")
itc_team_id("12345678")
team_name("Example Team")
`)
	wantFile(dir, t, filepath.Join("Deliverfile"), `platform("ios")
edit_live(false)
skip_binary_upload(false)
skip_screenshots(false)
skip_metadata(false)
skip_app_version_update(false)
force(false)
phased_release(true)
reset_ratings(false)
price_tier(0)
app_rating_config_path("lib/xcode/config/rating.json")
submission_information({
  add_id_info_uses_idfa: false,
  export_compliance_uses_encryption: false
})
`)
	wantFile(dir, t, filepath.Join("Matchfile"), `type("appstore")
storage_mode("git")
git_url("git@github.com:example/certificates.git")
shallow_clone(true)
readonly(true)
`)
	wantFile(dir, t, filepath.Join("Fastfile"), `default_platform(:ios)

platform :ios do
  desc "Sync signing certificates"
  lane :certificates do
    match(
      type: "appstore",
      storage_mode: "git",
      git_url: "git@github.com:example/certificates.git",
      shallow_clone: true,
      readonly: true
    )
  end

  desc "Build and archive the iOS application"
  lane :build do
    certificates
    gym(
      scheme: "Application",
      clean: true,
      export_method: "app-store"
    )
  end

  desc "Deploy a new version to the Apple App Store"
  lane :release do
    build
    deliver(
      platform: "ios",
      edit_live: false,
      skip_binary_upload: false,
      skip_screenshots: false,
      skip_metadata: false,
      skip_app_version_update: false,
      force: false,
      phased_release: true,
      reset_ratings: false,
      price_tier: 0,
      app_rating_config_path: "lib/xcode/config/rating.json",
      submission_information: {
  add_id_info_uses_idfa: false,
  export_compliance_uses_encryption: false
}
    )
  end
end
`)
	wantFile(dir, t, filepath.Join("metadata", "en-US", "name.txt"), "Jasonelle v4")
	wantFile(dir, t, filepath.Join("metadata", "en-US", "subtitle.txt"), "Web to Native Wrapper")
	wantFile(dir, t, filepath.Join("metadata", "en-US", "release_notes.txt"), "Initial release of Jasonelle v4.")
	if _, err := os.Stat(filepath.Join(dir, "metadata", "en-US", "changelogs")); !os.IsNotExist(err) {
		t.Errorf("xcode metadata must not contain a changelogs directory")
	}
}

func TestRenderAndroid(t *testing.T) {
	dir := t.TempDir()
	if err := renderAndroid(parse(t, androidConfig), dir); err != nil {
		t.Fatalf("renderAndroid: %v", err)
	}

	wantFile(dir, t, filepath.Join("Appfile"), `json_key_file("lib/android/config/play-store-key.json")
package_name("com.example.application")
`)
	wantFile(dir, t, filepath.Join("Supplyfile"), `track("internal")
rollout(1)
skip_upload_apk(true)
skip_upload_aab(false)
skip_upload_metadata(false)
skip_upload_changelogs(false)
skip_upload_images(false)
skip_upload_screenshots(false)
validate_only(false)
changes_not_sent_for_review(false)
ack_bundle_installation_warning(true)
`)
	wantFile(dir, t, filepath.Join("Fastfile"), `default_platform(:android)

platform :android do
  desc "Build the Android App Bundle"
  lane :build do
    gradle(
      task: "bundleRelease",
      build_type: "Release"
    )
  end

  desc "Deploy a new version to the Google Play Store"
  lane :release do
    build
    supply(
      track: "internal",
      rollout: 1,
      skip_upload_apk: true,
      skip_upload_aab: false,
      skip_upload_metadata: false,
      skip_upload_changelogs: false,
      skip_upload_images: false,
      skip_upload_screenshots: false,
      validate_only: false,
      changes_not_sent_for_review: false,
      ack_bundle_installation_warning: true
    )
  end
end
`)
	wantFile(dir, t, filepath.Join("metadata", "android", "en-US", "title.txt"), "Jasonelle v4")
	wantFile(dir, t, filepath.Join("metadata", "android", "en-US", "full_description.txt"), "The full description.")
	wantFile(dir, t, filepath.Join("metadata", "android", "en-US", "video.txt"), "https://www.youtube.com/watch?v=example")
	wantFile(dir, t, filepath.Join("metadata", "android", "en-US", "changelogs", "default.txt"), "Initial release of Jasonelle v4.")
}

func TestRenderIdempotent(t *testing.T) {
	first := t.TempDir()
	second := t.TempDir()
	if err := renderXcode(parse(t, xcodeConfig), first); err != nil {
		t.Fatalf("first renderXcode: %v", err)
	}
	if err := renderXcode(parse(t, xcodeConfig), second); err != nil {
		t.Fatalf("second renderXcode: %v", err)
	}
	assertDirEqual(t, first, second)
}

func TestMissingPathFileFallback(t *testing.T) {
	dir := t.TempDir()
	cfg := parse(t, androidConfig)
	if err := copyPathFiles("android", cfg, dir); err != nil {
		t.Fatalf("copyPathFiles: %v", err)
	}
	// play-store-key.json does not exist, so the value stays literal.
	if got := cfg["appfile"].(map[string]any)["json_key_file"]; got != "lib/android/config/play-store-key.json" {
		t.Errorf("json_key_file = %v, want literal value", got)
	}
	if _, err := os.Stat(filepath.Join(dir, "play-store-key.json")); !os.IsNotExist(err) {
		t.Errorf("key file must not be copied when missing")
	}
}

func TestCopyPathFiles(t *testing.T) {
	dir := t.TempDir()
	key := filepath.Join(dir, "play-store-key.json")
	if err := os.WriteFile(key, []byte(`{"type":"service_account"}`), 0644); err != nil {
		t.Fatal(err)
	}
	cfg := parse(t, androidConfig)
	cfg["appfile"].(map[string]any)["json_key_file"] = key
	if err := copyPathFiles("android", cfg, dir); err != nil {
		t.Fatalf("copyPathFiles: %v", err)
	}
	if got := cfg["appfile"].(map[string]any)["json_key_file"]; got != "play-store-key.json" {
		t.Errorf("json_key_file = %v, want basename", got)
	}
	wantFile(dir, t, filepath.Join("play-store-key.json"), `{"type":"service_account"}`)
}

func TestRunIntegration(t *testing.T) {
	root := t.TempDir()
	write := func(name, content string) {
		t.Helper()
		p := filepath.Join(root, name)
		if err := os.MkdirAll(filepath.Dir(p), 0755); err != nil {
			t.Fatal(err)
		}
		if err := os.WriteFile(p, []byte(content), 0644); err != nil {
			t.Fatal(err)
		}
	}
	write(filepath.Join("xcode", "config", "store.jsonc"), xcodeConfig)
	write(filepath.Join("android", "config", "store.jsonc"), androidConfig)

	err := run([]string{
		"--xcode-config", filepath.Join(root, "xcode", "config", "store.jsonc"),
		"--android-config", filepath.Join(root, "android", "config", "store.jsonc"),
		"--xcode-out", filepath.Join(root, "xcode", "fastlane"),
		"--android-out", filepath.Join(root, "android", "fastlane"),
		"--xcode-sources", filepath.Join(root, "xcode", "sources"),
		"--android-sources", filepath.Join(root, "android", "sources"),
	})
	if err != nil {
		t.Fatalf("run: %v", err)
	}

	wantFile(root, t, filepath.Join("xcode", "sources", "fastlane", "Fastfile"), mustRead(t, root, filepath.Join("xcode", "fastlane", "Fastfile")))
	wantFile(root, t, filepath.Join("android", "sources", "fastlane", "Fastfile"), mustRead(t, root, filepath.Join("android", "fastlane", "Fastfile")))
	wantFile(root, t, filepath.Join("xcode", "sources", "fastlane", "metadata", "en-US", "name.txt"), "Jasonelle v4")
	wantFile(root, t, filepath.Join("android", "sources", "fastlane", "metadata", "android", "en-US", "changelogs", "default.txt"), "Initial release of Jasonelle v4.")

	// Re-running leaves the mirrored sources byte-stable.
	before := mustRead(t, root, filepath.Join("xcode", "sources", "fastlane", "Fastfile"))
	if err := run([]string{
		"--xcode-config", filepath.Join(root, "xcode", "config", "store.jsonc"),
		"--android-config", filepath.Join(root, "android", "config", "store.jsonc"),
		"--xcode-out", filepath.Join(root, "xcode", "fastlane"),
		"--android-out", filepath.Join(root, "android", "fastlane"),
		"--xcode-sources", filepath.Join(root, "xcode", "sources"),
		"--android-sources", filepath.Join(root, "android", "sources"),
	}); err != nil {
		t.Fatalf("second run: %v", err)
	}
	if after := mustRead(t, root, filepath.Join("xcode", "sources", "fastlane", "Fastfile")); after != before {
		t.Errorf("second run changed mirrored Fastfile")
	}
}

func wantFile(base string, t *testing.T, rel, want string) {
	t.Helper()
	got := mustRead(t, base, rel)
	if got != want {
		t.Errorf("%s content:\n%s\nwant:\n%s", rel, got, want)
	}
}

func mustRead(t *testing.T, base, rel string) string {
	t.Helper()
	data, err := os.ReadFile(filepath.Join(base, rel))
	if err != nil {
		t.Fatalf("read %s: %v", rel, err)
	}
	return string(data)
}

func assertDirEqual(t *testing.T, a, b string) {
	t.Helper()
	walk := func(dir string) map[string]string {
		files := map[string]string{}
		err := filepath.Walk(dir, func(path string, info os.FileInfo, err error) error {
			if err != nil {
				return err
			}
			if info.IsDir() {
				return nil
			}
			rel, err := filepath.Rel(dir, path)
			if err != nil {
				return err
			}
			data, err := os.ReadFile(path)
			if err != nil {
				return err
			}
			files[rel] = string(data)
			return nil
		})
		if err != nil {
			t.Fatalf("walk %s: %v", dir, err)
		}
		return files
	}
	fa, fb := walk(a), walk(b)
	for rel, content := range fa {
		if fb[rel] != content {
			t.Errorf("%s differs between renders", rel)
		}
	}
	for rel := range fb {
		if _, ok := fa[rel]; !ok {
			t.Errorf("%s only present in second render", rel)
		}
	}
}

func TestStripJSONC(t *testing.T) {
	in := `// comment
{ "a": 1, /* block */ "b": "x // y", "c": 2, }`
	out := string(stripJSONC([]byte(in)))
	if !strings.Contains(out, `"b": "x // y"`) {
		t.Errorf("string content stripped: %s", out)
	}
	if strings.Contains(out, "comment") {
		t.Errorf("line comment kept: %s", out)
	}
	if strings.Contains(out, "block") {
		t.Errorf("block comment kept: %s", out)
	}
	if strings.Contains(out, ",}") {
		t.Errorf("trailing comma kept: %s", out)
	}
}
