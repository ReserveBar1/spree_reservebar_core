Spree::Admin::LineItemsController.class_eval do

   before_filter :load_line_item, :only => [:destroy, :update, :update_engraving_text]

   def update_engraving_text
     @preferences = params[:line_item].delete(:preferences)
     update_preferences if @preferences.present?

     redirect_to(:back)
   end

   def load_line_item
     @line_item = @order.line_items.find params[:id]
   end

   private

   def update_preferences
     customization = @preferences[:customization]
     @line_item.preferred_customization = customization.to_json if customization.present?
     flash.notice = "Your engraving options have been updated."
   end

end
