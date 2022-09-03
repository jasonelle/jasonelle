/*
Mappings to the
`localizedStringForKey:value:table:`

https://developer.apple.com/documentation/foundation/nsbundle/1417694-localizedstringforkey

Returns a localized version of the string designated by the specified key and residing in the specified table.

- If table is null, it will use the file named Localizable.strings
- Bundle is the bundle identifier string. If bundle is null, it will use [NSBundle mainBundle]
- value is the default value if the key is not found.
*/

const i18n = __com_jasonelle_bridges_i18n;

const trans = (key, value = null, options = { table: null, bundle: null }) =>
    i18n({ key, value, ...options });

export { trans };
export default trans;
