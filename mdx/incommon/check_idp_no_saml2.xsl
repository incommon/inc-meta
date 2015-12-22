<?xml version="1.0" encoding="UTF-8"?>
<!--

	check_idp_no_saml2.xsl

-->
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:ds="http://www.w3.org/2000/09/xmldsig#"
	xmlns:md="urn:oasis:names:tc:SAML:2.0:metadata"
	xmlns:saml="urn:oasis:names:tc:SAML:2.0:assertion"
	xmlns:shibmd="urn:mace:shibboleth:metadata:1.0"
	xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
	xmlns:idpdisc="urn:oasis:names:tc:SAML:profiles:SSO:idp-discovery-protocol"
	xmlns="urn:oasis:names:tc:SAML:2.0:metadata">

	<!--
		Common support functions.
	-->
	<xsl:import href="../_rules/check_framework.xsl"/>

	<xsl:template match="md:IDPSSODescriptor
		[not(md:SingleSignOnService[@Binding='urn:oasis:names:tc:SAML:2.0:bindings:HTTP-Redirect'])]">
		<xsl:call-template name="error">
			<xsl:with-param name="m">IdP does not support the SAML 2 HTTP-Redirect binding</xsl:with-param>
		</xsl:call-template>
	</xsl:template>

</xsl:stylesheet>
