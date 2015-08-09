data:extend(
{
  {
    type = "technology",
    name = "programmable-controllers",
    icon = "__ProgrammableControllers__/graphics/tech.png",
    effects =
    {   
        {
            type = "unlock-recipe",
            recipe = "controller-in"
        },{
            type = "unlock-recipe",
            recipe = "controller-cpu"
        },{
            type = "unlock-recipe",
            recipe = "controller-mem"
        },{
            type = "unlock-recipe",
            recipe = "controller-out"
        }
    },
    prerequisites = {"circuit-network","advanced-electronics-2"},
    unit =
    {
      count = 50,
      ingredients =
      {
        {"science-pack-1", 1},
        {"science-pack-2", 1}
      },
      time = 15
    },
    order = "a-d-d",
  }
})