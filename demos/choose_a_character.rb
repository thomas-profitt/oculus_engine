require_relative '../oculus'

#initialize plain-old-ruby variables############################################

pansy_party_name = "Elflord Raymond and the Persnickety Flower Pickers"
manly_party_name = "Two Orcs and a Half-Orc"

#initialize all pages###########################################################

choose_a_character = Page.new name: "Who will You Follow?"
mountain = Page.new name: "The Accursed Mt. Hatred"
party = Page.new name: "Drunken Party"
funeral = Page.new name: "Funeral"
the_end = Page.new name: "The End!"

#initialize player##############################################################

initial = Player.new
initial.spawn_page = choose_a_character
pansy_party = Player.new
manly_party = Player.new

#initial game ##################################################################

game = Game.new(player: initial)

#add descriptions to all pages##################################################

choose_a_character.descriptions << Description.new(
  "The dreaded dragon of " << mountain.name + " must be stopped. " <<
  "There are two adventuring parties to choose from."
)

mountain.descriptions << Description.new(
  descriptions: {
    manly_party =>
      "#{manly_party_name} have arrived... " <<
      "Zerthrax the Summoner's incantation is interrupted by a tail sweep, " <<
      "his Staff of Nineteen Hells shattered! " <<
      "Hedona the Warmistress plunges her axe, and what remains of " <<
      "Zerthrax's Staff of Nineteen Hells, into the dragon's skull, " <<
      "finishing the scaled demon off. " <<
      "Chuck'thar helped by thinking up a cool phrase to say afterward..." <<
      "\n\"Ain't misbehavin'.\"",
    pansy_party =>
      "It's pretty ugly. You don't want to know. " <<
      "I mean, there's a *lot* of screaming...",
    initial => "You're still.. no one?"
  },
  condition: -> () { game.player }
)

party.descriptions << Description.new(
  "At the party, all two and a half orcs get laid."
)

funeral.descriptions << Description.new(
  "At the funeral, there's one casket for each member of " <<
  "#{pansy_party_name}, all closed..."
)

the_end.descriptions << Description.new(
  "Thanks for playing!"
)

#add passages between pages#####################################################

#choose_a_character passages----------------------------------------------------

choose_a_character.passages << Passage.new(
  option: "elflord",
  descriptions: [
    Description.new("#{pansy_party_name} take turns hugging a sapling.")
  ],
  departure_descriptions: [
    Description.new("#{pansy_party_name} depart for #{mountain.name}!")
  ],
  destination: mountain,
  after_departure: -> () {
    pansy_party.go game.player.page
    game.player = pansy_party
  }
)

choose_a_character.passages << Passage.new(
  option: "orcs",
  descriptions: [
    Description.new("#{manly_party_name} collect scars in a barfight.")
  ],
  departure_descriptions: [
    Description.new("#{manly_party_name} depart for #{mountain.name}!")
  ],
  destination: mountain,
  after_departure: -> () {
    manly_party.go game.player.page
    game.player = manly_party
  }
)

#mountain passages--------------------------------------------------------------

mountain.passages << Passage.new(
  option: "celebrate",
  destination: party,
  descriptions: [
    Description.new(
      descriptions: { true => "Celebrate your kill?" },
      condition: -> () { game.player == manly_party }
    )
  ],
  departure_descriptions: [
    Description.new(
      "Hedona begins the task of severing the dragon's head. " <<
      "Nothin' says \"party!\" like a dragon head on a pike, after all."
    )
  ],
  condition: -> () { game.player == manly_party }
)

mountain.passages << Passage.new(
  option: "next",
  destination: funeral,
  descriptions: [
    Description.new(
      descriptions: { true => "Next..." },
      condition: -> () { game.player == pansy_party }
    )
  ],
  departure_descriptions: [
    Description.new(
      "Eventually, someone finds opportunity to sweep (and wipe) up what's " <<
      "left of the party."
    )
  ],
  condition: -> () { game.player == pansy_party }
)

#funeral passages---------------------------------------------------------------

funeral.passages << Passage.new(
  option: "next",
  destination: the_end,
  descriptions: [
    Description.new("Next...")
  ]
)

#party passages-----------------------------------------------------------------

party.passages << Passage.new(
  option: "next",
  destination: the_end,
  descriptions: [
    Description.new("Next...")
  ]
)

#initialize game and start######################################################

game.start

