return {
   menu = {components = {memory = 1}},
   pages = {
      ["memory"] = function(data)
         data.element.add {type = "label", caption = {"pc-docs.page_memory_text_1"}}
      end,
   },
}
