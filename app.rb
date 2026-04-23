require 'debug'
require "awesome_print"
require 'sinatra'
require 'securerandom'

class App < Sinatra::Base

    setup_development_features(self)

    
    def db
      return @db if @db
      
      @db = SQLite3::Database.new(DB_PATH)
      @db.results_as_hash = true
      return @db
    end

    helpers do

    def is_admin?
    
        if session[:user_id]
            user = db.execute("SELECT is_admin FROM users WHERE id = ?", [session[:user_id]]).first
            return user && user['is_admin'] == 1
        end
        false
        end
    end

    # --- TEAMS ROUTES ---

    get '/' do
        redirect '/teams'
    end

    get '/teams' do
        @teams = db.execute('SELECT * FROM teams')
        erb(:"teams/index")
    end

    get '/teams/new' do
        if is_admin?
            erb(:"teams/new")
        else
    
            redirect '/acces_denied'
        end
    end

    post '/teams' do
        db.execute("INSERT INTO teams (name) VALUES(?)", [params["team_name"]])
        redirect("/teams")
    end

    get '/teams/:id' do |id|
        @team = db.execute('SELECT * FROM teams WHERE id=?', id).first
        erb(:"teams/show")
    end

    get '/teams/:id/edit' do |id|
        if is_admin?
            @team = db.execute('SELECT * FROM teams WHERE id=?', id).first
            erb(:"teams/edit")
        else
            redirect '/acces_denied'
        end
    end

    post '/teams/:id/update' do |id|
        if is_admin?
            team_name = params['team_name']
            db.execute('UPDATE teams SET name=? WHERE id=?', [team_name, id])

            redirect("/teams")
        else
            redirect("/acces_denied")
        end
    end

    post '/teams/:id/delete' do |id|
        if is_admin?
            db.execute("DELETE FROM teams WHERE id=?", id)
            redirect("/teams")
        else 
            redirect '/acces_denied'
        end
    end

    # --- RESULTS ROUTES ---

    get '/results' do
        @results = db.execute( "SELECT 
            r.id AS match_id,
            t1.name AS team1,
            t2.name AS team2,
            r.score_team1,
            r.score_team2
            FROM results AS r
            INNER JOIN teams AS t1 ON r.id_team1 = t1.id
            INNER JOIN teams AS t2 ON r.id_team2 = t2.id;")
        erb(:"results/index")
    end

    get '/results/new' do
        @teams = db.execute("SELECT * FROM teams")
        erb(:"results/new")
    end

    post '/results' do
        db.execute("INSERT INTO results (id_team1, id_team2, score_team1, score_team2) VALUES(?,?,?,?)", 
                   [params["result_id_team1"], params["result_id_team2"], params["result_score_team1"], params["result_score_team2"]])
        redirect("/results")
    end

    get '/results/:id/edit' do |id|
        if is_admin?
            @teams = db.execute("SELECT * FROM teams")
            @result = db.execute('SELECT * FROM results WHERE id = ?', id).first
            erb(:"results/edit")
        else
            redirect '/acces_denied'
        end
    end

    get '/results/:id' do |id|
        @result = db.execute('SELECT * FROM results WHERE id=?', id).first
        erb(:"results/show")
    end
    
    post '/results/:id/update' do |id|
        if is_admin?
            r1 = params['result_id_team1']
            r2 = params['result_id_team2']
            s1 = params['result_score_team1']
            s2 = params['result_score_team2']

            db.execute('UPDATE results SET id_team1=?, id_team2=?, score_team1=?, score_team2=? WHERE id=?', 
                   [r1, r2, s1, s2, id])
            redirect("/results")
        else
            redirect '/acces_denied'
        end
    end

    post '/results/:id/delete' do |id|
        if is_admin?
            db.execute("DELETE FROM results WHERE id=?", id)
            redirect("/results")
        else 
            redirect '/acces_denied'
        end
    end

    #INLOGGNING

    

  configure do
    enable :sessions
    set :session_secret, SecureRandom.hex(64)
  end

  before do
    if session[:user_id]
      @current_user = db.execute("SELECT * FROM users WHERE id = ?", session[:user_id]).first
      ap @current_user
    end
  end

  get '/' do
    erb(:index)
  end

  get '/admin' do
    if session[:user_id]
      erb(:"admin/index")
    else
      ap "/admin : Access denied."
      status 401
      redirect '/acces_denied'
    end
  end

  get '/acces_denied' do
    erb(:acces_denied)
  end

  get '/login' do
    erb(:login)
  end

  post '/login' do
    request_username = params[:username]
    request_plain_password = params[:password]

    user = db.execute("SELECT *
            FROM users
            WHERE username = ?",
            request_username).first

    unless user
      ap "/login : Invalid username."
      status 401
      redirect '/acces_denied'
    end

    db_id = user["id"].to_i
    db_password_hashed = user["password_digest"].to_s

    
    bcrypt_db_password = BCrypt::Password.new(db_password_hashed)
    
    if bcrypt_db_password == request_plain_password
      ap "/login : Logged in -> redirecting to admin"
      session[:user_id] = db_id
      redirect '/admin'
    else
      ap "/login : Invalid password."
      status 401
      redirect '/acces_denied'
    end
  end

  post '/logout' do
    ap "Logging out"
    session.clear
    redirect '/'
  end

  post '/register' do
    username = params[:user_name]
    plain_password = params[:password]
    password_hashed = BCrypt::Password.create(plain_password)

    db.execute("INSERT INTO users (username, password_digest) VALUES (?, ?)", 
        [username, password_hashed])
    redirect ('/login')
  end

  get '/users/new' do
    erb(:"users/new")
  end
end