class App < Sinatra::Baserequire "sinatra"
require "sinatra/config_file"
require "sinatra/reloader" if development?
require "rom"

class App < Sinatra::Base
  config_file "config/settings.yml"

  db = settings.database_name
  db_options = {
    username: settings.database_user,
    password: settings.database_pass,
    encoding: "UTF8"
  }

  rom = ROM.container(:sql, "postgres://#{settings.database_host}/#{db}", db_options) do |config|
    config.relation(:podcasts) do
      schema(infer: true)
      auto_struct true
    end
    config.relation(:episodes) do
      schema(infer: true)
      auto_struct true
    end
  end

  get "/" do
    redirect "https://5by5.tv"
  end

  get "/d/*/*/audio/broadcasts/*/*/:filename" do
    filename = params[:filename].gsub(".mp3", "").split("-")

    podcast_slug = filename.first
    episode_slug = filename.last

    podcast_slug = "backtowork" if podcast_slug=="b2w"

    podcasts = rom.relations[:podcasts]
    podcast = podcasts.where(slug: podcast_slug).one
    return 404 if podcast.nil?

    episodes = rom.relations[:episodes]
    episode = episodes.where(slug: episode_slug, podcast_id: podcast.id).one
    return 404 if episode.nil?

    if podcast.tracking_prefix_enabled==true && podcast.tracking_prefix_url!=nil && podcast.tracking_prefix_url!=""
      base_url = "#{podcast.tracking_prefix_url}/aphid.fireside.fm"
    else
      base_url = "https://aphid.fireside.fm"
    end

    url = "#{base_url}/d/1437767933/#{podcast.token}/#{episode.token}.mp3"

    redirect url, 301
  end
end
