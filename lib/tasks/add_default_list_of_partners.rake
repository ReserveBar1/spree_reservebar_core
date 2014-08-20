namespace :data do
  desc 'Add Partners list to the database'
  task :add_partners => :environment do
    partner_names = YAML.load_file("config/partners.yml")["names"]
    partner_names.each do |partner_name|
      partner = Partner.find_or_create_by_name(partner_name)
      if partner.new_record?
        puts "Created new Partner: #{partner_name}"
      else
        puts "Skipping existing Partner: #{partner_name}"
      end
    end
  end
end
