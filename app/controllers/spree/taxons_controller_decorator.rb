Spree::TaxonsController.class_eval do
  
  private

  def accurate_title
    if @taxon
      unless @taxon.page_title?
        return "#{@taxon.name}, buy or gift. #{default_title}"
      else
        return @taxon.page_title
      end
    end
  end

end
