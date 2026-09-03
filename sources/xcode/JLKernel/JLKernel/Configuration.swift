import Foundation

struct AppConfiguration: Decodable {
    let url: URL
    // Add any other configuration properties you need here
}

enum ConfigurationError: Error {
    case fileNotFound
    case decodingError(Error)
}

class ConfigurationLoader {
    static func load(from url: URL? = Bundle.main.url(forResource: "config", withExtension: "jsonc")) throws -> AppConfiguration {
        // Look for config.jsonc in the main app bundle by default
        guard let url = url else {
            throw ConfigurationError.fileNotFound
        }
        let data = try Data(contentsOf: url)
        return try decode(data: data)
    }
    
    // Extracted for unit testing
    static func decode(data: Data) throws -> AppConfiguration {
        let decoder = JSONDecoder()
        let cleanData = stripJSONCComments(data)
        if #available(iOS 15.0, macOS 12.0, *) {
            decoder.allowsJSON5 = true
        }

        do {
            return try decoder.decode(AppConfiguration.self, from: cleanData)
        } catch {
            throw ConfigurationError.decodingError(error)
        }
    }

    // ponytail: handles // and /* */ outside strings; good enough for config files
    private static func stripJSONCComments(_ data: Data) -> Data {
        guard let str = String(data: data, encoding: .utf8) else { return data }
        var result = ""
        var i = str.startIndex
        var inString = false
        var escaped = false

        while i < str.endIndex {
            let c = str[i]

            if escaped {
                escaped = false
                result.append(c)
                i = str.index(after: i)
                continue
            }

            if c == "\\" && inString {
                escaped = true
                result.append(c)
                i = str.index(after: i)
                continue
            }

            if c == "\"" {
                inString.toggle()
                result.append(c)
                i = str.index(after: i)
                continue
            }

            if !inString && c == "/" {
                let next = str.index(after: i)
                if next < str.endIndex {
                    let nc = str[next]
                    if nc == "/" {
                        if let newlineRange = str[i...].range(of: "\n") {
                            i = newlineRange.upperBound
                        } else {
                            i = str.endIndex
                        }
                        continue
                    } else if nc == "*" {
                        if let end = str.range(of: "*/", range: str.index(i, offsetBy: 2)..<str.endIndex) {
                            i = end.upperBound
                        } else {
                            i = str.endIndex
                        }
                        continue
                    }
                }
            }

            result.append(c)
            i = str.index(after: i)
        }

        return result.data(using: .utf8) ?? data
    }
}
