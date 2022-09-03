// Polyfills must be added before loading app.js, so it will not be bundled with esbuild
// must manually add the deps until another solution is found

// self executing function to avoid polluting main context
(() => {
    // Deps
    const Logger = __com_jasonelle_bridges_logger;

    const fastBase64Decode = (_source, _target) => {
        /*
         "name": "fast-base64-decode",
         "version": "1.0.0",
         "license": "MIT",
         "repository": "LinusU/fast-base64-decode",
        */
        const lookup = [
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            62,
            0,
            62,
            0,
            63,
            52,
            53,
            54,
            55,
            56,
            57,
            58,
            59,
            60,
            61,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            1,
            2,
            3,
            4,
            5,
            6,
            7,
            8,
            9,
            10,
            11,
            12,
            13,
            14,
            15,
            16,
            17,
            18,
            19,
            20,
            21,
            22,
            23,
            24,
            25,
            0,
            0,
            0,
            0,
            63,
            0,
            26,
            27,
            28,
            29,
            30,
            31,
            32,
            33,
            34,
            35,
            36,
            37,
            38,
            39,
            40,
            41,
            42,
            43,
            44,
            45,
            46,
            47,
            48,
            49,
            50,
            51,
        ];

        const base64Decode = (source, target) => {
            var sourceLength = source.length;
            var paddingLength = (source[sourceLength - 2] === "="
                ? 2
                : (source[sourceLength - 1] === "=" ? 1 : 0));

            var tmp;
            var byteIndex = 0;
            var baseLength = (sourceLength - paddingLength) & 0xfffffffc;

            for (var i = 0; i < baseLength; i += 4) {
                tmp = (lookup[source.charCodeAt(i)] << 18) |
                    (lookup[source.charCodeAt(i + 1)] << 12) |
                    (lookup[source.charCodeAt(i + 2)] << 6) |
                    (lookup[source.charCodeAt(i + 3)]);

                target[byteIndex++] = (tmp >> 16) & 0xFF;
                target[byteIndex++] = (tmp >> 8) & 0xFF;
                target[byteIndex++] = (tmp) & 0xFF;
            }

            if (paddingLength === 1) {
                tmp = (lookup[source.charCodeAt(i)] << 10) |
                    (lookup[source.charCodeAt(i + 1)] << 4) |
                    (lookup[source.charCodeAt(i + 2)] >> 2);

                target[byteIndex++] = (tmp >> 8) & 0xFF;
                target[byteIndex++] = tmp & 0xFF;
            }

            if (paddingLength === 2) {
                tmp = (lookup[source.charCodeAt(i)] << 2) |
                    (lookup[source.charCodeAt(i + 1)] >> 4);

                target[byteIndex++] = tmp & 0xFF;
            }
        };
        return base64Decode(_source, _target);
    };

    // Polyfill Code
    const Polyfill_getRandomValues =
        __com_jasonelle_polyfills_crypto_get_random_values;

    // Based on: https://raw.githubusercontent.com/LinusU/react-native-get-random-values/master/index.js

    // All functions in crypto will be exported to global
    const crypto = {};

    crypto.getRandomValues = (array) => {
        if (
            !(array instanceof Int8Array || array instanceof Uint8Array ||
                array instanceof Int16Array || array instanceof Uint16Array ||
                array instanceof Int32Array || array instanceof Uint32Array ||
                array instanceof Uint8ClampedArray)
        ) {
            throw new TypeMismatchError("Expected an integer array");
        }

        if (array.byteLength > 65536) {
            throw new QuotaExceededError(
                "Can only request a maximum of 65536 bytes",
            );
        }

        fastBase64Decode(
            Polyfill_getRandomValues(array.byteLength),
            new Uint8Array(array.buffer, array.byteOffset, array.byteLength),
        );

        return array;
    };

    // Export
    const Global = __com_jasonelle_bridges_app_global;
    if (typeof Global.crypto !== "object") {
        Global.crypto = crypto;
    }
})();
