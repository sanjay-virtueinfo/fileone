class Plan < ActiveRecord::Base
# This defines the paypal url for a given product sale

  validates :usage, :presence => true
  validates :price, :presence => true
  scope :active, -> {where(:is_active => true)}

  def paypal_url(return_url)
    values = {
      :business => "YOUR_MERCHANT_EMAIL",
      :cmd => '_cart',
      :upload => 1,
      :return => return_url,
      :invoice => "UNIQUE_INTEGER"
    }
     
    values.merge!({
      "amount_1" => "unit_price",
      "item_name_1" => "name",
      "item_number_1" => "id",
      "quantity_1" => '1'
    })
    
    # flash[:notice] = "Your Transaction is #{params[:st]} for amount of $#{params[:amt]}. Thank You for shopping." if params[:st] 
    #"https://www.paypal.com/cgi-bin/webscr?" + values.to_query 
    # This is a paypal sandbox url and should be changed for production.
    # Better define this url in the application configuration setting on environment
    # basis.
    "https://www.sandbox.paypal.com/cgi-bin/webscr?" + values.to_query
  end  
  
end
