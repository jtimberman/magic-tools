#!/usr/bin/env ruby
#
# Author: Joshua Timberman <opensource@housepub.org>
# Copyright: Joshua Timberman <opensource@housepub.org>
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
# Using this script:
# First, install Ruby. That's up to you :).
#
# Download lists from Moxfield. Or anywhere else really, but Moxfield is the best
# deckbuilder's site, so you should use that. Plus that's where all the best lists 
# are these days anyway. The lists should be named something.txt, and look like this:
#
# 1 Shalai, Voice of Plenty
# 1 Sol Ring
# 1 Command Tower
#
# This will output a CSV file that has a header row for each decklist it parsed, the
# first column will be a list of every card in all the lists, and then each cell will
# list that card if it were found in the list. From here you can do neat things like
# count up all the occurences of each card to see how popular specific cards are for
# the lists. Generally, this would be a specific Commander, but I don't know your life.
#
# Enjoy!
#
require 'csv'

def line_ending(filename)
  File.open(filename, 'r') {|f| f.readline[/\r?\n$/] }
end

def card_name(item)
  item.split.drop(1).join(' ')
end

def nice_list(name)
  name.gsub(/-\d+-\d+.txt/, '')
end

decks = {}
files = ARGV.empty? ? Dir.glob("*.txt") : ARGV

files.each do |f|
  list = IO.read(f).split(line_ending(f))
  list_name = nice_list(f)
  decks[list_name] = list.map {|card| card_name(card)}
end

output_str = CSV.generate(force_quotes: true) do |csv|
  csv << decks.keys.unshift("card-name")

  decks.values.flatten.uniq.sort.each do |card|
    row = [card]
    decks.keys.each do |deck|
      if decks[deck].include?(card)
        row << card
      else
        row << ""
      end
    end 
    csv << row
  end
end

File.write("decks.csv", output_str)
