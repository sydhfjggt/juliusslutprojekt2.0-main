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
  end

  def self.create_tables
    db.execute("CREATE TABLE teams (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                name TEXT NOT NULL
                img_path TEXT)")
  end

  def self.populate_tables
    db.execute('INSERT INTO teams (name, img) VALUES ("AS Roma", C:\Users\julius.markensten\Documents\wsp\juliusslutprojekt2.0-main\public\img\AS ROMA.webp)')
    db.execute('INSERT INTO teams (name, img) VALUES ("Juventus", )')
    db.execute('INSERT INTO teams (name, img) VALUES ("Inter Milan, ")')
    db.execute('INSERT INTO teams (name, img) VALUES ("AC Milan, ")')
    db.execute('INSERT INTO teams (name, img) VALUES ("SSC Napoli, ")')
    db.execute('INSERT INTO teams (name, img) VALUES ("Cremonese, ")')
    db.execute('INSERT INTO teams (name, img) VALUES ("Genoa, ")')
    db.execute('INSERT INTO teams (name, img) VALUES ("Hellas Verona, ")')
    db.execute('INSERT INTO teams (name, img) VALUES ("Como, ")')
    db.execute('INSERT INTO teams (name, img) VALUES ("Atalanta, ")')
    db.execute('INSERT INTO teams (name, img) VALUES ("Bologna, ")')
    db.execute('INSERT INTO teams (name, img) VALUES ("Sassuolo, ")')
    db.execute('INSERT INTO teams (name, img) VALUES ("Udinese, ")')
    db.execute('INSERT INTO teams (name, img) VALUES ("Lazio, ")')
    db.execute('INSERT INTO teams (name, img) VALUES ("Parma, ")')
    db.execute('INSERT INTO teams (name, img) VALUES ("Cagliari, ")')
    db.execute('INSERT INTO teams (name, img) VALUES ("Torino, ")')
    db.execute('INSERT INTO teams (name, img) VALUES ("Fiorentina, ")')
    db.execute('INSERT INTO teams (name, img) VALUES ("Lecce, ")')
    db.execute('INSERT INTO teams (name, img) VALUES ("Pisa, ")')
  
  
  
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
  
