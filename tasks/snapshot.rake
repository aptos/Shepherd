require 'restclient'
require 'json'
require 'couchrest'
require 'couchrest_model'
require 'pry'

@remotes = [
  'shepherd_production',
]

task :default => ':snapshot'

desc "prepare"
task :prepare do
  raise "export DBCREDENTIALS" unless ENV['DBCREDENTIALS']
  @timestamp = Time.now.strftime('%Y%m%d')
  @log = File.open('snapshot.log', 'w+')
  @log.puts @timestamp
end

desc "backup database"
task snapshot: :prepare do
  @remotes.each do |db|
    config = {
      source: "https://#{ENV['DBCREDENTIALS']}@taskit.cloudant.com/#{db}",
      target: "#{db}-#{@timestamp}",
      create_target: true,
      continuous: false
    }
    puts db
    resp = RestClient.post "http://admin:admin@localhost:5984/_replicate", config.to_json, :content_type => :json
    @log.puts "#{db}\n#{resp}\n\n"
    status = JSON resp
    raise "FAIL!" unless status['ok']
    puts "OK: #{status['ok']}"
  end
end

desc "replicate"
task replicate: :prepare do
  ['taskitone', 'taskit-pro'].each do |db|
    config = {
      source: "https://#{ENV['DBCREDENTIALS']}@taskit.cloudant.com/#{db}_production",
      target: "#{db}_development",
      create_target: true,
      continuous: false
    }
    puts db
    resp = RestClient.post "http://admin:admin@localhost:5984/_replicate", config.to_json, :content_type => :json
    @log.puts "#{db}\n#{resp}\n\n"
    status = JSON resp
    raise "FAIL!" unless status['ok']
    puts "OK: #{status['ok']}"
  end
end