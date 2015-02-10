# aad mayo 2014
#require 'comprobantefactory'
#require 'tfd1'
require 'libxslt'

module COMPROBANTEFACTORY
  
  # Clase Cfdi32 para comprobnates CFDI version 3.2
  #
  class Cfdi32 #< COMPROBANTEFACTORY::Comprobante
    
    attr_accessor :doc
    
    def initialize(doc)
      
      @doc = doc
      
      @version = @doc.root.xpath("//cfdi:Comprobante", 'cfdi' => @doc.collect_namespaces["xmlns:cfdi"]).attribute("version").to_s
      if @version != '3.2'
        raise "El Comprobante no es version 3.2, version #{@version}"
      end
      
      # Atributos Requeridos
      @fecha = @doc.root.xpath("//cfdi:Comprobante", 'cfdi' => @doc.collect_namespaces["xmlns:cfdi"]).attribute("fecha").to_s
      @sello = @doc.root.xpath("//cfdi:Comprobante", 'cfdi' => @doc.collect_namespaces["xmlns:cfdi"]).attribute("sello").to_s
      @certificado = @doc.root.xpath("//cfdi:Comprobante", 'cfdi' => @doc.collect_namespaces["xmlns:cfdi"]).attribute("certificado").to_s
      @tipoDeComprobante = @doc.root.xpath("//cfdi:Comprobante", 'cfdi' => @doc.collect_namespaces["xmlns:cfdi"]).attribute("tipoDeComprobante").to_s
      @formaDePago = @doc.root.xpath("//cfdi:Comprobante", 'cfdi' => @doc.collect_namespaces["xmlns:cfdi"]).attribute("formaDePago").to_s
      @noCertificado = @doc.root.xpath("//cfdi:Comprobante", 'cfdi' => @doc.collect_namespaces["xmlns:cfdi"]).attribute("noCertificado").to_s
      @moneda = @doc.root.xpath("//cfdi:Comprobante", 'cfdi' => @doc.collect_namespaces["xmlns:cfdi"]).attribute("Moneda").to_s
      @tipoCambio = @doc.root.xpath("//cfdi:Comprobante", 'cfdi' => @doc.collect_namespaces["xmlns:cfdi"]).attribute("TipoCambio").to_s.to_d
      @subTotal = @doc.root.xpath("//cfdi:Comprobante", 'cfdi' => @doc.collect_namespaces["xmlns:cfdi"]).attribute("subTotal").to_s.to_d
      @total = @doc.root.xpath("//cfdi:Comprobante", 'cfdi' => @doc.collect_namespaces["xmlns:cfdi"]).attribute("total").to_s.to_d
      @descuento = @doc.root.xpath("//cfdi:Comprobante", 'cfdi' => @doc.collect_namespaces["xmlns:cfdi"]).attribute("descuento").to_s.to_d
      @totalImpuestosRetenidos = @doc.root.xpath("//cfdi:Impuestos", 'cfdi' => @doc.collect_namespaces["xmlns:cfdi"]).attribute("totalImpuestosRetenidos").to_s.to_d
      @totalImpuestosTrasladados = @doc.root.xpath("//cfdi:Impuestos", 'cfdi' => @doc.collect_namespaces["xmlns:cfdi"]).attribute("totalImpuestosTrasladados").to_s.to_d
      @metodoDePago = @doc.root.xpath("//cfdi:Comprobante", 'cfdi' => @doc.collect_namespaces["xmlns:cfdi"]).attribute("metodoDePago").to_s
      @lugarExpedicion = @doc.root.xpath("//cfdi:Comprobante", 'cfdi' => @doc.collect_namespaces["xmlns:cfdi"]).attribute("lugarExpedicion").to_s
      @serie = @doc.root.xpath("//cfdi:Comprobante", 'cfdi' => @doc.collect_namespaces["xmlns:cfdi"]).attribute("serie").to_s
      @folio = @doc.root.xpath("//cfdi:Comprobante", 'cfdi' => @doc.collect_namespaces["xmlns:cfdi"]).attribute("folio").to_s
      
      # Emisor
      @emisor = COMPROBANTEFACTORY::Emisor.new
      #@emisor.rfc = @doc.root.xpath("//cfdi:Comprobante/Emisor").attribute("rfc").to_s
      @emisor.rfc = @doc.root.xpath("//cfdi:Emisor", 'cfdi' => @doc.collect_namespaces["xmlns:cfdi"]).attribute("rfc").to_s
      @emisor.regimenFiscal = @doc.root.xpath("//cfdi:Emisor", 'cfdi' => @doc.collect_namespaces["xmlns:cfdi"]).attribute("regimenFiscal").to_s
      @emisor.nombre = @doc.root.xpath("//cfdi:Emisor", 'cfdi' => @doc.collect_namespaces["xmlns:cfdi"]).attribute("nombre").to_s
        
        # Domicilio Fiscal del Emisor
        @emisor.domicilio_calle = @doc.root.xpath("//cfdi:DomicilioFiscal", 'cfdi' => @doc.collect_namespaces["xmlns:cfdi"]).attribute("calle").to_s
        @emisor.domicilio_noExterior = @doc.root.xpath("//cfdi:DomicilioFiscal", 'cfdi' => @doc.collect_namespaces["xmlns:cfdi"]).attribute("noExterior").to_s
        @emisor.domicilio_noInterior = @doc.root.xpath("//cfdi:DomicilioFiscal", 'cfdi' => @doc.collect_namespaces["xmlns:cfdi"]).attribute("noInterior").to_s
        @emisor.domicilio_municipio = @doc.root.xpath("//cfdi:DomicilioFiscal", 'cfdi' => @doc.collect_namespaces["xmlns:cfdi"]).attribute("municipio").to_s
        @emisor.domicilio_estado = @doc.root.xpath("//cfdi:DomicilioFiscal", 'cfdi' => @doc.collect_namespaces["xmlns:cfdi"]).attribute("estado").to_s
        @emisor.domicilio_pais = @doc.root.xpath("//cfdi:DomicilioFiscal", 'cfdi' => @doc.collect_namespaces["xmlns:cfdi"]).attribute("pais").to_s
        @emisor.domicilio_codigoPostal = @doc.root.xpath("//cfdi:DomicilioFiscal", 'cfdi' => @doc.collect_namespaces["xmlns:cfdi"]).attribute("codigoPostal").to_s
      
      #logger.debug "Emisor: #{@emisor.to_json.to_s}"
      
      # Receptor
      @receptor = COMPROBANTEFACTORY::Receptor.new
      #@receptor.rfc = @doc.root.xpath("//cfdi:Comprobante/Receptor").attribute("rfc").to_s
      @receptor.rfc = @doc.root.xpath("//cfdi:Receptor", 'cfdi' => @doc.collect_namespaces["xmlns:cfdi"]).attribute("rfc").to_s
      @receptor.nombre = @doc.root.xpath("//cfdi:Receptor", 'cfdi' => @doc.collect_namespaces["xmlns:cfdi"]).attribute("nombre").to_s
        
        # Domicilio del Receptor
        @receptor.domicilio_calle = @doc.root.xpath("//cfdi:Domicilio", 'cfdi' => @doc.collect_namespaces["xmlns:cfdi"]).attribute("calle").to_s
        @receptor.domicilio_noExterior = @doc.root.xpath("//cfdi:Domicilio", 'cfdi' => @doc.collect_namespaces["xmlns:cfdi"]).attribute("noExterior").to_s
        @receptor.domicilio_noInterior = @doc.root.xpath("//cfdi:Domicilio", 'cfdi' => @doc.collect_namespaces["xmlns:cfdi"]).attribute("noInterior").to_s
        @receptor.domicilio_municipio = @doc.root.xpath("//cfdi:Domicilio", 'cfdi' => @doc.collect_namespaces["xmlns:cfdi"]).attribute("municipio").to_s
        @receptor.domicilio_estado = @doc.root.xpath("//cfdi:Domicilio", 'cfdi' => @doc.collect_namespaces["xmlns:cfdi"]).attribute("estado").to_s
        @receptor.domicilio_pais = @doc.root.xpath("//cfdi:Domicilio", 'cfdi' => @doc.collect_namespaces["xmlns:cfdi"]).attribute("pais").to_s
        @receptor.domicilio_codigoPostal = @doc.root.xpath("//cfdi:Domicilio", 'cfdi' => @doc.collect_namespaces["xmlns:cfdi"]).attribute("codigoPostal").to_s
        
      #logger.debug "Receptor: #{@receptor.to_json.to_s}"
      
      # Timbre Fiscal Digital
      @versionComplemento = @doc.root.xpath("//tfd:TimbreFiscalDigital", 'tfd' => @doc.collect_namespaces["xmlns:tfd"]).attribute("version").to_s
      
      if @versionComplemento == '1.0'
        
        @timbre = COMPROBANTEFACTORY::Tfd1.new(@doc)
        #@timbre.version = @versionComplemento
        
        @uuid = @doc.root.xpath("//tfd:TimbreFiscalDigital", 'tfd' => @doc.collect_namespaces["xmlns:tfd"]).attribute("UUID").to_s
        #@timbre.uuid = @uuid
      
        @selloSAT = @doc.root.xpath("//tfd:TimbreFiscalDigital", 'tfd' => @doc.collect_namespaces["xmlns:tfd"]).attribute("selloSAT").to_s
        #@timbre.selloSAT = @selloSAT
      
        @selloCFD = @doc.root.xpath("//tfd:TimbreFiscalDigital", 'tfd' => @doc.collect_namespaces["xmlns:tfd"]).attribute("selloCFD").to_s
        #@timbre.selloCFD = @selloCFD
        
        @noCertificadoSAT = @doc.root.xpath("//tfd:TimbreFiscalDigital", 'tfd' => @doc.collect_namespaces["xmlns:tfd"]).attribute("noCertificadoSAT").to_s
        #@timbre.noCertificadoSAT = @noCertificadoSAT
        
        @fechaTimbrado = @doc.root.xpath("//tfd:TimbreFiscalDigital", 'tfd' => @doc.collect_namespaces["xmlns:tfd"]).attribute("FechaTimbrado").to_s
        #@timbre.fechaTimbrado = @fechaTimbrado
        
      else 
        
        raise "Version de Timbre Fiscal #{@versionComplemento} No Soportada"
        
      end
      
      # Conceptos
      @conceptos = Array.new
      @doc.root.xpath("//cfdi:Concepto", 'cfdi' => @doc.collect_namespaces["xmlns:cfdi"]).each do |concepto|
        
        c = COMPROBANTEFACTORY::Concepto.new
        c.cantidad = concepto.attribute("cantidad").to_s
        c.unidad = concepto.attribute("unidad").to_s
        c.valorUnitario = concepto.attribute("valorUnitario").to_s
        c.descripcion = concepto.attribute("descripcion").to_s
        c.importe = concepto.attribute("importe").to_s
        @conceptos.push ( c )
        
      end
      
    end
    
    def cadena_original
      
      file = LibXML::XML::Document.string(@doc.to_s)
      
      stylesheet_doc = LibXML::XML::Document.file("public/sat/cadenaoriginal_3_2.xslt")
      stylesheet = LibXSLT::XSLT::Stylesheet.new(stylesheet_doc)
      
      result = stylesheet.apply(file)
      
      return result.child.to_s
  
    end
    
    # Valida la estructura del Comprobante
    def validate_schema
      
      # open("http://www.sat.gob.mx/cfd/3/cfdv32.xsd")
      
      #puts "KEYS: " + doc.root.keys.to_s
      #puts "Schema: " + doc.root["xsi:schemaLocation"]
      #puts doc.xpath("//*[@xsi:schemaLocation]")
      #puts doc.collect_namespaces
      # Hash[ doc.root["xsi:schemaLocation"].scan(/(\S+)\s+(\S+)/) ]
      
      schema_final = "<xs:schema xmlns:xs='http://www.w3.org/2001/XMLSchema' elementFormDefault='qualified' attributeFormDefault='unqualified'>"
      @doc.xpath("//*[@xsi:schemaLocation]").each do |element|
  
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
    
    def uuid
      @uuid
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
    
    def moneda
      @moneda
    end
    
    def tipoCambio
      @tipoCambio
    end
    
    def subTotal
      @subTotal
    end
    
    def total
      @total
    end
    
    def descuento
      @descuento
    end
    
    def totalImpuestosRetenidos
      @totalImpuestosRetenidos
    end
    
    def totalImpuestosTrasladados
      @totalImpuestosTrasladados
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