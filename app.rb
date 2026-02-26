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
        erb :index
    end

    get '/results' do
        @results = db.execute('SELECT * FROM results')
        p @todos
        erb(:"todos/index")
    end

    get '/results/new' do
        erb(:"results/new")
    end

    post '/results' do
        p params

        db.execute("INSERT INTO results () VALUES(?,?)", [params["result_"], params["result_"]])
        redirect("/results")
    end

    get'/results/:id' do | id |
        @result = db.execute('SELECT * FROM results WHERE id=?', id).first
        erb(:"results/show")
    end

    post '/results/:id/delete' do | id |
        db.execute("DELETE FROM results WHERE id=?", id)
        redirect("/results")
    end

    get

end
