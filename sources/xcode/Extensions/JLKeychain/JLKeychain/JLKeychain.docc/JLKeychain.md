# ``JLKeychain``

Keychain extension allows storing values inside [_iOS Keychain_](https://developer.apple.com/documentation/security/keychain_services?language=objc)

- Since: `3.0.1`

## Overview

Keychain is made as a key - value secure storage.


## Topics

### Actions

- ``$keychain.set``: Sets a key to store a value.
- ``$keychain.get``: Gets the value for a given key.
- ``$keychain.remove``: Removes a key from the keychain.
- ``$keychain.clear``: Removes all keys and values from the keychain.

### Example

```js
// Stores the number 3 in keychain
$keychain.set('number', 3);

// Get the number 3 and show an alert with it
$keychain.get('number').then(num => alert(num));

// Removes the stored number
$keychain.remove('number');

// Clears the keychain
$keychain.clear();
```

