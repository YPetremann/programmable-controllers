return {
   menu = {},
   pages = {
      ["pc-docs"] = function(data)
         data.element.add {type = "label", caption = {"pc-docs.page_pc_docs_text_1"}}
         data.element.add {type = "label", caption = {"pc-docs.page_pc_docs_head_2"}, style = "heading_1_label"}
         data.element.add {type = "label", caption = {"pc-docs.page_pc_docs_text_3"}}
         data.element.add {type = "label", caption = {"pc-docs.page_pc_docs_head_4"}, style = "heading_1_label"}
         data.element.add {type = "label", caption = {"pc-docs.page_pc_docs_text_5"}}
         data.element.add {type = "label", caption = {"pc-docs.page_pc_docs_head_6"}, style = "heading_1_label"}
         data.element.add {type = "label", caption = {"pc-docs.page_pc_docs_text_7"}}
         data.element.add {type = "label", caption = {"pc-docs.page_pc_docs_head_8"}, style = "heading_1_label"}
         data.element.add {type = "label", caption = {"pc-docs.page_pc_docs_text_9"}}

         data.element.add {type = "label", caption = {"pc-docs.page_intro_text_scripting_intro"}}

         data.element.add {
            type = "text-box",
            text = "#### #### pc-cpu\n0000 YLD# 51\n0001 JMP# 15\n0002 V:signal-blue 0\n0003 V:signal-green 0\n0004 V:signal-yellow 0\n0005 V:signal-red 0\n0006 VAL# 0\n0007 MUL@ 61\n0008 MUL@ 62\n0009 MUL@ 63\n0010 MUL@ 64\n0011 MUL@ 65\n0012 MUL@ 66\n0013 INC@ 62\n0014 INC@ 65\n0015 YLD# 60\n0016 NOP# 0\n0017 NOP# 0\n0018 NOP# 0\n0019 NOP# 0\n0020 NOP# 0\n0021 NOP# 0\n0022 NOP# 0\n0023 NOP# 0",
         }

         data.element.add {type = "label", caption = {"pc-docs.page_intro_text_command_editor"}}

         data.element.add {type = "text-box", text = "/c game.player.character.destructible = false"}
         data.element.add {type = "label", caption = {"pc-docs.page_intro_text_command_indestructible"}}

         data.element.add {type = "text-box", text = "/c game.player.cheat_mode = true"}
         data.element.add {type = "label", caption = {"pc-docs.page_intro_text_command_cheat"}}

         data.element.add {type = "text-box", text = "/c game.player.insert{name = \"infinity-chest\",count = 1}"}
         data.element.add {type = "label", caption = {"pc-docs.page_intro_text_command_item"}}

         data.element.add {type = "text-box", text = "/c game.player.teleport({0,0})"}
         data.element.add {type = "label", caption = {"pc-docs.page_intro_text_command_teleport"}}

         local code_chart = data.element.add {
            type = "text-box",
            text = "/c local radius = 300 game.player.force.chart(game.player.surface, {{game.player.position.x-radius, game.player.position.y-radius}, {game.player.position.x+radius, game.player.position.y+radius}})",
         }
         code_chart.word_wrap = true
         code_chart.style.vertically_stretchable = true
         data.element.add {type = "label", caption = {"pc-docs.page_intro_text_command_chart"}}

         data.element.add {type = "text-box", text = "/c game.speed = 10"}
         data.element.add {type = "label", caption = {"pc-docs.page_intro_text_command_speed"}}

         data.element.add {type = "text-box", text = "/c game.forces[\"enemy\"].evolution_factor = 0.5"}
         data.element.add {type = "label", caption = {"pc-docs.page_intro_text_command_set_evolution"}}

         data.element.add {
            type = "text-box",
            text = "/c for name, recipe in pairs(game.player.force.recipes) do recipe.enabled = true end",
         }
         data.element.add {type = "label", caption = {"pc-docs.page_intro_text_command_recipes"}}

         data.element.add {type = "text-box", text = "/c game.player.force.research_all_technologies()"}
         data.element.add {type = "label", caption = {"pc-docs.page_intro_text_command_research"}}

         data.element.add {type = "label", caption = {"pc-docs.page_intro_text_scripting_outro"}}
      end,
   },
}
