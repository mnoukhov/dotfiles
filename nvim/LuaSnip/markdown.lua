local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

return {
    -- {{< blockquote author="..." cite="..." >}}
    s("bq", {
        t('{{< blockquote author="'), i(1, ""), t('" cite="'), i(2, ""), t('" >}}'),
        t({ "", "" }), i(3, ""),
        t({ "", "{{< /blockquote >}}" }),
    }),

    -- {{< div class="..." >}}
    s("div", {
        t('{{< div class="'), i(1, ""), t('" >}}'),
        t({ "", "" }), i(2, ""),
        t({ "", "{{< /div >}}" }),
    }),

    -- {{< epigraph pre="..." cite="..." post="..." >}}
    s("ep", {
        t('{{< epigraph pre="'), i(1, ""), t('" cite="'), i(2, ""), t('" post="'), i(3, ""), t('" >}}'),
        t({ "", "" }), i(4, ""),
        t({ "", "{{< /epigraph >}}" }),
    }),

    -- {{< marginnote ind="†" >}}...{{< /marginnote >}}
    s("mn", {
        t('{{< marginnote ind="'), i(1, "†"), t('" >}}'),
        i(2, ""), t("{{< /marginnote >}}"),
    }),

    -- {{< sidenote ind="1" >}}...{{< /sidenote >}}
    s("sn", {
        t('{{< sidenote ind="'), i(1, "1"), t('" >}}'),
        i(2, ""), t("{{< /sidenote >}}"),
    }),
}
