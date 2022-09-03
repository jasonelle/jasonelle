// available via logger bridge
const Log = __com_jasonelle_bridges_logger;

const Level = {
    trace: "trace",
    debug: "debug",
    info: "info",
    notice: "notice",
    warning: "warning",
    error: "error",
    critical: "critical",
};

const Logger = {
    log(message, options = {
        func: null,
        line: null,
        source: "com.jasonelle.js.logger",
        console: true,
    }) {
        const params = { message, ...options };

        if (options.console) {
            if (options.source) {
                console.log(options.source, params);
            } else {
                console.log(params);
            }
        }

        Log(params);
        return params;
    },

    trace(
        message,
        options = {},
    ) {
        return this.log(message, { level: Level.trace, ...options });
    },

    debug(
        message,
        options = {},
    ) {
        return this.log(message, { level: Level.debug, ...options });
    },

    info(
        message,
        options = {},
    ) {
        return this.log(message, { level: Level.info, ...options });
    },

    notice(
        message,
        options = {},
    ) {
        return this.log(message, { level: Level.notice, ...options });
    },

    warning(
        message,
        options = {},
    ) {
        return this.log(message, { level: Level.warning, ...options });
    },

    error(
        message,
        options = {},
    ) {
        return this.log(message, { level: Level.error, ...options });
    },

    critical(
        message,
        options = {},
    ) {
        return this.log(message, { level: Level.critical, ...options });
    },
};

export { Level };
export { Logger };

export default Logger;
