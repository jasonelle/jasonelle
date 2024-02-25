# Legacy Jasonelle iOS

This is an old version of Jasonelle. No new features will be added or provide much support.
Only some small fixes so it will compile with more recent SDKs.

This version is only available to those who need _JSON_ support.

- [Legacy Docs](https://jasonelle-archive.github.io/docs/legacy/)
- [Legacy Wiki](https://github.com/jasonelle-archive/jasonelle-v2/wiki)

## Embed your Website

This version uses *JSON* instead of *Javascript* for configuration.

You can also follow the _Xcode_ instructions:https://jasonelle-archive.github.io/docs/legacy/ios/

Edit `hello.json` with the following json.

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
