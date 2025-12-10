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

When a header has `.excl`, the entire section (including all content and subsections) is excluded:

```markdown
## Solution {.excl}
Content in this section is excluded.
### Subsection
This subsection is also excluded.
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

## RevealJS Modifiers

The extension supports RevealJS-specific modifiers for presentations:

### Slide modifier

Use `.excl .slide` to create a new slide before the excluded content:

```markdown
::: {.excl .slide}
Solution content appears on a new slide.
:::
```

### Fragment modifier

Use `.excl .fragment` to reveal content as a RevealJS fragment:

```markdown
The answer is [42]{.excl .fragment}
```

## Styling

By default, `.excl` content is styled with subtle visual indicators when shown:

- **Inline content** (spans): Blue underline
- **Block content** (divs): Blue left border with padding
- **Headings**: 
  - **HTML format**: Blue left border with padding
  - **RevealJS format**: Blue underline (simplified for presentations)
- **Sections** (HTML only): When a heading has `.excl`, the entire section (including all content and subsections) gets a blue left border

The styling uses a medium blue color (`#3b82f6`) that works well in both light and dark modes, automatically adjusting to a lighter shade in dark mode.

### Customizing Styling

The styling is enabled by default. To disable it, set the `excl-style.enabled` parameter to `false`:

```yaml
params:
  show_excl: true
  excl-style:
    enabled: false
```

Alternatively, you can add the `excl-style-disabled` class to the `<body>` tag in your HTML template, or override the CSS in your own stylesheet.

To customize the color, override the CSS variable in your own CSS file:

```css
:root {
  --excl-color: #your-color;
}
```

### Overriding Styles

You can override the default styles by adding custom CSS to your document or project CSS file:

```css
:root {
  --excl-color: #your-color;
  --excl-border-width: 4px;
  --excl-heading-border-width: 5px;
  --excl-padding: 1.5em;
  --excl-heading-padding: 1em;
  --excl-margin: 0.5em;
  --excl-underline-thickness: 2px;
}
```

The extension uses CSS custom properties (variables) that you can override in your own stylesheets. Available variables:

- `--excl-color`: Color for borders and underlines (default: `#3b82f6`)
- `--excl-border-width`: Width of border for divs (default: `3px`)
- `--excl-heading-border-width`: Width of border for sections (default: `4px`)
- `--excl-padding`: Left padding for divs (default: `1em`)
- `--excl-heading-padding`: Left padding for sections (default: `0.75em`)
- `--excl-margin`: Left margin for divs (default: `0.5em`)
- `--excl-underline-thickness`: Thickness of underline for spans (default: `2px`)

## License

MIT
