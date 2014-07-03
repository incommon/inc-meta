<?xml version="1.0" encoding="UTF-8"?>
<!--

	rands_to_refeds.xsl

	Replace InCommon R&S entity category with REFEDS R&S.

-->
<xsl:stylesheet version="1.0"
	xmlns="urn:oasis:names:tc:SAML:2.0:metadata"
	xmlns:md="urn:oasis:names:tc:SAML:2.0:metadata"
	xmlns:mdattr="urn:oasis:names:tc:SAML:metadata:attribute"
	xmlns:saml="urn:oasis:names:tc:SAML:2.0:assertion"
	xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	exclude-result-prefixes="md">

	<!--Force UTF-8 encoding for the output.-->
	<xsl:output omit-xml-declaration="no" method="xml" encoding="UTF-8" indent="yes"/>

	<xsl:template match="mdattr:EntityAttributes
		/saml:Attribute[@Name='http://macedir.org/entity-category'][@NameFormat='urn:oasis:names:tc:SAML:2.0:attrname-format:uri']
		/saml:AttributeValue[.='http://id.incommon.org/category/research-and-scholarship']">
		<xsl:copy>
			<xsl:text>http://refeds.org/category/research-and-scholarship</xsl:text>
		</xsl:copy>
	</xsl:template>

	<!--By default, copy text blocks, comments and attributes unchanged.-->
	<xsl:template match="text()|comment()|@*">
		<xsl:copy/>
	</xsl:template>

	<!--By default, copy all elements from the input to the output, along with their attributes and contents.-->
	<xsl:template match="*">
		<xsl:copy>
			<xsl:apply-templates select="node()|@*"/>
		</xsl:copy>
	</xsl:template>

</xsl:stylesheet>
