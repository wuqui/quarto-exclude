-- Exclude filter for Quarto
-- Removes .excl elements when params.show_excl is false
-- Keeps them when params.show_excl is true (default)
--
-- Usage in document:
--   ::: {.excl}
--   [content to exclude]
--   :::
--
--   [inline content]{.excl}
--
--   ## Header {.excl}
--
-- Control visibility in YAML frontmatter:
--   params:
--     show_excl: false  # hide .excl content

local show_excl = true  -- default: show everything

local function has_class(el, name)
  for _, class in ipairs(el.classes) do
    if class == name then
      return true
    end
  end
  return false
end

function Meta(meta)
  if meta.params and meta.params.show_excl == false then
    show_excl = false
  end
  return meta
end

function Div(el)
  if has_class(el, "excl") and not show_excl then
    return {}
  end
  return el
end

function Span(el)
  if has_class(el, "excl") and not show_excl then
    return {}
  end
  return el
end

function Header(el)
  if has_class(el, "excl") and not show_excl then
    return {}
  end
  return el
end

return {
  { Meta = Meta },
  { Div = Div, Span = Span, Header = Header }
}
