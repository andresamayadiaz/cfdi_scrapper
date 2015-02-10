# aad julio 2014
#require 'comprobantefactory'

module COMPROBANTEFACTORY
  
  # Clase Cfdi32 para comprobnates CFDI version 3.2
  #
  class Tfd1 #< COMPROBANTEFACTORY::TimbreFiscal
    
    attr_accessor :doc, :version, :uuid, :fechaTimbrado, :selloCFD, :noCertificadoSAT, :selloSAT
    
    def initialize(doc)
      
      @doc = doc
      
      @version = @doc.root.xpath("//tfd:TimbreFiscalDigital", 'tfd' => @doc.collect_namespaces["xmlns:tfd"]).attribute("version").to_s
      
      if @version != '1.0'
        raise "El Timbre Fiscal Digital no es version 1.0, version #{@version}"
      end
      
      @uuid = @doc.root.xpath("//tfd:TimbreFiscalDigital", 'tfd' => @doc.collect_namespaces["xmlns:tfd"]).attribute("UUID").to_s
      @selloSAT = @doc.root.xpath("//tfd:TimbreFiscalDigital", 'tfd' => @doc.collect_namespaces["xmlns:tfd"]).attribute("selloSAT").to_s
      @selloCFD = @doc.root.xpath("//tfd:TimbreFiscalDigital", 'tfd' => @doc.collect_namespaces["xmlns:tfd"]).attribute("selloCFD").to_s
      @noCertificadoSAT = @doc.root.xpath("//tfd:TimbreFiscalDigital", 'tfd' => @doc.collect_namespaces["xmlns:tfd"]).attribute("noCertificadoSAT").to_s
      @fechaTimbrado = @doc.root.xpath("//tfd:TimbreFiscalDigital", 'tfd' => @doc.collect_namespaces["xmlns:tfd"]).attribute("FechaTimbrado").to_s
      
    end
    
    def cadena_original
      
      file = LibXML::XML::Document.string(@doc.xpath("//tfd:TimbreFiscalDigital", 'tfd' => @doc.collect_namespaces["xmlns:tfd"]).to_s)
      
      stylesheet_doc = LibXML::XML::Document.file("public/sat/cadenaoriginal_TFD_1_0.xslt")
      stylesheet = LibXSLT::XSLT::Stylesheet.new(stylesheet_doc)
      
      result = stylesheet.apply(file)
      
      return result.child.to_s
      
    end
    
  end
  
end