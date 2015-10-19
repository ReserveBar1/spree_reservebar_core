Spree::ProductsController.class_eval do
  include ActionView::Helpers::NumberHelper

  def index
    @searcher = Spree::Config.searcher_class.new(params)
    @products = @searcher.retrieve_products
    @products.delete_if { |p| !p.searchable? }
    
    respond_with(@products)
  end

  def adroll_feed
    # Set which products we want to target
    brand_names = ['Perrier-Jouet', 'Dom Perignon', 'Jim Beam']
    brand_ids = Spree::Brand.select(:id).where(title: brand_names).map(&:id)
    @products = Spree::Product.where(brand_id: brand_ids, deleted_at: nil).where(Spree::Product.arel_table[:available_on].not_eq(nil)).includes(:variants)
    product_permalinks = ['johnnie-walker-blue-custom-engraved-bottle','heisenberg-blue-ice-vodka-limited-edition-say-my-name','heisenberg-blue-ice-vodka-limited-edition-the-one-who-knocks','heisenberg-blue-ice-vodka-limited-edition-tread-lightly','heisenberg-blue-ice-vodka-limited-edition-collection']
    product_permalinks << ['patron-anejo','patron-silver','gran-patron-burdeos','patron-reposado','don-julio-1942','deleon-platinum-tequila','deleon-extra-anejo-tequila-1','deleon-diamante-tequila-1','avion-anejo-2','avion-reposado-2','avion-silver-2','avion-anejo-custom-engraved-bottle-1','avion-reposado-custom-engraved-bottle-1','avion-silver-custom-engraved-bottle-1','avion-extra-anejo-reserva-44-custom-engraved-bottle-1','ciroc-standard','ciroc-red-berry','ciroc-coconut-1','ciroc-peach']
    product_permalinks << ['the-macallan-sherry-oak-12-years-old','the-macallan-rare-cask','absolut-elyx-2','absolut-elyx-custom-engraved-bottle-1','hennessy-vs','hennessy-x-dot-o','hennessy-xo-custom-engraved-bottle','hennessy-privilege-vsop-limited-edition','hennessy-paradis-1','hennessy-paradis-imperial']
    product_permalinks << ['belvedere-007-spectre-bottle-750ml','belvedere-007-spectre-bottle-1000ml','belvedere-007-spectre-bottle-1750ml', 'glenlivet-12-year-old','glenlivet-15-year-old','glenlivet-18-year-old','glenlivet-18-year-old-custom-engraved-bottle-2','glenlivet-21-year-old','chivas-18-custom-engraved-bottle','glenlivet-21-year-old-custom-engraved-bottle-2','chivas-18']
    product_permalinks << ['glenfiddich-12-year-old','glenfiddich-14-year-old','glenfiddich-18-year-old', 'glenfiddich-21-year-old-gran-reserva']
    @products += Spree::Product.where(permalink: product_permalinks).includes(:variants)

    respond_with do |format|
      format.text { render text: feed_text }
    end
  end

  private

  def feed_text
    # Return tab deliminated text of required product info
    full_url = request.protocol + request.host_with_port
    column_names = ["ProductID", "Title", "URL","ImageUrl", "Price"]

    CSV.generate({ col_sep: "\t" }) do |row|
      row << column_names
      @products.each do |prod|
        row << [ prod.sku, prod.name, "#{full_url}/products/#{prod.permalink}", full_url + prod.images.first.attachment.url(:large), number_to_currency(prod.try(:price))]
      end
    end
  end

end 
