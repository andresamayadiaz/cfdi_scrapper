# aad Feb 2015

require "uri"
require "net/http"
require "json"
require "uuid"

module CfdiScrapper
  
  # Clase General del API
  class API
    
    attr_accessor :url, :user, :password, :company
    
    def initialize(params)
    
      self.url = params[:url]
      self.user = params[:user]
      self.password = params[:password]
      self.company = params[:company]
    
    end
    
    def get_request(path)
      
      # request = Net::HTTP.post_form(URI.parse(self.url), params)
      uri = URI.parse(self.url + path)
      http = Net::HTTP.new(uri.host, uri.port)
      request = Net::HTTP::Get.new(uri)
      
      request["X_company"] = self.company
      request["X_user"] = self.user
      request["X_password"] = self.password
      
      return http.request(request)
      
    end
    
    # Envia una factura
    # POST /cfdi/sales/
    def cfdi_sales(factura)
      
      uri = URI.parse(self.url + "/cfdi/sales/")
      http = Net::HTTP.new(uri.host, uri.port)
      request = Net::HTTP::Post.new(uri)
      
      request["X_company"] = self.company
      request["X_user"] = self.user
      request["X_password"] = self.password
      
      request.set_form_data(factura)
      
      return http.request(request)
      
    end
    
    # Obtener area_id
    # GET /cfdi/sales/areas/
    def get_area_id
      
      path = "/cfdi/sales/areas/"
      
      response = self.get_request(path)
      
      areas = {}
      if response.kind_of? Net::HTTPSuccess
        #JSON.parse(response.body.to_s).each do |area|
        #  areas.push(area)
        #end
        areas = JSON.parse(response.body.to_s)
      end
      return areas
      
    end
    
    # Obtener customer_id
    # GET /cfdi/customer/?rfc=:rfc
    def get_customer_id(rfc)
      
      path = "/cfdi/customer/?rfc=" + rfc
      
      response = self.get_request(path)
      
      customers = {}
      if response.kind_of? Net::HTTPSuccess
        customers = JSON.parse(response.body.to_s)
      end
      
      return customers
      
    end
    
    # Obtener branch_id
    # GET /cfdi/customer/branch/:id
    def get_branch_id(customer_id)
      
      path = "/cfdi/customer/branch/" + customer_id
      
      response = self.get_request(path)
      
      branches = {}
      if response.kind_of? Net::HTTPSuccess
        branches = JSON.parse(response.body.to_s)
      end
      return branches
      
    end
    
    # Obtener payment_term_id
    # GET /paymentterms/
    def get_payment_id
      
      path = "/paymentterms/"
      
      response = self.get_request(path)
      
      payments = {}
      if response.kind_of? Net::HTTPSuccess
        payments = JSON.parse(response.body.to_s)
      end
      
      return payments
      
    end
    
    # Obtener location_id
    # GET /locations/
    def get_location_id
      
      path = "/locations/"
      
      response = self.get_request(path)
      
      locations = {}
      if response.kind_of? Net::HTTPSuccess
        locations = JSON.parse(response.body.to_s)
      end
      
      return locations
      
    end
    
    # Obtener sales_type
    # GET /cfdi/sales/types/
    def get_sales_types
      
      path = "/cfdi/sales/types/"
      
      response = self.get_request(path)
      
      sales_types = {}
      if response.kind_of? Net::HTTPSuccess
        sales_types = JSON.parse(response.body.to_s)
      end
      
      return sales_types
      
    end
    
    # Obtener tax_types
    # GET /cfdi/taxtypes/
    def get_taxtypes
      
      path = "/cfdi/taxtypes/"
      
      response = self.get_request(path)
      
      taxtypes = {}
      if response.kind_of? Net::HTTPSuccess
        taxtypes = JSON.parse(response.body.to_s)
      end
      
      return taxtypes
      
    end
    
    def generate_invoice_example
      
      # Payment
      payment = self.get_payment_id
      
      # Location
      location = self.get_location_id
      
      # Customer
      customer = self.get_customer_id("CTD0903038I7")
      
      # Sales Type
      sales_type = self.get_sales_types
      
      # Tax Type
      taxtype = self.get_taxtypes
      
      # Items
      items = Array.new
      
      items.push({
            :tax_type_id => taxtype[0]["id"],
            :description => 'CONCEPTO 1',
            :qty => 1,
            :price => 25,
            :discount => 0
          })
      
      # Example 
      ex = {
        :ref => Random.new.rand(1000..99999), #UUID.new.generate,
        :uuid => UUID.new.generate,
        :folio => UUID.new.generate,
        :fechatimbrado => Time.now.strftime("%Y-%m-%dT%l:%M:%S%z"),
        :autofactura_id => UUID.new.generate,
        :trans_type => '10', # 10 = Factura
        :comments => 'PRUEBAS API RUBY CFDI_SCRAPPER',
        :payment => payment[0]['id'],
        :delivery_date => Time.now.strftime("%Y-%m-%d"),
        :cust_ref => Random.new.rand(1000..99999), #UUID.new.generate,
        :deliver_to => Time.now.strftime("%Y-%m-%d"),
        :delivery_address => 'Entregar En XYZ',
        :phone => '',
        :ship_via => '1', # FIJO 1
        :location => location[0]["loc_code"],
        :email => 'info@example.com',
        :customer_id => customer["no"],
        :branch_id => customer["cust_branches"][0]["code"],
        :sales_type => sales_type["sales_types"][0]["id"],
        :area_id => '1', # FIJO 1
        :dimension_id => '',
        :dimension2_id => '',
        :ex_rate => '1'
      }
      
      ex[:items] = items.to_json
      
      return ex
      #return CfdiScrapper::Factura.new(ex)
      
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
      self.trans_type = params[:trans_type].empty? ? 10 : params[:trans_type]
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
      params[:items].each do |item|
        
        itm = {}
        itm[:tax_type_id] = item[:tax_type_id]
        itm[:description] = item[:description]
        itm[:qty] = item[:qty]
        itm[:price] = item[:price]
        itm[:discount] = item[:discount]
        
        self.items.push(Item.new(itm))
        
      end
      
    end
    
  end
  
  # Clase Item
  class Item
    
    attr_accessor :tax_type_id, :description, :qty, :price, :discount
    
    def initialize(params)
      
      self.tax_type_id = params[:tax_type_id]
      self.description = params[:description]
      self.qty = params[:qty].empty? ? 1 : params[:qty]
      self.price = params[:price]
      self.discount = params[:discount]
      
    end
    
  end

end