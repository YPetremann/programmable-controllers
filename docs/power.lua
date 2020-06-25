return {
   menu = {components = {power = 1}},
   pages = {
      ["power"] = function(data)
         data.element.add {type = "label", caption = {"pc-docs.page_power_text_1"}}
      end,
   },
}
