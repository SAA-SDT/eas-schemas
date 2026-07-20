<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math"
    xmlns:rng="http://relaxng.org/ns/structure/1.0"
    exclude-result-prefixes="xs math"
    version="3.0">
    
    <xsl:output method="xml" encoding="UTF-8" indent="true"/>
    <xsl:mode on-no-match="shallow-copy"/>
    
    <xsl:template match="rng:attribute//rng:anyName/rng:except//rng:nsName[@ns='']"/>
    
</xsl:stylesheet>