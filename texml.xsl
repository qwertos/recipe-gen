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
				<parm>hyperref</parm>
			</cmd>
			<cmd name="usepackage">
				<opt>margin=1in</opt>
				<parm>geometry</parm>
			</cmd>
			<cmd name="usepackage">
				<parm>fancyhdr</parm>
			</cmd>
			<cmd name='usepackage'>
				<parm>xfrac</parm>
			</cmd>
			<cmd name="pagestyle">
				<parm>fancyplain</parm>
			</cmd>
			<cmd name="cfoot">
				<parm>\thepage</parm>
			</cmd>
			<cmd name="lhead">
				<parm>
					<cmd name="MakeUppercase">
						<parm>\parttitle</parm>
					</cmd>
				</parm>
			</cmd>
			<cmd name="rhead">
				<parm>\leftmark</parm>
			</cmd>
			<cmd name="renewcommand">
				<parm>\plainheadrulewidth</parm>
				<parm>0.4pt</parm>
			</cmd>
			<cmd name="newcommand">
				<parm>\parttitle</parm>
				<parm>
					<xsl:value-of select="title" />
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
			<cmd name="setcounter">
				<parm>secnumdepth</parm>
				<parm>-2</parm>
			</cmd>
			<cmd name="setcounter">
				<parm>tocdepth</parm>
				<parm>0</parm>
			</cmd>
			<env name="document">
				<cmd name="maketitle" />
				<cmd name="tableofcontents" />
				<xsl:apply-templates select="recipes" />
			</env>
		</TeXML>
	</xsl:template>


	<xsl:template match="recipes">
		<xsl:if test="@heading">
			<cmd name="renewcommand">
				<parm>\parttitle</parm>
				<parm>
					<xsl:value-of select="/recipe-book/title" />
				</parm>
			</cmd>
			<cmd name="part">
				<parm>
					<xsl:value-of select="@heading" />
				</parm>
			</cmd>
			<cmd name="renewcommand">
				<parm>\parttitle</parm>
				<parm>
					<xsl:value-of select="@heading" />
				</parm>
			</cmd>
		</xsl:if>
		<xsl:apply-templates select="recipe" />
		<cmd name="newpage"/>
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
				<xsl:if test="source">
					<cmd name="section">
						<parm>Source</parm>
					</cmd>
					<xsl:choose>
						<xsl:when test="source/a">
							<cmd name="href">
								<parm>
									<xsl:value-of select="source/a/@href" />
								</parm>
								<parm>
									<xsl:choose>
										<xsl:when test="source/a/text()">
											<xsl:value-of select="source/a" />
											<cmd name="footnote">
												<parm>
													<xsl:value-of select="source/a/@href" />
												</parm>
											</cmd>
										</xsl:when>
										<xsl:otherwise>
											<xsl:value-of select="source/a/@href" />
										</xsl:otherwise>
									</xsl:choose>
								</parm>
							</cmd>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="source" />
						</xsl:otherwise>
					</xsl:choose>
				</xsl:if>
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
		<xsl:apply-templates select="amount[1]" />
		<xsl:if test="amount[1]/@range">
			<xsl:text> - </xsl:text>
			<xsl:variable name="unit" select="amount[1]/@unit" />
			<xsl:apply-templates select="amount[( @unit = $unit ) and ( @range = 'max' )]/@value" />
		</xsl:if>
		<xsl:text> </xsl:text>
		<xsl:if test="amount/@unit != 'natural'">
			<xsl:value-of select="amount/@unit" />
		</xsl:if>
		<xsl:text> </xsl:text>
		<xsl:value-of select="name" />
		<xsl:for-each select="note">
			<xsl:text>( </xsl:text>
			<xsl:value-of select="."/>
			<xsl:text> )</xsl:text>
		</xsl:for-each>
		<xsl:apply-templates select="footnote" />
	</xsl:template>

	<xsl:template match="amount">
		<xsl:choose>
			<xsl:when test="floor(@value) = @value">
				<xsl:value-of select='@value' />
			</xsl:when>

			<xsl:otherwise>
				<xsl:variable name="whole" select="floor(@value)" />
				<xsl:variable name="part" select="@value - $whole" />

				<xsl:if test="$whole != 0">
					<xsl:value-of select="$whole" />
				</xsl:if>

				<xsl:choose>
					<xsl:when test="$part = 0.25">
						<cmd name="sfrac">
							<parm>1</parm>
							<parm>4</parm>
						</cmd>
					</xsl:when>

					<xsl:when test="$part = 0.33">
						<cmd name="sfrac">
							<parm>1</parm>
							<parm>3</parm>
						</cmd>
					</xsl:when>

					<xsl:when test="$part = 0.5">
						<cmd name="sfrac">
							<parm>1</parm>
							<parm>2</parm>
						</cmd>
					</xsl:when>

					<xsl:when test="$part = 0.66">
						<cmd name="sfrac">
							<parm>2</parm>
							<parm>3</parm>
						</cmd>
					</xsl:when>

					<xsl:when test="$part = 0.75">
						<cmd name="sfrac">
							<parm>3</parm>
							<parm>4</parm>
						</cmd>
					</xsl:when>

					<xsl:otherwise>
						<xsl:value-of select="$part" />
					</xsl:otherwise>
				</xsl:choose>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="directions">
		<xsl:if test="@heading">
			<cmd name="subsection">
				<parm>
					<xsl:value-of select="@heading" />
				</parm>
			</cmd>
		</xsl:if>

		<env name="enumerate">
			<xsl:apply-templates select="step" />
		</env>
	</xsl:template>

	<xsl:template match="step">
		<cmd name="item" />
		<xsl:value-of select="." />
		<xsl:apply-templates select="footnote" />
	</xsl:template>

	<xsl:template match="footnote">
		<cmd name="footnote">
			<parm>
				<xsl:value-of select="."/>
			</parm>
		</cmd>
	</xsl:template>




</xsl:stylesheet>


