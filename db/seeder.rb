require 'sqlite3'

class Seeder

  def self.seed!
    puts "Using db file: #{DB_PATH}"
    puts "🧹 Dropping old tables..."
    drop_tables
    puts "🧱 Creating tables..."
    create_tables
    puts "🍎 Populating tables..."
    populate_tables
    puts "✅ Done seeding the database!"
  end

  def self.drop_tables
    db.execute('DROP TABLE IF EXISTS teams')
    db.execute('DROP TABLE IF EXISTS results')
  end

  def self.create_tables
    db.execute("CREATE TABLE teams (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                name TEXT NOT NULL)")

    db.execute("CREATE TABLE results (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                id_team1 INTEGER NOT NULL,
                id_team2 INTEGER NOT NULL,
                score_team1 INTEGER NOT NULL,
                score_team2 INTEGER NOT NULL
                )")
  end

  def self.populate_tables
    db.execute('INSERT INTO teams (name) VALUES ("AS Roma")')
    db.execute('INSERT INTO teams (name) VALUES ("Juventus")')
    db.execute('INSERT INTO teams (name) VALUES ("Inter Milan")')
    db.execute('INSERT INTO teams (name) VALUES ("AC Milan")')
    db.execute('INSERT INTO teams (name) VALUES ("SSC Napoli")')
    db.execute('INSERT INTO teams (name) VALUES ("Cremonese")')
    db.execute('INSERT INTO teams (name) VALUES ("Genoa")')
    db.execute('INSERT INTO teams (name) VALUES ("Hellas Verona")')
    db.execute('INSERT INTO teams (name) VALUES ("Como")')
    db.execute('INSERT INTO teams (name) VALUES ("Atalanta")')
    db.execute('INSERT INTO teams (name) VALUES ("Bologna")')
    db.execute('INSERT INTO teams (name) VALUES ("Sassuolo")')
    db.execute('INSERT INTO teams (name) VALUES ("Udinese")')
    db.execute('INSERT INTO teams (name) VALUES ("Lazio")')
    db.execute('INSERT INTO teams (name) VALUES ("Parma")')
    db.execute('INSERT INTO teams (name) VALUES ("Cagliari")')
    db.execute('INSERT INTO teams (name) VALUES ("Torino")')
    db.execute('INSERT INTO teams (name) VALUES ("Fiorentina")')
    db.execute('INSERT INTO teams (name) VALUES ("Lecce")')
    db.execute('INSERT INTO teams (name) VALUES ("Pisa")')
  
    db.execute('INSERT INTO results (id_team1, id_team2, score_team1, score_team2) VALUES("17", "15", "4", "1")')
    db.execute('INSERT INTO results (id_team1, id_team2, score_team1, score_team2) VALUES("3", "10", "1", "1")')
    db.execute('INSERT INTO results (id_team1, id_team2, score_team1, score_team2) VALUES("4", "19", "2", "1")')
    db.execute('INSERT INTO results (id_team1, id_team2, score_team1, score_team2) VALUES("13", "2", "0", "1")')
    db.execute('INSERT INTO results (id_team1, id_team2, score_team1, score_team2) VALUES("8", "7", "0", "2")')
    db.execute('INSERT INTO results (id_team1, id_team2, score_team1, score_team2) VALUES("20", "16", "3", "1")')
    db.execute('INSERT INTO results (id_team1, id_team2, score_team1, score_team2) VALUES("12", "11", "0", "1")')
    db.execute('INSERT INTO results (id_team1, id_team2, score_team1, score_team2) VALUES("9", "1", "2", "1")')
    db.execute('INSERT INTO results (id_team1, id_team2, score_team1, score_team2) VALUES("14", "4", "1", "0")')
    db.execute('INSERT INTO results (id_team1, id_team2, score_team1, score_team2) VALUES("6", "18", "1","4")')

   
  
  end

  private

  def self.db
    @db ||= begin
      db = SQLite3::Database.new(DB_PATH)
      db.results_as_hash = true
      db
    end
  end

end

Seeder.seed!
  
