#!/usr/bin/ruby
# encoding: UTF-8
require 'csv'
require 'pp'
require 'httparty'

print "Account Authentication Token: "
auth_token = gets.gsub(/\s+/, '')
File.open('deleteList.csv', 'r') do |f|
  first_row = true
  column_mappings = {}
  CSV.parse(f.read).each do |row|
    if first_row
      row.each_with_index do |column, i|
        column_mappings[column.downcase.gsub(/\s+/, '')] = i
      end
      first_row = false
    else

      video_id = row[column_mappings['video.id']].strip rescue ''
      response = HTTParty.delete("https://api.vidyard.com/dashboard/v1/videos/#{video_id}.json", :body => {
        "auth_token" => auth_token
      })
      parsedResponse = JSON.parse(response.body)

      pp ("Video: #{parsedResponse["id"]} - #{parsedResponse["name"]} deleted")
      if video_id.nil?
        raise 'Found a row with no video.id'
      end

    end
 end
end
