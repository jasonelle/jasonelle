import Color from "color";

// Creates an object that is JSON encodable
// And can be used with the UIColor primitive
const Factory = (color, alpha = 255) => ({
    a: alpha,
    ...Color(color).alpha(alpha).rgb().object(),
});

export { Color };
export { Factory };

export default { Color, Factory };
