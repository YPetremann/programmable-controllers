return {
   menu = {components = {cpu = 1}},
   pages = {
      ["cpu"] = function(data)
         data.element.add {type = "label", caption = {"pc-docs.page_cpu_text_1"}}
      end,
   },
}
