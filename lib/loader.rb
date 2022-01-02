require 'yaml'

module Loader
  def save
    Dir.mkdir 'savegames' unless Dir.exist? 'savegames'
    time = Time.now.to_s[0..-7]
    file = File.open("./savegames/#{@id}_#{time}.yml", 'w')
    file.write(@driver.to_yaml)
    file.close
  end

  def load_game
    saves = Dir.children('savegames')
    begin
      file = show_files(saves)
      data = YAML.load(File.open("./savegames/#{file}"))
      @driver = data
      @id = file[0..4]
    rescue StandardError
      puts 'You have entered an invalid entry, retry please'
      retry
    end
  end

  def show_files(files)
    system('clear')
    files.each_with_index do |file, ind|
      puts "#{ind} - #{file}"
    end
    puts 'Please enter the index of the file to load'
    files[gets.chomp.to_i]
  end
end
