return {
   menu = {examples = {simple_trafic_lights = 1, dual_trafic_lights = 1}},
   pages = {
      ["examples"] = function(data)
         data.element.add {type = "label", caption = {"pc-docs.page_examples_text_1"}}
      end,
      ["simple_trafic_lights"] = function(data)
         local el = nil
         el = data.element.add {
            type = "label",
            caption = {
               "pc-docs.page_simple_trafic_lights_text_1",
               "[special-item=0eNq1ltuOmzAQhl9l5WuobA4GIvWiz9DLaoUcMmQtmYNskzaNePeOk5Y42VCF7IYLJBv7m/mH8YwPZK0G6LVsLVkdiKy61pDVjwMxctsK5ebsvgeyItJCQwLSisaN+iqs+oGMAZHtBn6RFRtfAwKtlVbCiXAc7Mt2aNagccG01zRCqVCJpkde3xnc0rXOEmJoQPb4Ri56YnWnyjW8iZ3stFtQSV0N0pb4bTPtqqU2tnzn705qO+DM2exxRbgHpbqf5GTBWOGEMzdoeqGFdYbIV/d5MICGVKdRjtUDnHa0UDnDxlli7qVh48uVOIrG4GKcjq/j6M39C0m0ICQhe2JMnIZnBoTNBCC+zqd34kP234SopbKgZzL2ndq+kiGlJ6WDk0m99A3uJTCfwCdCdB/hb8TdqbvpSLwIs9UA7U1OsojjH4orULoINGXSFYXfH18aeYR4ImQLCIlHiJIJkS9AfPMQLDoLKR4UcvaC0Y8rYexBKdxL+ehBKekZEX+ClOTRv5J7WtIPn1/GXQeTpnS1pxbKwK2KlfgVq8cjM1exjvUaF4AuByO24Ax84RdPlqe0oEmaFpxSxnmR8SRleRZnWREVPM8w0OuhrhFh5G9HoMfnhlvpgk7yzEbi1aOntZLL3spnWgu/aC0oZu5HsU9pLTP1mPn3o/tFni4MLh3dpWvl3dECosQa0BXyXTa9gherRV3L6kXJ7Zs1+H2HTh9FZlnMGOZSQvNx/AM8ekRX]",
            },
         }
         el.style.rich_text_setting = defines.rich_text_setting.highlight

         el = data.element.add {
            type = "text-box",
            text = "[special-item=0eNq1ltuOmzAQhl9l5WuobA4GIvWiz9DLaoUcMmQtmYNskzaNePeOk5Y42VCF7IYLJBv7m/mH8YwPZK0G6LVsLVkdiKy61pDVjwMxctsK5ebsvgeyItJCQwLSisaN+iqs+oGMAZHtBn6RFRtfAwKtlVbCiXAc7Mt2aNagccG01zRCqVCJpkde3xnc0rXOEmJoQPb4Ri56YnWnyjW8iZ3stFtQSV0N0pb4bTPtqqU2tnzn705qO+DM2exxRbgHpbqf5GTBWOGEMzdoeqGFdYbIV/d5MICGVKdRjtUDnHa0UDnDxlli7qVh48uVOIrG4GKcjq/j6M39C0m0ICQhe2JMnIZnBoTNBCC+zqd34kP234SopbKgZzL2ndq+kiGlJ6WDk0m99A3uJTCfwCdCdB/hb8TdqbvpSLwIs9UA7U1OsojjH4orULoINGXSFYXfH18aeYR4ImQLCIlHiJIJkS9AfPMQLDoLKR4UcvaC0Y8rYexBKdxL+ehBKekZEX+ClOTRv5J7WtIPn1/GXQeTpnS1pxbKwK2KlfgVq8cjM1exjvUaF4AuByO24Ax84RdPlqe0oEmaFpxSxnmR8SRleRZnWREVPM8w0OuhrhFh5G9HoMfnhlvpgk7yzEbi1aOntZLL3spnWgu/aC0oZu5HsU9pLTP1mPn3o/tFni4MLh3dpWvl3dECosQa0BXyXTa9gherRV3L6kXJ7Zs1+H2HTh9FZlnMGOZSQvNx/AM8ekRX]",
         }
         el.style.rich_text_setting = defines.rich_text_setting.highlight

         el = data.element.add {type = "camera", position = {10, 20}, surface_index = 1, zoom = 1}
         el.style.minimal_width = 512
         el.style.maximal_width = 512
         el.style.natural_width = 512
         el.style.minimal_height = 512
         el.style.maximal_height = 512
         el.style.natural_height = 512
         el.style.horizontal_align = "center"
         el.style.vertical_align = "center"

      end,
   },
}
