const Route = (path, render, options = {}) => {
    const item = {};
    // maybe process params from path
    // and options and pass it to the component function
    const params = { props: {}, options, path };
    const component = render(params);
    const out = {
        ...params,
        component,
    };

    item[path] = out;

    if (options) {
        if (options.name) {
            item[name] = out;
        }
    }

    return item;
};

export default Route;
