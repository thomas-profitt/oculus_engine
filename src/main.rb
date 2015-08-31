require_relative 'place'

central_plains = Place.new(
  name: "Central Plains",
  description:
    "Boundless green grass and hearty summer grain roll with a " <<
    "constant easy breeze.",
  conditional_descriptions: [
    {
      descriptions: {
        true =>
          "The rudier glow of the moon is almost outshone by many stars.",
        false =>
          "It's a calm day under a clear sky, featureless save for the sun."
      },
      condition:
        -> () { Time.now.hour >= 8 || Time.now.hour <= 6 }
    },
      descriptions: {
        true =>
          "A small flock of white birds flies by."
      },
      condition:
        -> () { rand(100) < 40 }
  ]
)

northern_peaks = Place.new(
  name: "Northern Peaks",
  description:
    "The stark mountains stab at the sky's sagging, time-lost verdant " <<
    "auroras while they are stripped of their snow by harsh winds."
)

################################################################################

central_plains_north_path_guarded = -> () { true }

################################################################################

central_plains.exits.merge!({
  north: {
    place: northern_peaks,
    condition: central_plains_north_path_guarded,
    descriptions: {
      true =>
        "The path North is unguarded. It begins straight, then twists into " <<
        "the Northern Peaks ahead.",
      false =>
        "There is a guarded path North, leading to the Northern Peaks."
    },
    leaving_description:
      "You walk surefooted until you reach the wicked twists of the path. " <<
      "The air thins and dries around you as you begin your ascent."
  }
})

central_plains.entrances.merge!({
  north: {
    description:
      "The path straightens as the details of the Central Plains become clear."
  }
})

#-------------------------------------------------------------------------------

northern_peaks.exits.merge!({
  south: {
    place: central_plains,
    description:
      "Under a sturdy wooden arch beaten by untold years of icy wind, " <<
      "the twisting path begins. You can trace it back to the Central Plains.",
    leaving_description:
      "Just as you set foot under the arch, sharp gusts prod your back. " <<
      "It is much easier leaving than entering."
  }
})

northern_peaks.entrances.merge!({
  south: {
    description:
      "It becomes hard to breathe and even harder to walk... " <<
      "Having rasped and groped your way to the icy summit, you steel yourself."
  }
})

################################################################################

=begin we're not here yet!
central_plains_north_path_guard = Character.new(
  name: "Guard",
  spawn_place: central_plains,
  spawn_condition: -> () { rand(2) == 1 }
)
=end

#-------------------------------------------------------------------------------

player = Player.new(
  spawn_place: central_plains
)

################################################################################

return Game.start player
