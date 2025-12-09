# Exclude

A Quarto extension for conditionally excluding content from rendered output.

Useful for teaching materials where you want to hide solutions, answers, or other content that should only be visible in certain versions of a document.

## Installation

```bash
quarto add wuqui/quarto-exclude
```

## Usage

Add the filter to your document or `_quarto.yml`:

```yaml
filters:
  - exclude
```

Mark content for exclusion using the `.excl` class:

### Inline content

```markdown
The answer is [42]{.excl}.
```

### Block content

```markdown
::: {.excl}
This entire block can be excluded.
:::
```

### Headers

```markdown
## Solution {.excl}
```

## Configuration

By default, all `.excl` content is **shown**. To hide it, set the `show_excl` parameter to `false`:

```yaml
params:
  show_excl: false
```

### Example workflow for teaching

1. Create materials with solutions marked as `.excl`
2. Set `params.show_excl: false` before class (students see version without solutions)
3. Set `params.show_excl: true` after class (solutions visible)

## Example

See `example.qmd` for a complete demonstration.

## Roadmap

Future features under consideration:

- **RevealJS modifiers:** `.excl .slide` (new slide before content) and `.excl .fragment` (reveal on click/pause)
- **Solution styling:** Subtle visual distinction for `.excl` content when shown (e.g., light background, border)

## License

MIT
