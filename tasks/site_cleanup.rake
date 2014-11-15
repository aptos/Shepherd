require 'couchrest'
require 'couchrest_model'
require 'json'
require 'pry'

def save_or_create(doc)
  begin
    rev = @db.get(doc['_id'])['_rev']
    doc['_rev'] = rev
    @db.save_doc(doc)
  rescue
    @db.save_doc(doc)
  end
end

# @db = CouchRest.database("https://admin:admin@localhost:5984/shepherd_development")
@db = CouchRest.database("https://#{ENV['DBCREDENTIALS']}@taskit.cloudant.com/shepherd_production")

desc "remove sites"
task :remove_sites do
  design = {
    "_id" => "_design/sites",
    :views => {
      :all => {
        :map => "
        function(doc) {
          if (doc.type == 'Site') {
            emit(doc._id, null);
          }
          };
          "
        }
      }
    }

    save_or_create(design)

    @db.view('sites/all')['rows'].each do |site|
      puts site['id']
      doc = @db.get site['id']
      @db.delete_doc doc
    end
end