return {
   menu = {components = {connector = 1}},
   pages = {
      ["connector"] = function(data)
         data.element.add {type = "label", caption = {"pc-docs.page_connector_text_1"}}
      end,
   },
}
