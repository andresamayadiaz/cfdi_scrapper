# aad Feb 2015

module CfdiScrapper
  
  # Clase General del API
  class API
    
    attr_accessor :url, :user, :password, :company
    
    def initialize(params)
    
      self.url = params[:url].blank? ? "http://localhost/erp/" : params[:url]
      self.user = params[:user].blank? ? "" : params[:user]
      self.password = params[:password].blank? ? "" : params[:password]
      self.company = params[:company].blank? ? "" : params[:company]
    
    end
  
    # Envia una factura
    # Type: POST
    def cfdi_sales(params)
      
      # FIXED VALUES
      # location, payment, ship_via, sales_type, area_id, tax_type_id
      
    end
    
    # Obtener area_id
    # GET /cfdi/sales/areas/
    def get_area_id
      
      uri = URI.parse(self.url + "/cfdi/sales/areas/")
      http = Net::HTTP.new(uri.host, uri.port)
      request = Net::HTTP.Get.new(uri)
      
      request["X-COMPANY"] = self.company
      request["X-USER"] = self.company
      request["X-PASSWORD"] = self.company
      
      response = http.request(request)
      
      areas = Array.new
      if response.kind_of? Net::HTTPSuccess
        JSON.parse(response.body.to_s).each do |area|
          areas.push Serie.new(area)
        end
      end
      return areas
      
    end
    
    # Obtener customer_id
    # GET /cfdi/customer/?rfc=:rfc
    def get_customer_id(rfc)
      
      uri = URI.parse(self.url + "/cfdi/customer/?rfc=" + rfc)
      http = Net::HTTP.new(uri.host, uri.port)
      request = Net::HTTP.Get.new(uri)
      
      request["X-COMPANY"] = self.company
      request["X-USER"] = self.company
      request["X-PASSWORD"] = self.company
      
      response = http.request(request)
      
      customers = Array.new
      if response.kind_of? Net::HTTPSuccess
        JSON.parse(response.body.to_s).each do |customer|
          customers.push Serie.new(customer)
        end
      end
      return customers
      
    end
    
    # Obtener branch_id
    # GET /cfdi/customer/branch/:id
    def get_branch_id(customer_id)
      
      uri = URI.parse(self.url + "/cfdi/customer/branch/" + customer_id)
      http = Net::HTTP.new(uri.host, uri.port)
      request = Net::HTTP.Get.new(uri)
      
      request["X-COMPANY"] = self.company
      request["X-USER"] = self.company
      request["X-PASSWORD"] = self.company
      
      response = http.request(request)
      
      branches = Array.new
      if response.kind_of? Net::HTTPSuccess
        JSON.parse(response.body.to_s).each do |branch|
          branches.push Serie.new(branch)
        end
      end
      return branches
      
    end
    
  
  end
  
  # Clase Factura
  class Factura
    
    attr_accessor :ref, :uuid, :folio, :fechatimbrado, :autofactura_id, :trans_type, :comments, :payment, :delivery_date, :cust_ref, :deliver_to, :delivery_address, :phone, :ship_via, :location, :email, :customer_id, :branch_id, :sales_type, :area_id, :dimension_id, :dimension2_id, :ex_rate, :items
    
    def initialize(params)
      
      # General
      self.ref = params[:ref]
      self.uuid = params[:uuid]
      self.folio = params[:folio]
      self.fechatimbrado = params[:fechatimbrado]
      self.autofactura_id = params[:autofactura_id]
      self.trans_type = params[:trans_type].blank? ? 10 : params[:trans_type]
      self.comments = params[:comments]
      self.payment = params[:payment]
      self.delivery_date = params[:delivery_date]
      self.cust_ref = params[:cust_ref]
      self.deliver_to = params[:deliver_to]
      self.delivery_address = params[:delivery_address]
      self.phone = params[:phone]
      self.ship_via = params[:ship_via]
      self.location = params[:location]
      self.email = params[:email]
      self.customer_id = params[:customer_id]
      self.branch_id = params[:branch_id]
      self.sales_type = params[:sales_type]
      self.area_id = params[:area_id]
      self.dimension_id = params[:dimension_id]
      self.dimension2_id = params[:dimension2_id]
      self.ex_rate = params[:ex_rate]
      
      # Items
      self.items = Array.new
      params[:Items].each do |item|
        
        itm = {}
        itm[:tax_type_id] = item[:taxt_type_id]
        itm[:description] = item[:description]
        itm[:qty] = item[:qty]
        itm[:price] = item[:price]
        itm[:discount] = item[:discount]
        
        self.items.push(Item.new(itm))
        
      end
      
    end
    
    def get_example
      
      ex = {
        :ref => '',
        :uuid => '',
        :folio => '',
        :fechatimbrado => '',
        :autofactura_id => '',
        :trans_type => 10, # 10 = Factura
        :comments => '',
        :payment => '',
        :delivery_date => '',
        :cust_ref => '',
        :deliver_to => '',
        :delivery_address => '',
        :phone => '',
        :ship_via => '', # FIJO 1
        :location => '',
        :email => '',
        :customer_id => '',
        :branch_id => '',
        :sales_type => '',
        :area_id => '', # FIJO 1
        :dimension_id => '',
        :dimension2_id => '',
        :ex_rate => '',
        :Items => {
          0 => {
            :tax_type_id => '',
            :description => '',
            :qty => '',
            :price => '',
            :discount => ''
          },
          1 => {
            :tax_type_id => '',
            :description => '',
            :qty => '',
            :price => '',
            :discount => ''
          }
        }
      }
      
    end
    
  end
  
  # Clase Item
  class Item
    
    attr_accessor :tax_type_id, :description, :qty, :price, :discount
    
    def initialize(params)
      
      self.tax_type_id = params[:tax_type_id]
      self.description = params[:description]
      self.qty = params[:qty].blank? ? 1 : params[:qty]
      self.price = params[:price]
      self.discount = params[:discount]
      
    end
    
  end

end