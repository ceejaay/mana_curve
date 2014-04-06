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
 JSON_DATA.each {|x| card_data = x if x["name"] == card_name }
 if card_data == nil
   puts "Can't find"
 else
   card_data
 end
end

def mana_cost_number(card)
#this method needs to be able to handle 'X'. right now it counts x as 1
 mana_cost_integer = 0
 range = ("1".."9")
 raw_mana_data = find_card(card)["manaCost"].scan(/\{(.*?)\}/).flatten
 if range.include?(raw_mana_data[0])
#if the first item in array is a number string.
   mana_cost_integer = raw_mana_data[0].to_i
   raw_mana_data.shift
 else
  #if not, then raw mana data is set to 1 integer.
  mana_cost_integer = 1
  raw_mana_data.shift
 end
 #when the method is done it will return an integer showing the mana cost
 mana_cost_integer =  mana_cost_integer + raw_mana_data.length
 mana_cost_integer
end

#load the card databases
CARD_DATABASE = yaml_load("card_database.yml")
file = File.read("GTC.json")
JSON_DATA = JSON.parse(file)["cards"] 
# a list of variables.
input = ARGV

#the case statement to interpret the incoming ARGV array and the
#strings/commands inside
case input[0]
  when "add"
    input.shift
    card = find_card(input.join(" "))
    name = find_card(card)
    puts name
    CARD_DATABASE <<  { :name => "Hello world", :mana_cost => 5 }
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
#testing things DELETE THEM
 #JSON_DATA.each {|x| puts x["name"].downcase}
