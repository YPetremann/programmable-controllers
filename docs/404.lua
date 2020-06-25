local addons = require("__programmable-controllers__.control.addon_base")

return {
   menu = {},
   pages = {
      ["404"] = function(data)
         data.element.add {type = "label", caption = "Error 404: not found", style = "heading_1_label"}
         data.element.add {type = "label", caption = "the requested page \"" .. data.page_name .. "\" is not found"}
      end,
   },
}
