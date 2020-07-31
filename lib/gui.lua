require("util")
local Gui = {}
local include = {
    ["any"] = {
        type = {"string", "!"},
        name = {"string"},
        caption = {"any"},
        tooltip = {"any"},
        enabled = {"boolean"},
        ignored_by_interaction = {"boolean"},
        style = {"string"},
    },
    ["button"] = {mouse_button_filter = {"any"}},
    ["sprite-button"] = {
        sprite = {"any"},
        hovered_sprite = {"any"},
        clicked_sprite = {"any"},
        number = {"number"},
        show_percent_for_small_numbers = {"boolean"},
        mouse_button_filter = {"any"},
    },
    ["checkbox"] = {state = {"boolean", "!"}},
    ["flow"] = {direction = {"string"}},
    ["frame"] = {direction = {"string"}},
    ["label"] = {},
    ["line"] = {direction = {"string", "!"}},
    ["progressbar"] = {value = {"number"}},
    ["table"] = {
        column_count = {"number", "!"},
        draw_vertical_lines = {"boolean"},
        draw_horizontal_lines = {"boolean"},
        draw_horizontal_lines_after_headers = {"boolean"},
        vertical_centering = {"boolean"},
    },
    ["textfield"] = {
        text = {"string"},
        numeric = {"boolean"},
        allow_decimal = {"boolean"},
        allow_negative = {"boolean"},
        is_password = {"boolean"},
        lose_focus_on_confirm = {"boolean"},
        clear_and_focus_on_right_click = {"boolean"},
    },
    ["radiobutton"] = {state = {"boolean", "!"}},
    ["sprite"] = {sprite = {"any"}},
    ["scroll-pane"] = {horizontal_scroll_policy = {"string"}, vertical_scroll_policy = {"string"}},
    ["drop-down"] = {items = {"table"}, selected_index = {"number"}},
    ["list-box"] = {items = {"table"}, selected_index = {"number"}},
    ["camera"] = {position = {"any", "!"}, surface_index = {"number"}, zoom = {"number"}},
    ["choose-elem-button"] = {
        elem_type = {"string", "!"},
        item = {"string"},
        tile = {"string"},
        entity = {"string"},
        signal = {"SignalID"},
        fluid = {"string"},
        recipe = {"string"},
        decorative = {"string"},
        ["item-group"] = {"string"},
        achievement = {"string"},
        equipment = {"string"},
        technology = {"string"},
        elem_filters = {"any"},
    },
    ["text-box"] = {text = {"string"}, clear_and_focus_on_right_click = {"boolean"}},
    ["slider"] = {
        minimum_value = {"number"},
        maximum_value = {"number"},
        value = {"number"},
        value_step = {"number"},
        discrete_slider = {"boolean"},
        discrete_values = {"boolean"},
    },
    ["minimap"] = {
        position = {"any"},
        surface_index = {"number"},
        chart_player_index = {"number"},
        force = {"string"},
        zoom = {"number"},
    },
    ["entity-preview"] = {},
    ["empty-widget"] = {},
    ["tabbed-pane"] = {},
    ["tab"] = {badge_text = {"any"}},
    ["switch"] = {
        switch_state = {"string"},
        allow_none_state = {"boolean"},
        left_label_caption = {"any"},
        left_label_tooltip = {"any"},
        right_label_caption = {"any"},
        right_label_tooltip = {"any"},
    },
}
local function _add(out, guis)
    local def = {}

    -- exclude some key from definition
    for key, keytype in pairs(include.any) do
        if keytype[2] == "!" and ((keytype[1] == "any" and out[key] == nil) or type(out[key]) ~= keytype[1]) then
            error(string.format("key %s of type %s must be included", key, keytype[1]))
        end
        if keytype[1] == "any" or type(out[key]) == keytype[1] then
            def[key] = out[key]
            out[key] = nil
        end
    end
    for key, keytype in pairs(include[def.type]) do
        if keytype[2] == "!" and ((keytype[1] == "any" and out[key] == nil) or type(out[key]) ~= keytype[1]) then
            error(string.format("key %s of type %s must be included", key, keytype[1]))
        end
        if keytype[1] == "any" or type(out[key]) == keytype[1] then
            def[key] = out[key]
            out[key] = nil
        end
    end
    -- add style name
    if out.style and out.style.name then
        def.style = out.style.name
        out.style.name = nil
    end

    -- create gui
    -- local gui = out.parent.add(def)
    local gui = out.parent.add(def)

    -- add custom style
    for key, value in pairs(out) do
        if key == "style" then
            if #out.style > 0 then
                error("style must only contain members with string key")
            end

            for style_key, style_value in pairs(out.style) do
                gui.style[style_key] = style_value
            end
        elseif key == "parent" then
        elseif key == "as" then
            guis[value] = gui
        elseif key == "children" then
            for _, subdef in ipairs(out.children) do
                subdef.parent = gui
                _add(subdef, guis)
            end
        else
            gui[key] = out[key]
        end
    end

    return guis
end
function Gui.add(args)
    local guis = {}
    if args.type then
        _add(table.deepcopy(args), guis)
    else
        for _, def in ipairs(args) do
            if not def.parent then
                def.parent = args.parent
            end
            _add(table.deepcopy(def), guis)
        end
    end
    return guis
end

if __DebugAdapter then
    __DebugAdapter.stepIgnore(_add)
    __DebugAdapter.stepIgnore(Gui.add)
end

return Gui
