local handlers = {}
local path = ... .. "."
handlers["on_generic_event"] = require(path .. "on_generic_event")

local function prequire(m)
   local ok, err = pcall(require, m)
   if not ok then
      return nil, err
   end
   return err
end

local function get_handler(name)
   if not handlers[name] then
      handlers[name] = prequire(path .. name)
   end
   if not handlers[name] then
      handlers[name] = handlers["on_generic_event"]
   end
   return handlers[name]
end

local lib = {}

-- Event Lifecycle
-- register > bind > trigger > unregister

--- Bind handler to event then register the event
function lib.register(event)
   local handler = get_handler(event.name)
   if handler.bind then
      handler.bind(event)
   end
   handler.register(event)
end

--- Trigger the event manually (which handle custom events)
function lib.trigger(event)
   local handler = get_handler(event.name).handler
   if handler then
      handler(event)
   end
end

--- Unregister the event
function lib.unregister(event)
   local handler = get_handler(event.name)
   handler.unregister(event)
end
if __DebugAdapter then
   __DebugAdapter.stepIgnore(lib.trigger)
   __DebugAdapter.stepIgnore(lib.register)
   __DebugAdapter.stepIgnore(lib.unregister)
end
return lib

-- All Events
---- name :: defines.events: Identifier of the event
---- tick :: uint: Tick the event was generated.
-- on_ai_command_completed
---- unit_number :: uint: unit_number/group_number of the unit/group which just completed a command.
---- result :: defines.behavior_result
---- was_distracted :: boolean: Was this command generated by a distraction.
-- on_area_cloned
---- source_surface :: LuaSurface
---- source_area :: BoundingBox
---- destination_surface :: LuaSurface
---- destination_area :: BoundingBox
---- destination_force :: LuaForce (optional)
---- clone_tiles :: boolean
---- clone_entities :: boolean
---- clone_decoratives :: boolean
---- clear_destination_entities :: boolean
---- clear_destination_decoratives :: boolean
-- on_biter_base_built
---- entity :: LuaEntity: The built entity.
-- on_brush_cloned
---- source_offset :: TilePosition
---- destination_offset :: TilePosition
---- source_surface :: LuaSurface
---- source_positions :: array of TilePosition
---- destination_surface :: LuaSurface
---- destination_force :: LuaForce (optional)
---- clone_tiles :: boolean
---- clone_entities :: boolean
---- clone_decoratives :: boolean
---- clear_destination_entities :: boolean
---- clear_destination_decoratives :: boolean
-- on_build_base_arrived
---- unit :: LuaEntity (optional): The unit the command was assigned to.
---- group :: LuaUnitGroup (optional): The unit group the command was assigned to.
-- on_built_entity
-- on_cancelled_deconstruction
-- on_cancelled_upgrade
-- on_character_corpse_expired
-- on_chart_tag_added
-- on_chart_tag_modified
-- on_chart_tag_removed
-- on_chunk_charted
-- on_chunk_deleted
-- on_chunk_generated
-- on_combat_robot_expired
-- on_console_chat
-- on_console_command
-- on_cutscene_waypoint_reached
-- on_difficulty_settings_changed
-- on_entity_cloned
-- on_entity_damaged
-- on_entity_destroyed
-- on_entity_died
-- on_entity_renamed
-- on_entity_settings_pasted
-- on_entity_spawned
-- on_force_cease_fire_changed
-- on_force_created
-- on_force_friends_changed
-- on_force_reset
-- on_forces_merged
-- on_forces_merging
-- on_game_created_from_scenario
-- on_gui_checked_state_changed
-- on_gui_click
-- on_gui_closed
-- on_gui_confirmed
-- on_gui_elem_changed
-- on_gui_location_changed
-- on_gui_opened
-- on_gui_selected_tab_changed
-- on_gui_selection_state_changed
-- on_gui_switch_state_changed
-- on_gui_text_changed
-- on_gui_value_changed
-- on_land_mine_armed
-- on_lua_shortcut
-- on_marked_for_deconstruction
-- on_marked_for_upgrade
-- on_market_item_purchased
-- on_mod_item_opened
-- on_picked_up_item
-- on_player_alt_selected_area
-- on_player_ammo_inventory_changed
-- on_player_armor_inventory_changed
-- on_player_banned
-- on_player_built_tile
-- on_player_cancelled_crafting
-- on_player_changed_force
-- on_player_changed_position
-- on_player_changed_surface
-- on_player_cheat_mode_disabled
-- on_player_cheat_mode_enabled
-- on_player_configured_blueprint
-- on_player_crafted_item
-- on_player_created
-- on_player_cursor_stack_changed
-- on_player_deconstructed_area
-- on_player_demoted
-- on_player_died
-- on_player_display_resolution_changed
-- on_player_display_scale_changed
-- on_player_driving_changed_state
-- on_player_dropped_item
-- on_player_fast_transferred
-- on_player_gun_inventory_changed
-- on_player_joined_game
-- on_player_kicked
-- on_player_left_game
-- on_player_main_inventory_changed
-- on_player_mined_entity
-- on_player_mined_item
-- on_player_mined_tile
-- on_player_muted
-- on_player_pipette
-- on_player_placed_equipment
-- on_player_promoted
-- on_player_removed
-- on_player_removed_equipment
-- on_player_repaired_entity
-- on_player_respawned
-- on_player_rotated_entity
-- on_player_selected_area
-- on_player_set_quick_bar_slot
-- on_player_setup_blueprint
-- on_player_toggled_alt_mode
-- on_player_toggled_map_editor
-- on_player_trash_inventory_changed
-- on_player_unbanned
-- on_player_unmuted
-- on_player_used_capsule
-- on_post_entity_died
-- on_pre_chunk_deleted
-- on_pre_entity_settings_pasted
-- on_pre_ghost_deconstructed
-- on_pre_player_crafted_item
-- on_pre_player_died
-- on_pre_player_left_game
-- on_pre_player_mined_item
-- on_pre_player_removed
-- on_pre_player_toggled_map_editor
-- on_pre_robot_exploded_cliff
-- on_pre_script_inventory_resized
-- on_pre_surface_cleared
-- on_pre_surface_deleted
-- on_put_item
-- on_research_finished
-- on_research_started
-- on_resource_depleted
-- on_robot_built_entity
-- on_robot_built_tile
-- on_robot_exploded_cliff
-- on_robot_mined
-- on_robot_mined_entity
-- on_robot_mined_tile
-- on_robot_pre_mined
-- on_rocket_launch_ordered
-- on_rocket_launched
-- on_runtime_mod_setting_changed
-- on_script_inventory_resized
-- on_script_path_request_finished
-- on_script_trigger_effect
-- on_sector_scanned
-- on_selected_entity_changed
-- on_string_translated
-- on_surface_cleared
-- on_surface_created
-- on_surface_deleted
-- on_surface_imported
-- on_surface_renamed
-- on_technology_effects_reset
-- on_tick
-- on_train_changed_state
-- on_train_created
-- on_train_schedule_changed
-- on_trigger_created_entity
-- on_trigger_fired_artillery
-- on_unit_added_to_group
-- on_unit_group_created
-- on_unit_group_finished_gathering
-- on_unit_removed_from_group
-- script_raised_built
-- script_raised_destroy
-- script_raised_revive
-- script_raised_set_tiles
