require 'sinatra'
require 'json'

set :public_folder, 'src/main/webapp/'

get '/blog/entries' do
  content_type :json
  entries = [
      {
          id: "1",
          title: "title1",
          tags: ["tag1", "tag2"],
          content: "月は東に日は西に。月日は百代の過客にして行き交う人々もまた旅人なり。"
      },
      {
          id: "2",
          title: "title2",
          tags: ["tag2", "tag3"],
          content: "A long time ago..."
      }
  ]
  entries.to_json
end