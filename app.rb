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

    get '/results' do
        @results = db.execute('SELECT * FROM results')
        p @results
        erb(:"results/index")
    end

    get '/results/new' do
        erb(:"results/new")
    end

    post '/results' do
        p params

        db.execute("INSERT INTO results (id_team1, id_team2, score_team1, score_team2) VALUES(?,?,?,?)", [params["result_id_team1"], params["result_id_team2"], params["result_score_team1"], params["result_score_team2"]])
        redirect("/results")
    end

    get'/results/:id' do | id |
        @results = db.execute('SELECT * FROM results WHERE id=?', id).first
        erb(:"results/show")
    end

    post '/results/:id/delete' do | id |
        db.execute("DELETE FROM results WHERE id=?", id)
        redirect("/results")
    end

    get '/results/:id/edit' do | id |
        
        @results = db.execute('SELECT * FROM results WHERE id=?, id').first

        erb(:"results/edit")
    end

    post '/results/:id/update' do | id |
        result_name1 = params['result_id_team1']
        result_name2 = params['result_id_team2']
        result_name3 = params['result_score_team1']
        result_name4 = params['result_score_team2']


        db.execute('UPDATE results SET id_team1=? WHERE id=?', [result_name1, result_name2, result_name3, result_name4, id])

        redirect("/results")
    end

    


end