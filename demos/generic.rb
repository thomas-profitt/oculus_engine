require_relative '../oculus'

################################################################################

player = Player.new

# We omit specification of a user_interface for the Game; the default works.
game = Game.new(player: player)

################################################################################

its_night = -> () { Time.now.hour >= 20 || Time.now.hour <= 6 }

central_plains_north_path_unguarded = -> {
  game.turn_rand(100) < 40
}

################################################################################

central_plains = Page.new(
  name: "Central Plains",
  descriptions: [
    Description.new(
      "Boundless green grass and hearty summer grain roll with a " <<
        "constant easy breeze.",
    ),
    Description.new(
      descriptions: {
        true =>
          "The rudier glow of the moon is almost outshone by many stars.",
        false =>
          "It's a calm day under a clear sky, featureless save for the sun."
      },
      condition: its_night
    ),
    Description.new(
      descriptions: {
        [true, false] =>
          "A small flock of white birds flies by.",
        [true, true] =>
          "An enormous bat swoops down and returns to the sky " <<
          "having stolen a ripe plum from a tree."
      },
      condition:
        -> () { [(game.turn_rand(100) < 40), its_night.call] }
    )
  ]
)

western_village = Page.new(
  name: "Western Village",
  descriptions: [
    Description.new("The village has a description."),
    Description.new(
      "Something with an 80% chance to happen is happening.",
      -> () { game.turn_rand(100) < 80 }
    )
  ]
)

northern_peaks = Page.new(
  name: "Northern Peaks",
  descriptions: [
    Description.new(
      "The stark mountains stab at the sky's sagging, time-lost verdant " <<
        "auroras while they are stripped of their snow by harsh winds."
    )
  ]
)

################################################################################

player.spawn_page = central_plains

################################################################################

central_plains.passages << Passage.new(
  option: :north,
  destination: northern_peaks,
  condition: central_plains_north_path_unguarded,
  descriptions: [
    Description.new(
      descriptions: {
        true =>
          "The path North is unguarded. It begins straight, then twists into "<<
          "the Northern Peaks ahead.",
        false =>
          "There is a guarded path North, leading to the Northern Peaks."
      },
      condition: central_plains_north_path_unguarded
    )
  ],
  departure_descriptions: [
    Description.new(
      "You walk surefooted until you reach the wicked twists of the path. " <<
      "The air thins and dries around you as you begin your ascent."
    )
  ],
  arrival_descriptions: [
    Description.new(
      "It becomes hard to breathe and even harder to walk... " <<
      "Having rasped and groped your way to the icy summit, you steel yourself."
    )
  ]
)

central_plains.passages << Passage.new(
  option: :west,
  destination: western_village,
  descriptions: [Description.new("A sign, \"Western Village,\" points West.")],
  arrival_descriptions: [
    Description.new(
      "The calm of the Central Plains is saturated with sounds of village " <<
      "life as you near the Western Village."
    )
  ]
)

#-------------------------------------------------------------------------------

western_village.passages << Passage.new(
  option: :east,
  destination: central_plains,
  descriptions: [
    Description.new("A road east leads into the Central Plains")
  ],
  departure_descriptions: [
    Description.new(
      "You pass travelers on the way, all heading the " <<
      "opposite direction."
    )
  ],
  arrival_descriptions: [
    Description.new("You enter the Central Plains from the West.")
  ]
)

#-------------------------------------------------------------------------------

northern_peaks.passages << Passage.new(
  option: :arch,
  destination: central_plains,
  descriptions: [
    Description.new(
      "Under a sturdy wooden arch beaten by untold years of icy wind, " <<
      "the twisting path begins. You can trace it back to the Central Plains.",
    )
  ],
  departure_descriptions: [
    Description.new(
      "Just as you set foot under the arch, sharp gusts prod your back. " <<
      "It is much easier leaving than entering."
    )
  ],
  arrival_descriptions: [
    Description.new(
      "The path straightens as the details of the Central Plains become clear."
    )
  ]
)

################################################################################

=begin we're not here yet!
central_plains_north_path_guard = Character.new(
  name: "Guard",
  spawn_page: central_plains,
  spawn_condition: -> () { game.turn_rand(2) == 1 }
)
=end

#-------------------------------------------------------------------------------

################################################################################

game.start

