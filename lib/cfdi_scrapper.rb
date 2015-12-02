# aad Feb 2015

require "cfdi_scrapper/version"
require "nokogiri"
require 'csv'
require 'i18n'
require 'cfdi_scrapper/comprobantefactory'
require 'cfdi_scrapper/cfdi32/cfdi32'
require 'cfdi_scrapper/timbrefiscaldigital/tfd1'
require 'cfdi_scrapper/erpapi'

I18n.enforce_available_locales = false

module CfdiScrapper
  
  class Cfdi_Scrapper
  
    def self.start(dir)
    
      @dir = dir
    
      # iterate dir path for xml files
      Dir.glob(@dir+"**/*").each do |file|
  
        if File.extname(file).casecmp(".xml") >= 0
        
          # get values
          begin
            @doc = Nokogiri::XML( File.read(file) )
            
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
    
    # Generar CSV de Receptores
    def self.csv_receptores(dir)
      
      @dir = dir
      
      header = "nombre,nombre_corto,rfc,telefono,telefono_secundario,numero_fax,correo_electronico,calle,numero_ext,numero_int,colonia,codigo_postal,ciudad,estado,pais"
      file = @dir + "/receptores.csv"
      
      File.open(file, "w+") do |csv|
      csv << header
      csv << "\n"
      
      receptores = {}
      
        # csv << [c.name, c.country_code, c.user_id, c.subscriber_id]  
        # iterate dir path for xml files
        Dir.glob(@dir+"**/*").each do |file|
  
          if File.extname(file).casecmp(".xml") >= 0
        
            # get values
            begin
              @doc = Nokogiri::XML( File.read(file) )
              
              c = Cfdi32.new(@doc)
              puts c.serie + " " + c.folio + " " + c.fecha + "\n"
              
              if !receptores.key?(c.receptor.rfc)
                
                receptores[c.receptor.rfc] = I18n.transliterate("#{c.receptor.nombre.to_s.gsub(',', '')},#{c.receptor.nombre.to_s.gsub(',', '')},#{c.receptor.rfc},,,,,#{c.receptor.domicilio_calle},#{c.receptor.domicilio_noExterior},#{c.receptor.domicilio_noInterior}, #{c.receptor.domicilio_colonia},#{c.receptor.domicilio_codigoPostal},#{c.receptor.domicilio_municipio},#{c.receptor.domicilio_estado},#{c.receptor.domicilio_pais}") #.encode('utf-8').encode('iso-8859-1')
                csv << receptores[c.receptor.rfc]
                csv << "\n"
                
              end
              
            rescue Exception => e
              puts e
            end
    
          else
            # not an xml
          end
        
        end
      
      end
    
    end
    
    # Generar CSV de Emisores
    def self.csv_emisores(dir)
      
      @dir = dir
      
      header = "nombre,nombre_corto,rfc,telefono,telefono_secundario,numero_fax,correo_electronico,calle,numero_ext,numero_int,colonia,codigo_postal,ciudad,estado,pais"
      file = @dir + "/emisores.csv"
      
      File.open(file, "w+") do |csv|
      csv << header
      csv << "\n"
      
      emisores = {}
      
        # csv << [c.name, c.country_code, c.user_id, c.subscriber_id]  
        # iterate dir path for xml files
        Dir.glob(@dir+"**/*").each do |file|
          
          if File.extname(file).casecmp(".xml") >= 0
        
            # get values
            begin
              @doc = Nokogiri::XML( File.read(file) )
              
              c = Cfdi32.new(@doc)
              puts "-------------------------------------------------------------------------\n"
              puts file + "\n"
              
              if !emisores.key?(c.emisor.rfc)
                
                emisores[c.emisor.rfc] = I18n.transliterate("#{c.emisor.nombre.to_s.gsub(',', '')},#{c.emisor.nombre.to_s.gsub(',', '')},#{c.emisor.rfc},,,,,#{c.emisor.domicilio_calle},#{c.receptor.domicilio_noExterior},#{c.emisor.domicilio_noInterior}, #{c.emisor.domicilio_colonia},#{c.emisor.domicilio_codigoPostal},#{c.emisor.domicilio_municipio},#{c.emisor.domicilio_estado},#{c.emisor.domicilio_pais}") #.encode('utf-8').encode('iso-8859-1')
                csv << emisores[c.emisor.rfc]
                csv << "\n"
                
              end
              
            rescue Exception => e
              puts e
            end
    
          else
            # not an xml
          end
        
        end
      
      end
    
    end
    
    # Generar CSV de Comprobantes
    def self.csv_comprobantes(dir)
      
      @dir = dir
      
      header = "fecha,uuid,serie,folio,emisor,emisor_razonsocial,receptor,receptor_razonsocial,tipoDeComprobante,formaDePago,noCertificado,moneda,tipoCambio,subTotal,Total,descuento,totalImpuestosRetenidos,totalImpuestosTrasladados"
      file = @dir + "/comprobantes.csv"
      
      File.open(file, "w+") do |csv|
      csv << header
      csv << "\n"
      
      comprobantes = {}
      
        # csv << [c.name, c.country_code, c.user_id, c.subscriber_id]  
        # iterate dir path for xml files
        Dir.glob(@dir+"**/*").each do |file|
          
          if File.extname(file).casecmp(".xml") >= 0
          
            # get values
            begin
              @doc = Nokogiri::XML( File.read(file) )
              
              c = Cfdi32.new(@doc)
              puts "-------------------------------------------------------------------------\n"
              puts file + "\n"
              
              if !comprobantes.key?(c.timbre.uuid)
                
                comprobantes[c.timbre.uuid] = I18n.transliterate("#{c.fecha},#{c.timbre.uuid},#{c.serie},#{c.folio},#{c.emisor.rfc},#{c.emisor.nombre.to_s.gsub(',','')},#{c.receptor.rfc},#{c.receptor.nombre.to_s.gsub(',','')},#{c.tipoDeComprobante},#{c.formaDePago},#{c.noCertificado},#{c.moneda},#{c.tipoCambio},#{c.subTotal},#{c.total},#{c.descuento},#{c.totalImpuestosRetenidos},#{c.totalImpuestosTrasladados}") #.encode('utf-8').encode('iso-8859-1')
                csv << comprobantes[c.timbre.uuid]
                csv << "\n"
                
              end
              
            rescue Exception => e
              puts e
            end
    
          else
            # not an xml
          end
        
        end
      
      end
    
    end
    
    # Generar CSV de Conceptos
    def self.csv_conceptos(dir)
      
      @dir = dir
      
      header = "fecha,uuid,rfc_emisor,tipo_de_comprobante,concepto,unidad,precio_unitario,cantidad,importe"
      file = @dir + "/conceptos.csv"
      
      File.open(file, "w+") do |csv|
      csv << header
      csv << "\n"
      
      conceptos = {}
      
        # iterate dir path for xml files
        Dir.glob(@dir+"**/*").each do |file|
          
          if File.extname(file).casecmp(".xml") >= 0
            
            # get values
            begin
              @doc = Nokogiri::XML( File.read(file) )
              
              c = Cfdi32.new(@doc)
              puts "-------------------------------------------------------------------------\n"
              puts file + "\n"
              
              # iterate through all invoice products
              c.conceptos.each do |concepto|
                
                con = ""
                desc = ""
                er = ""
                
                er = c.emisor.rfc.gsub(',', ' ').gsub('"', ' ').gsub('&#xA;',' ')
                desc = "#{concepto.descripcion}".gsub(',', ' ').gsub('"', ' ').gsub('&#xA;',' ')
                con = I18n.transliterate("#{c.fecha},#{c.timbre.uuid},#{er},#{c.tipoDeComprobante},#{desc},#{concepto.unidad},#{concepto.valorUnitario},#{concepto.cantidad},#{concepto.importe}")
                csv << con
                csv << "\n"
                
              end
              
              puts ">>END" + "\n"
              
            rescue Exception => e
              puts e
            end
    
          else
            # not an xml
          end
        
        end
      
      end
      
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
  
end
