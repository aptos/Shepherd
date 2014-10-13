require 'restclient'
require 'json'
require 'couchrest'
require 'couchrest_model'
require 'pry'

@remotes = [
  'shepherd_production',
]

@timestamp = Time.now.strftime('%Y%m%d')

desc "backup database"
task :snapshot do
  log = File.open('snapshot.log', 'w+')
  log.puts @timestamp

  @remotes.each do |db|
    config = {
      source: "https://#{ENV['DBCREDENTIALS']}@taskit.cloudant.com/#{db}",
      target: "#{db}-#{@timestamp}",
      create_target: true,
      continuous: false
    }
    puts db
    resp = RestClient.post "http://admin:admin@localhost:5984/_replicate", config.to_json, :content_type => :json
    log.puts "#{db}\n#{resp}\n\n"
    status = JSON resp
    raise "FAIL!" unless status['ok']
    puts "OK: #{status['ok']}"
  end
end

