require "cfdi_scrapper/version"
require "cfdi_scrapper/cfdi32/cfdi32"

module CfdiScrapper
  # Your code goes here...
  
  class Cfdi_Scrapper
  
    def self.start(dir)
    
      @dir = dir
    
      #puts @dir
    
      # iterate dir path for xml files
      Dir.glob(@dir+"**/*").each do |file|
  
        if File.extname(file).casecmp(".xml") >= 0
        
          # get values
          begin
            @doc = Nokogiri::XML( File.read(file) )
          
            #COMPROBANTEFACTORY::Cfdi32.new(@doc)
          
            #puts file
            #puts File.extname(file).casecmp(".xml")
            puts self.obtener_rfcemisor(@doc) + "," + self.obtener_rfcreceptor(@doc) + "," + self.obtener_uuid(@doc) + "," + self.obtener_fecha(@doc)
            #puts self.obtener_rfcreceptor(@doc)
            #puts self.obtener_uuid(@doc)
          rescue Exception => e
            #puts e.backtrace.inspect  
            puts file + ',' + "NA,NA,NA"
          end
    
        else
          # not an xml
        end
  
      end
    
    end
  
    # Generar XLS de Receptores
    def xls_receptores
    
    
    
    end
    
  
    private
  
      def self.obtener_uuid(doc)
  
        return doc.root.xpath("//tfd:TimbreFiscalDigital", 'tfd' => doc.collect_namespaces["xmlns:tfd"]).attribute("UUID").to_s
  
      end


      def self.obtener_rfcreceptor(doc)
  
        return doc.root.xpath("//cfdi:Receptor", 'cfdi' => doc.collect_namespaces["xmlns:cfdi"]).attribute("rfc").to_s
  
      end


      def self.obtener_rfcemisor(doc)
  
        return doc.root.xpath("//cfdi:Emisor", 'cfdi' => doc.collect_namespaces["xmlns:cfdi"]).attribute("rfc").to_s
  
      end
    
      def self.obtener_nombrereceptor(doc)
  
        return doc.root.xpath("//cfdi:Receptor", 'cfdi' => doc.collect_namespaces["xmlns:cfdi"]).attribute("nombre").to_s
  
      end
    
      def self.obtener_fecha(doc)
      
        return doc.root.xpath("//cfdi:Comprobante", 'cfdi' => doc.collect_namespaces["xmlns:cfdi"]).attribute("fecha").to_s
      
      end
    
      def self.files_in_dir(path)
  
        path = path + "/**/*"
        return Dir.glob(path)
  
      end
  
  end

  Cfdi_Scrapper.start ARGV.first
  
end
