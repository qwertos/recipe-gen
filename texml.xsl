<?xml version="1.0"?>

<xsl:stylesheet version="1.0" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" >

	<xsl:output method="xml" indent="yes" />

	<xsl:template match="/">
		<TeXML>
			<cmd name="documentclass">
				<opt>letterpaper</opt>
				<parm>report</parm>
			</cmd>
			<cmd name="usepackage">
				<parm>tikz</parm>
			</cmd>
			<cmd name="usepackage">
				<opt>margin=1in</opt>
				<parm>geometry</parm>
			</cmd>
			<env name="document">
				<xsl:apply-templates select="recipe" />
			</env>
		</TeXML>
	</xsl:template>


	<xsl:template match="recipe">
		<cmd name="chapter">
			<parm>
				<xsl:value-of select="name" />
			</parm>
		</cmd>
		<cmd name="section">
			<parm>
				<xsl:text>Ingredients</xsl:text>
			</parm>
		</cmd>
		<xsl:apply-templates select="ingredients" />
	</xsl:template>

	<xsl:template match="ingredients">
		<xsl:if test="@heading">
			<cmd name="subsection">
				<parm>
					<xsl:value-of select="@heading" />
				</parm>
			</cmd>
		</xsl:if>

		<env name="itemize">
			<xsl:apply-templates select="ingredient" />
		</env>
	</xsl:template>

	<xsl:template match="ingredient">
		<cmd name="item" />
		<xsl:value-of select="amount/@value" />
		<xsl:text> </xsl:text>
		<xsl:value-of select="amount/@unit" />
		<xsl:text> </xsl:text>
		<xsl:value-of select="name" />
	</xsl:template>



</xsl:stylesheet>


