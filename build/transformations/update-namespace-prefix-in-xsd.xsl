<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:eac="https://archivists.org/ns/eac/v3"
    xmlns:ead3="http://ead3.archivists.org/schema/" xmlns:ead="https://archivists.org/ns/ead/v4"
    exclude-result-prefixes="#all" version="3.0">

    <xsl:output method="xml" encoding="UTF-8" indent="true"/>
    <xsl:mode on-no-match="shallow-copy"/>

    <xsl:param name="schema" select="'eac'"/>

    <!-- for ead, this gets us 'https://archivists.org/ns/ead/v4' -->
    <xsl:variable name="schema-ns-uri" select="document('')/*/namespace::*[local-name() eq $schema]"/>

    <!-- and to get the "v4" prefix from the namespace URI, we do this -->
    <xsl:param name="trang-ns-prefix" select="tokenize($schema-ns-uri, '/')[last()]"/>

    <xsl:template match="xs:*">
        <xsl:element name="{name()}" namespace="{namespace-uri()}">
            <xsl:for-each select="namespace::*">
                <xsl:namespace name="{if (local-name() = $trang-ns-prefix) then $schema else local-name()}" select="string(.)"/>
            </xsl:for-each>
            <xsl:apply-templates select="@*|node()"/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="@base[starts-with(., $trang-ns-prefix)] | @ref[starts-with(., $trang-ns-prefix)] | @type[starts-with(., $trang-ns-prefix)]">
        <xsl:attribute name="{local-name()}">
            <xsl:value-of select="$schema || ':' || substring-after(., ':')"/>
        </xsl:attribute>
    </xsl:template>

</xsl:stylesheet>
