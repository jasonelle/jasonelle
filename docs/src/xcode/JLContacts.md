# ``JLContacts``

The Contacts extension provides APIs to access the user’s contact information. 

- Since: `3.0.1`

## Overview

An iOS app linked on or after iOS 10 needs to include in its `Info.plist` file the usage description keys for the types of data it needs to access or it crashes. To access Contacts data specifically, it needs to include `NSContactsUsageDescription`.

### More Info

- [Contacts Framework](https://developer.apple.com/documentation/contacts?language=objc)
- [NSContactsUsageDescription](https://developer.apple.com/library/archive/documentation/General/Reference/InfoPlistKeyReference/Articles/CocoaKeys.html#//apple_ref/doc/uid/TP40009251-SW14)

## Topics

### Schema

```txt
"name": String,
"lastname": String,
"phone": String,
"phones": Array,
"email": String,
"emails: Array,
"address": String,
"addresses": Array
```

### Actions

#### ``$contacts.all()``
Returns a `promise` with all the contacts.

- Since 3.0.1


- Return

```json
[{
    "phone": "5555648583",
    "phones": ["5555648583", "4155553695"],
    "emails": ["kate-bell@mac.com"],
    "address": "165 Davis Street\nHillsborough CA 94010",
    "lastname": "Bell",
    "addresses": ["165 Davis Street\nHillsborough CA 94010"],
    "email": "kate-bell@mac.com",
    "name": "Kate"
}, {
    "phone": "5554787672",
    "phones": ["5554787672", "4085555270", "4085553514"],
    "emails": ["d-higgins@mac.com"],
    "address": "332 Laguna Street\nCorte Madera CA 94925\nUSA",
    "lastname": "Higgins",
    "addresses": ["332 Laguna Street\nCorte Madera CA 94925\nUSA"],
    "email": "d-higgins@mac.com",
    "name": "Daniel"
}, {
    "phone": "8885555512",
    "phones": ["8885555512", "8885551212"],
    "emails": ["John-Appleseed@mac.com"],
    "address": "3494 Kuhl Avenue\nAtlanta GA 30303\nUSA",
    "lastname": "Appleseed",
    "addresses": ["3494 Kuhl Avenue\nAtlanta GA 30303\nUSA", "1234 Laurel Street\nAtlanta GA 30303\nUSA"],
    "email": "John-Appleseed@mac.com",
    "name": "John"
}, {
    "phone": "5555228243",
    "phones": ["5555228243"],
    "emails": ["anna-haro@mac.com"],
    "address": "1001  Leavenworth Street\nSausalito CA 94965\nUSA",
    "lastname": "Haro",
    "addresses": ["1001  Leavenworth Street\nSausalito CA 94965\nUSA"],
    "email": "anna-haro@mac.com",
    "name": "Anna"
}, {
    "phone": "5557664823",
    "phones": ["5557664823", "7075551854"],
    "emails": ["hank-zakroff@mac.com"],
    "address": "1741 Kearny Street\nSan Rafael CA 94901",
    "lastname": "Zakroff",
    "addresses": ["1741 Kearny Street\nSan Rafael CA 94901"],
    "email": "hank-zakroff@mac.com",
    "name": "Hank"
}, {
    "phone": "5556106679",
    "phones": ["5556106679"],
    "emails": [],
    "address": "1747 Steuart Street\nTiburon CA 94920\nUSA",
    "lastname": "Taylor",
    "addresses": ["1747 Steuart Street\nTiburon CA 94920\nUSA"],
    "email": "",
    "name": "David"
}]
```

#### ``$contacts.authorize()``
Starts the authorization flow. Returns an Promise. Resolves with object with the authorization status. Rejects with an error message. 

- Since 3.0.2
- Schema

```json
"granted": "Bool",
"status": {
    "id": "CNAuthorizationStatus",
    "name": "String"
}
```

`status.id` referes to [CNAuthorizationStatus](https://developer.apple.com/documentation/contacts/cnauthorizationstatus?language=objc).

### Examples

**Alert**

Join all the contacts by the first name in a single string.
And present an alert.

```js
$contacts.all().then(val => alert(val.reduce((acc, v) => acc + v.name + ' ', '')))
```

**Log**

Logs the resulting object.

```js
$contacts.all().then(info => $logger.trace(JSON.stringify(info)))
```

**Authorize**

```js
const authorizeContacts = () => $contacts.authorize().then(res => alert(res.status.name));
```
