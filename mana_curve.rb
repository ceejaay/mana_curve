require 'yaml'
require 'ascii_charts'
require 'json'
#the yaml methods are for saving and loading the card database.
def yaml_save(object, filename)
  File.open filename, 'w' do |f|
    f.write(object.to_yaml)
  end
end

def yaml_load(filename)
  yaml_string = File.read filename
  YAML::load yaml_string
end
#this format string adds 30 spaces to the name. It helps format the list feature.
def format_string(string)
  while string.length != 30
    string << " "
  end
end

def find_card(card_name)
 card_data = nil
 JSON_DATA.each {|x| card_data = x if x["name"].downcase == card_name.downcase }
 card_data
end

#load the card databases
CARD_DATABASE = yaml_load("card_database.yml")
file = File.read("GTC.json")
JSON_DATA = JSON.parse(file)["cards"] 
# a list of variables.
input = ARGV
name = nil 
color = nil
type = nil
mana_cost = nil

#the case statement to interpret the incoming ARGV array and the
#strings/commands inside
case input[0]
  when "add"
    input.shift
    mana_cost = input.pop.to_i
    type = input.pop
    color = input.pop
    name = input.join(" ")
    format_string(name)
    CARD_DATABASE << {:name => name, :color => color, :type => type, :mana_cost => mana_cost, :id => CARD_DATABASE.length + 1}
    puts "Card Saved!"

  when "chart"
    chart = []
    grouping = CARD_DATABASE.group_by {|card| card[:mana_cost]}
    grouping.each_pair do |key, value_length|
      chart << [key, value_length.length]
    end
    puts AsciiCharts::Cartesian.new(chart, :bar => true).draw

  when "list"
    CARD_DATABASE.each do |item|
      puts "#{item[:name]} | #{item[:color]} | #{item[:type]} |#{item[:mana_cost]} "
    end
  else 
    puts "commads are 'add', 'list' or 'chart' "
#this needs some more instruction
end
#format and save the database of cards into yaml file.
CARD_DATABASE.sort_by! {|card| card[:mana_cost] }
yaml_save(CARD_DATABASE, 'card_database.yml')
