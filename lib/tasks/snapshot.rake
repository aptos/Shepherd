require 'restclient'
require 'json'
require 'couchrest'
require 'couchrest_model'

task :default => ':snapshot'
namespace :db do

  @timestamp = Time.now.strftime('%Y%m%d')

  desc "backup database"
  task :snapshot do
    db_config = YAML.load_file("config/couchdb.yml")['production']
    db = "#{db_config['prefix']}_#{db_config['suffix']}"
    puts "#{db} -> #{db}-#{@timestamp}"

    config = {
      source: "https://#{ENV['COUCH_USER']}:#{ENV['COUCH_PASSWORD']}@#{ENV['COUCH_USER']}.cloudant.com/#{db}",
      target: "#{db}-#{@timestamp}",
      create_target: true,
      continuous: false
    }
    resp = RestClient.post "http://admin:admin@localhost:5984/_replicate", config.to_json, :content_type => :json
    puts resp
    status = JSON resp
    raise "FAIL!" unless status['ok']
    puts "OK: #{status['ok']}"
  end

  desc "replicate"
  task :replicate do
    ['taskit2015', 'taskit-juniper'].each do |db|
      config = {
        source: "https://#{ENV['COUCH_USER']}:#{ENV['COUCH_PASSWORD']}@#{ENV['COUCH_USER']}.cloudant.com/#{db}_production",
        target: "#{db}_development",
        create_target: true,
        continuous: false
      }
      puts db
      resp = RestClient.post "http://admin:admin@localhost:5984/_replicate", config.to_json, :content_type => :json
      puts resp
      status = JSON resp
      raise "FAIL!" unless status['ok']
      puts "OK: #{status['ok']}"
    end
  end
end