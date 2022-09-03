import UUID from "./uuid";

class Component {
    // Every component must have a unique identifier
    // TODO: Improve crypto polyfill for this to work
    __id = UUID();

    // Store other properties
    __props = {};
}

export default Component;
