require 'debug'
require "awesome_print"

class App < Sinatra::Base

    setup_development_features(self)

    # Funktion för att prata med databasen
    # Exempel på användning: db.execute('SELECT * FROM fruits')
    def db
      return @db if @db
      @db = SQLite3::Database.new(DB_PATH)
      @db.results_as_hash = true

      return @db
    end

    # Routen /
    get '/' do
        erb ('/teams')
    end

    get '/teams' do
        @teams = db.execute('SELECT * FROM teams')
        p @teams
        erb(:"teams/index")
    end

    get '/teams/new' do
        erb(:"teams/new")
    end

    post '/teams' do
        p params

        db.execute("INSERT INTO teams (name) VALUES(?)", [params["team_name"]])
        redirect("/teams")
    end

    get'/teams/:id' do | id |
        @teams = db.execute('SELECT * FROM teams WHERE id=?', id).first
        erb(:"teams/show")
    end

    post '/teams/:id/delete' do | id |
        db.execute("DELETE FROM teams WHERE id=?", id)
        redirect("/teams")
    end

    get '/teams/:id/edit' do | id |
        
        @teams = db.execute('SELECT * FROM teams WHERE id=?, id').first

        erb(:"teams/edit")
    end

    post '/teams/:id/update' do | id |
        team_name = params['team_name']


        db.execute('UPDATE teams SET name=? WHERE id=?', [team_name, id])

        redirect("/teams")
    end


end