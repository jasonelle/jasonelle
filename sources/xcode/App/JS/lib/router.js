// This file holds the endpoints
// For the app
import Lib from "./index";

// TODO: improve DSL for building routes
// Add to kernel
// ex: {"/": { props: {}, path: "/", component: Lib.Screens.Main() }}
const route = (path, element, props = {}) => ({
    path,
    component: element({ path, ...props }),
    props,
    element,
});

const routes = (items) => {
    const tree = {};
    items.forEach(item => {
        tree[item.path] = item;
    });
    return tree;
};

export default routes([
    route("/", Lib.Screens.Main),
]);
