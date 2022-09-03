# Logger

This is a small logging system based of [Swift Log](https://apple.github.io/swift-log/docs/current/Logging/index.html) which is a _Swift_ logging API package.

## UML

![Logging System UML](https://dev-to-uploads.s3.amazonaws.com/uploads/articles/91by877qhdijymnll1cr.png)

## Main Components

### [LoggingSystem](https://apple.github.io/swift-log/docs/current/Logging/Enums/LoggingSystem.html)

The main façade. It can only booted once with a Logger instance.

### [Logger](https://apple.github.io/swift-log/docs/current/Logging/Structs/Logger.html)

This will call the _LogHandler_ instance with the proper log level and other params provided by the caller.

### [LogHandler](https://apple.github.io/swift-log/docs/current/Logging/Protocols/LogHandler.html)

A protocol which the log handlers must implement. It mainly contains a log function to pass the params.

### [MultiplexLogHandler](https://apple.github.io/swift-log/docs/current/Logging/Structs/MultiplexLogHandler.html)

An implementation of the LogHandler protocol. Can pass the log message to other log handlers. Useful if you wish to log messages to local and remote systems using different handlers.

### [StreamLogHandler](https://apple.github.io/swift-log/docs/current/Logging/Structs/StreamLogHandler.html)

An implementation of the LogHandler protocol that sends the messages to standard output or standard error.
