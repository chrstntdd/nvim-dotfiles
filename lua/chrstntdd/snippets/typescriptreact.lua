local ls = require("luasnip")
local fmt = require("luasnip.extras.fmt").fmt

local snippet = ls.snippet
local t = ls.text_node
local c = ls.choice_node
local i = ls.insert_node

local ts_tsx = {
  snippet({ trig = "cl", desc = "Print to the console" }, {
    t("console.log("),
    i(1),
    t(")"),
    i(0),
  }),

  snippet({ trig = "lmt", desc = "Lingui msg macro" }, {
    t("_(`"),
    i(1),
    t("`)"),
    i(0),
  }),

  snippet({ trig = "cn", desc = "className attribute as a string literal" }, {
    t('className="'),
    i(1),
    t('"'),
    i(0),
  }),
  snippet({ trig = "cn`", desc = "className attribute as a template string" }, {
    t("className={`${"),
    i(1),
    t("}`}"),
    i(0),
  }),
  snippet({ trig = "cnx", desc = "className attribute with clsx" }, {
    t("className={clsx(["),
    i(1),
    t("])}"),
    i(0),
  }),
  snippet({ trig = "pp", desc = "Pretty print recursively" }, {
    t("console.dir("),
    i(1),
    t(", { depth: Infinity }"),
    t(")"),
    i(0),
  }),
  snippet(
    { trig = "ReL", desc = "A Remix loader" },
    fmt(
      [[
export async function loader(args: LoaderFunctionArgs) {{
  return {returnType}
}}
      ]],
      {
        returnType = c(1, {
          t("json({ some: {ob: 'ject'} })"),
          t("defer({ some: prom })"),
        }),
      }
    )
  ),
  snippet(
    { trig = "dc", desc = "JS[D]oc [C]omment" },

    fmt(
      [[
/**
 * @{tag}
 *  {content}
 */
      ]],
      { tag = i(1), content = i(0) }
    )
  ),

  snippet(
    { trig = "imp", desc = "Import" },
    fmt(
      [[
import {importClause} from "{moduleSpecifier}"
  ]],
      {
        importClause = c(1, {
          t("* as "),
          t("{{ }}"),
        }),
        moduleSpecifier = i(0),
      }
    )
  ),

  snippet({ trig = "esld", desc = "ESLint disable next line" },
    t("// eslint-disable-next-line")
  ),

  snippet({ trig = "eslD", desc = "ESLint disable" },
    t("/* eslint-disable */")
  )

}

ls.add_snippets("typescript", ts_tsx)
ls.add_snippets("typescriptreact", ts_tsx)
