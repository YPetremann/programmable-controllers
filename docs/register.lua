return {
   menu = {instructions = {register = 1}},
   pages = {
      ["register"] = function(data)
         data.element.add {type = "label", caption = {"pc-docs.page_register_text_1"}}
      end,
   },
}
