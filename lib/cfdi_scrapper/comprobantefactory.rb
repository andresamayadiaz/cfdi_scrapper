# aad mayo 2014

module COMPROBANTEFACTORY
  
  require 'nokogiri'
  require 'open-uri'
  #require 'time'
  #require 'base64'
  
  require 'cfdi32/cfdi32'
  require 'timbrefiscaldigital/tfd1'
  
  class Emisor
    
    attr_accessor :rfc, :regimenFiscal, :nombre, :domicilio_calle, :domicilio_noExterior, :domicilio_noInterior, :domicilio_municipio, :domicilio_colonia, :domicilio_estado, :domicilio_pais, :domicilio_codigoPostal
    
  end
  
  class Receptor
    
    attr_accessor :rfc, :nombre, :domicilio_calle, :domicilio_noExterior, :domicilio_noInterior, :domicilio_municipio, :domicilio_colonia, :domicilio_estado, :domicilio_pais, :domicilio_codigoPostal
      
  end
  
  class TimbreFiscal
    
    attr_accessor :version, :uuid, :fechaTimbrado, :selloCFD, :noCertificadoSAT, :selloSAT
    
  end
  
  class Concepto
    
    attr_accessor :cantidad, :unidad, :descripcion, :valorUnitario, :importe
    
  end
  
  class Comprobante
    
    attr_accessor :file, :doc
    
    # Valida la estructura del Comprobante
    def validate_schema
      
      # open("http://www.sat.gob.mx/cfd/3/cfdv32.xsd")
      doc = Nokogiri::XML( File.read(@file) )
      
      #puts "KEYS: " + doc.root.keys.to_s
      #puts "Schema: " + doc.root["xsi:schemaLocation"]
      #puts doc.xpath("//*[@xsi:schemaLocation]")
      #puts doc.collect_namespaces
      # Hash[ doc.root["xsi:schemaLocation"].scan(/(\S+)\s+(\S+)/) ]
  
      schema_final = "<xs:schema xmlns:xs='http://www.w3.org/2001/XMLSchema' elementFormDefault='qualified' attributeFormDefault='unqualified'>"
      doc.xpath("//*[@xsi:schemaLocation]").each do |element|
  
  	    schemata_by_ns = Hash[ element["xsi:schemaLocation"].scan(/(\S+)\s+(\S+)/) ]

  	      schemata_by_ns.each do |ns,xsd_uri|
  	      xsd = Nokogiri::XML::Schema(open(xsd_uri))
  	      #puts "NS: #{ns} --- URI: #{xsd_uri}"
  	      #puts "VALID: " + xsd.valid?(doc).to_s
  	      schema_final += "<xs:import namespace='#{ns}' schemaLocation='#{xsd_uri}'/>"

  	    end

      end
      schema_final += "</xs:schema>"
      #puts "SCHEMA FINAL: " + schema_final
      schema2 = Nokogiri::XML::Schema.new(schema_final)
  
      #puts ">>>>> VALID? " + schema2.valid?(doc).to_s
      #schema2.validate(doc).each do |error|
      #    puts error.message
      #end
      
      if schema2.valid?(doc) == true
      	return true
      else
      	return schema2.validate(doc)
      end
  
    end
    
    def version
      @version
    end
    
    def fecha
      @fecha
    end
    
    def sello
      @sello
    end
    
    def formaDePago
      @formaDePago
    end
    
    def noCertificado
      @noCertificado
    end
    
    def certificado
      @certificado
    end
    
    def subTotal
      @subTotal
    end
    
    def total
      @total
    end
    
    def tipoDeComprobante
      @tipoDeComprobante
    end
    
    def metodoDePago
      @metodoDePago
    end
    
    def lugarExpedicion
      @lugarExpedicion
    end
    
    def emisor
      @emisor
    end
    
    def receptor
      @receptor
    end
    
    def conceptos
      @conceptos
    end
    
    def serie
      @serie
    end
    
    def folio
      @folio
    end
    
    def timbre
      @timbre
    end
    
  end
  
end
