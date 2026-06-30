<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:a="http://relaxng.org/ns/compatibility/annotations/1.0"
    xmlns:rng="http://relaxng.org/ns/structure/1.0"
    xmlns:map="http://www.w3.org/2005/xpath-functions/map"
    exclude-result-prefixes="#all"
    version="3.0">
    <!-- to do: consider adding something like a metadata.json file, instead. -->
    
    <xsl:output method="xml" encoding="UTF-8" indent="true"/>
    <xsl:mode on-no-match="shallow-copy"/>
    
    <xsl:param name='schema' select="'eac'"/>
    
    <xsl:variable name="schema-version" select="map{
        'eac': '3.0.0',
        'ead': '4.0.0',
        'eaf': '1.0.0'
        }"/>
    
    <xsl:template match="xs:schema">
        <xsl:copy>
            <xsl:attribute name="version" select="map:get($schema-version, $schema)"/>
            <xsl:apply-templates select="@* | node()"/>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="rng:grammar">
        <xsl:copy>
            <xsl:attribute namespace="http://relaxng.org/ns/compatibility/annotations/1.0" name="version" select="map:get($schema-version, $schema)"/>
            <xsl:apply-templates select="@* | node()"/>
        </xsl:copy>
    </xsl:template>
    
    
    
</xsl:stylesheet>