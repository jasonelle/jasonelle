# Legacy Jasonelle Android

This is an old version of Jasonelle. No new features will be added or provide much support. 
Only some small fixes so it will compile with more recent SDKs.

This version would be totally deprecated when `v3` is launched in the future.

- [Legacy Docs](https://jasonelle-archive.github.io/docs/legacy/)
- [Legacy Wiki](https://github.com/jasonelle-archive/jasonelle-v2/wiki)

## Embed your Website

This version uses *JSON* instead of *Javascript* for configuration.

You can also follow the _Android_ instructions: https://jasonelle-archive.github.io/docs/legacy/android/

Edit `assets/file/hello.json` with the following json.

```json
{
    "$jason": {
        "body": {
            "background": {
                "type": "html",
                "url": "https://your-website-url",
                "style": {
                    "background": "#ffffff",
                    "progress" : "rgba(0,0,0,0)"
                },
                "action": {
                    "type": "$default"
                }
            }
        }
    }
}
```

- Check `AndroidManifest.xml` for additional settings.

## Updating SDK Versions

You can modify the SDK requirements so it using the latest minimum in build.gradle (app module).

Check in https://developer.android.com/google/play/requirements/target-sdk for the minimum
required SDK version.

![SDK](https://github.com/jasonelle/jasonelle/assets/292738/3159f09b-5447-4016-9233-bf8d25baf501)

Jasonelle should work fine from SDK 28 or up.
