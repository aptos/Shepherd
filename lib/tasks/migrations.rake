namespace :migrations do

  desc "lead sites"
  task :lead_sites => :environment do
    Shepherd::Application.config.sites.each do |db|
      site = Site.by_slug.key("#{db[:db]}_#{Rails.env}").first
      users = site.users.summary.as_hash 'id'
      Lead.by_uid(include_docs: true).each do |doc|
        next if doc['site']
        doc.update_attributes(site: db[:label]) if users.key? doc['uid']
        puts "#{doc['uid']} -> #{doc['site']}"
      end
    end
  end
end