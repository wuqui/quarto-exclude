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
--   Content below header is also excluded (entire section)
--
-- Control visibility in YAML frontmatter:
--   params:
--     show_excl: false  # hide .excl content

-- Requires pandoc 2.8+ for pandoc.utils.make_sections
PANDOC_VERSION:must_be_at_least {2,8}

local utils = require 'pandoc.utils'
local show_excl = true  -- default: show everything

-- Helper: check if element has class
local function has_class(el, name)
  for _, class in ipairs(el.classes) do
    if class == name then
      return true
    end
  end
  return false
end

-- Helper: remove class from element
local function remove_class(el, name)
  local new_classes = {}
  for _, class in ipairs(el.classes) do
    if class ~= name then
      table.insert(new_classes, class)
    end
  end
  el.classes = new_classes
end

-- Helper: check if div is a section div created by make_sections
local function is_section_div(div)
  return div.t == 'Div'
    and div.classes[1] == 'section'
    and div.attributes.number
end

-- Helper: get header from section div
local function section_header(div)
  if not is_section_div(div) then return nil end
  local header = div.content and div.content[1]
  if header and header.t == 'Header' then
    return header
  end
  return nil
end

-- Pass 1: Read params from document metadata
function Meta(meta)
  if meta.params and meta.params.show_excl == false then
    show_excl = false
  end
  return meta
end

-- Pass 2: Setup - wrap all sections in Div elements
local function setup_document(doc)
  if show_excl then return nil end  -- skip processing if showing everything
  local sections = utils.make_sections(false, nil, doc.blocks)
  return pandoc.Pandoc(sections, doc.meta)
end

-- Pass 3: Remove section divs where header has .excl class
local function drop_excl_sections(div)
  if show_excl then return nil end
  local header = section_header(div)
  if header and has_class(header, "excl") then
    return {}
  end
end

-- Pass 4: Flatten remaining section divs back to normal structure
local function flatten_sections(div)
  if show_excl then return nil end
  local header = section_header(div)
  if not header then return nil end
  -- Preserve the section identifier on the header
  header.identifier = div.identifier
  div.content[1] = header
  return div.content
end

-- Pass 5: Remove standalone .excl divs and spans
local function remove_excl_div(el)
  if has_class(el, "excl") then
    if not show_excl then
      return {}  -- remove when hiding
    end
    -- When showing, handle modifiers
    if has_class(el, "slide") then
      remove_class(el, "slide")
      remove_class(el, "excl")
      return { pandoc.HorizontalRule(), el }
    end
    -- .fragment stays on element (RevealJS handles it)
    if has_class(el, "fragment") then
      remove_class(el, "excl")  -- remove .excl class, keep .fragment
      return el  -- return modified element
    else
      remove_class(el, "excl")  -- remove .excl class if no modifiers
      return el  -- return modified element
    end
  end
  return nil  -- no modification needed
end

local function remove_excl_span(el)
  if has_class(el, "excl") then
    if not show_excl then
      return {}  -- remove when hiding
    end
    -- When showing, remove .excl class (fragment class stays for RevealJS)
    remove_class(el, "excl")
    return el
  end
  return nil  -- no modification needed
end

return {
  { Meta = Meta },
  { Pandoc = setup_document },
  { Div = drop_excl_sections },
  { Div = flatten_sections },
  { Div = remove_excl_div, Span = remove_excl_span }
}
