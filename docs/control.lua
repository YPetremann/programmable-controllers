return {
   menu = {instructions = {control = 1}},
   pages = {
      ["control"] = function(data)
         data.element.add {type = "label", caption = {"pc-docs.page_control_text_1"}}
      end,
   },
}
