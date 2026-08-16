# Merge semantics

The JSON merger cascades files: the first positional input is the base and
each subsequent input deep-merges over the previous one, later files winning.

## Rules

1. Nested objects merge recursively.
2. Arrays are replaced wholesale.
3. Scalars are replaced wholesale.

## Example

Base:

```jsonc
{
  "colors": { "bg": "red", "accent": "blue" },
  "sizes": [1, 2],
  "name": "base"
}
```

Override:

```jsonc
{
  "colors": { "accent": "green", "fg": "white" },
  "sizes": [9]
}
```

Result:

```json
{
  "colors": { "accent": "green", "bg": "red", "fg": "white" },
  "sizes": [9],
  "name": "base"
}
```

`colors` merged recursively, `sizes` was replaced, and keys only present in the
base (`name`) are preserved.
