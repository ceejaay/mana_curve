This is a simple command line app to keep a database of your Magic the Gathering
Deck.

It shows you the Mana curve.

This is a very rough draft. If you can get it to work..Yay for you!

Usage.
These are the gems/libraries you'll need:
yaml & ascii_charts
github.com/benlund/ascii_charts

From the command line type:
ruby mana_curve.rbl [COMMANDD] [OPTION(s)] 

The commands are:

add - This adds a card to the database. Example

$=> ruby mana_curve.rb add Scorch Walker red creature 4

Scorch Walker = card name
red = color of card
creature = type of card
4 = mana cost.

These have to be done in this order.

list - use this to list all the cards you've input.

chart - this command displays a chart showing the mana curve of your deck.
