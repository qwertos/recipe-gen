<?xml version="1.0"?>

<xsl:stylesheet version="1.0" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" >

	<xsl:output method="xml" indent="yes" />

	<xsl:template match="/">
		<xsl:apply-templates select="recipe-book" />
	</xsl:template>


	<xsl:template match="recipe-book">
		<TeXML escape="0">
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
			<cmd name="usepackage">
				<parm>fancyhdr</parm>
			</cmd>
			<cmd name="pagestyle">
				<parm>fancy</parm>
			</cmd>
			<cmd name="cfoot">
				<parm>\thepage</parm>
			</cmd>
			<cmd name="lhead">
				<parm>
					<xsl:value-of select="title" />
				</parm>
			</cmd>
			<cmd name="rhead">
				<parm>
					<xsl:value-of select="author" />
				</parm>
			</cmd>
			<cmd name="title">
				<parm>
					<xsl:value-of select="title" />
				</parm>
			</cmd>
			<cmd name="author">
				<parm>
					<xsl:value-of select="author" />
				</parm>
			</cmd>
			<env name="document">
				<cmd name="maketitle" />
				<xsl:apply-templates select="recipes" />
			</env>
		</TeXML>
	</xsl:template>


	<xsl:template match="recipes">
		<xsl:apply-templates select="recipe" />
	</xsl:template>


	<xsl:template match="recipe">
		<xsl:choose>
			<xsl:when test="@href">
				<xsl:apply-templates select="document(@href)/recipe" />
			</xsl:when>
			<xsl:otherwise>
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
				<cmd name="section">
					<parm>
						<xsl:text>Directions</xsl:text>
					</parm>
				</cmd>
				<xsl:apply-templates select="directions" />
			</xsl:otherwise>
		</xsl:choose>
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
		<xsl:if test="amount/@unit != 'natural'">
			<xsl:value-of select="amount/@unit" />
		</xsl:if>
		<xsl:text> </xsl:text>
		<xsl:value-of select="name" />
	</xsl:template>

	<xsl:template match="directions">
		<env name="enumerate">
			<xsl:apply-templates select="step" />
		</env>
	</xsl:template>

	<xsl:template match="step">
		<cmd name="item" />
		<xsl:value-of select="." />
	</xsl:template>




</xsl:stylesheet>


