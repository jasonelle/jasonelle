import Foundation

public struct AppConfiguration: Decodable {
    let url: URL // The url that will load as the main url for the app
    let inspectable: Bool? // Makes the webview inspectable in Safari web console
    let allowed: [String]? // List of allowed URLs that will not trigger SFSafariViewController. Empty or nil = all URLs load in webview. Non-empty = only listed URLs stay in webview, others open Safari sheet.
    // Add any other configuration properties you need here
  
  public init(url: URL, inspectable: Bool = true, allowed: [String] = []) {
      self.url = url
      self.inspectable = inspectable
      self.allowed = allowed
    }
}

enum ConfigurationError: Error {
    case fileNotFound
    case decodingError(Error)
}

class ConfigurationLoader {
  
    private static let logger: Logger = Logger(from: type(of: ConfigurationLoader.self))
  
    static func load(from url: URL? = Bundle.main.url(forResource: "config", withExtension: "jsonc")) throws -> AppConfiguration {
        // Look for config.jsonc in the main app bundle by default
        guard let url = url else {
            throw ConfigurationError.fileNotFound
        }
        let data = try Data(contentsOf: url)
        let decoded = try decode(data: data)
        logger.info("Successfully loaded configuration")
        logger.debug("\(decoded)")
        return decoded
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
