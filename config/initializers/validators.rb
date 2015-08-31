ActiveRecord::Base.class_eval do
  def self.validates_is_only_states(*attr_names)
    return false if Rails.env == 'test'
    all_state_abbrs = Spree::Country.where(:name => 'United States').first.states.all
    all_state_abbrs = all_state_abbrs.present? ? all_state_abbrs : []
    all_state_abbrs.map!(&:abbr)

    validates_each(attr_names) do |record, attr_name, value|
      unless value.nil?
        value.split(',').each { |v|
          record.errors.add(attr_name, "-- #{v} is not a valid state") unless all_state_abbrs.include? v
        }
      end
    end

  end
end
