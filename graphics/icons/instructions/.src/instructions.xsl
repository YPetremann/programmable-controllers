<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:saxon="http://saxon.sf.net/" xmlns="http://www.w3.org/2000/svg">
	<xsl:template match="grid">
		<svg xmlns="http://www.w3.org/2000/svg"
		xmlns:cc="http://creativecommons.org/ns#"
		xmlns:dc="http://purl.org/dc/elements/1.1/"
		xmlns:inkscape="http://www.inkscape.org/namespaces/inkscape"
		xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
		xmlns:sodipodi="http://sodipodi.sourceforge.net/DTD/sodipodi-0.dtd"
		xmlns:svg="http://www.w3.org/2000/svg"
		xmlns:xlink="http://www.w3.org/1999/xlink" width="256px" height="512px" id="svg2" version="1.2" viewBox="0 0 8 16" tag="" >
	<sodipodi:namedview id="namedview9414" showgrid="true" inkscape:window-maximized="0" inkscape:zoom="3" inkscape:cx="46" inkscape:cy="189" inkscape:window-width="1248" inkscape:window-height="998" inkscape:window-x="20" inkscape:window-y="40" inkscape:current-layer="svg2">
		<inkscape:grid id="grid4006" type="xygrid" empspacing="32" color="white" opacity="0.20" empcolor="#3f3f00" empopacity="0.20" />
	</sodipodi:namedview>
	<style>
		* { stroke:none; }
		image { image-rendering:optimizeSpeed; }
		text { font-family:'Visitor TT1 BRK'; font-size:10px;fill:silver;}
		.fill { fill-opacity:0.20; }
		.register { fill:yellow; }
		.value { fill:fuchsia; }
		.cell { fill:lime; }
		.pointer { fill:aqua; }
		.control { fill:#ff7f00; }
		.index { fill:gray; }
		.name { fill:white; }
	</style>
	<defs>
		<pattern width="1" height="1" id="signalpattern" patternUnits="userSpaceOnUse">
			<image x="0" y="0" width="1" height="1" xlink:href="XX.png" />
		</pattern>
		<pattern width="1" height="1" id="signalred" patternUnits="userSpaceOnUse">
			<rect x="3" y="2" width="26" height="26" class="fill" fill="red" transform="scale(0.03125)"/>
		</pattern>
		<pattern width="1" height="1" id="signalblue" patternUnits="userSpaceOnUse">
			<rect x="3" y="2" width="26" height="26" class="fill" fill="blue" transform="scale(0.03125)"/>
		</pattern>
		<pattern width="1" height="1" id="signalgreen" patternUnits="userSpaceOnUse">
			<rect x="3" y="2" width="26" height="26" class="fill" fill="lime" transform="scale(0.03125)"/>
		</pattern>
		<pattern width="1" height="1" id="signalyellow" patternUnits="userSpaceOnUse">
			<rect x="3" y="2" width="26" height="26" class="fill" fill="yellow" transform="scale(0.03125)"/>
		</pattern>
		<pattern width="1" height="1" id="signalpurple" patternUnits="userSpaceOnUse">
			<rect x="3" y="2" width="26" height="26" class="fill" fill="magenta" transform="scale(0.03125)"/>
		</pattern>
	</defs>
	<rect x="0" y="0" width="8" height="16" id="signalbase" style="fill:url(#signalpattern)" />
	<rect x="0" y="1" width="8" height="1" id="fillred" style="fill:url(#signalred)" />
	<rect x="0" y="2" width="8" height="2" id="fillblue" style="fill:url(#signalblue)" />
	<rect x="0" y="4" width="8" height="4" id="fillgreen" style="fill:url(#signalgreen)" />
	<rect x="0" y="8" width="8" height="4" id="fillyellow" style="fill:url(#signalyellow)" />
	<rect x="0" y="12" width="4" height="4" id="fillyellow" style="fill:url(#signalyellow)" />
	<rect x="4" y="12" width="4" height="4" id="fillpurple" style="fill:url(#signalpurple)" />
	<xsl:apply-templates/>
	</svg>
	</xsl:template>
	<xsl:template match="instruction">
		<xsl:variable name="typeName"><xsl:value-of select="@type"/></xsl:variable>
		<g id="pci-{@id}.png">
			<rect x="{@x}" y="{@y}" width="1" height="1" fill="none" stroke="none"/>
			<text x="4" y="8" xml:space="preserve" transform="matrix(0.03125,0,0,0.03125,{@x},{@y})">
				<tspan x="10" class="index"><xsl:value-of select="@id"/></tspan>
				<tspan x="4" dy="6" class="name"><xsl:value-of select="@name"/></tspan><xsl:if
				test="$typeName = 'value'"><tspan class="value">#</tspan></xsl:if><xsl:if
				test="$typeName = 'register'"><tspan class="register">%</tspan></xsl:if><xsl:if
				test="$typeName = 'cell'"><tspan class="cell">@</tspan></xsl:if><xsl:if
				test="$typeName = 'pointer'"><tspan class="pointer">&amp;</tspan></xsl:if>
				<xsl:apply-templates/>
			</text>
		</g>
	</xsl:template>
	<xsl:template match="line"><tspan x="4" dy="6"><xsl:copy-of select="@*" /><xsl:apply-templates/></tspan></xsl:template>
	<xsl:template match="tspan"><tspan><xsl:copy-of select="@*"/><xsl:apply-templates/></tspan></xsl:template>
	<xsl:template match="value"><tspan class="value"><xsl:copy-of select="@*"/>#</tspan></xsl:template>
	<xsl:template match="register"><tspan class="register"><xsl:copy-of select="@*"/>%</tspan></xsl:template>
	<xsl:template match="cell"><tspan class="cell"><xsl:copy-of select="@*"/>@</tspan></xsl:template>
	<xsl:template match="control"><tspan class="control">§</tspan></xsl:template>
	<xsl:template match="pointer"><tspan class="pointer"><xsl:copy-of select="@*"/>&amp;</tspan></xsl:template>
	<xsl:template match="grabber"><tspan dx="0 -2 -2">&lt;==</tspan></xsl:template>
	<xsl:template match="setter"><tspan dx="0 -2 -2">=</tspan></xsl:template>
	<xsl:template match="then"><tspan>:::</tspan></xsl:template>
	<xsl:template match="else"><tspan>!!:</tspan></xsl:template>
	<xsl:template match="leftshift"><tspan dx="0 -2">&gt;&gt;</tspan></xsl:template>
	<xsl:template match="rightshift"><tspan dx="0 -2">&lt;&lt;</tspan></xsl:template>
	<xsl:template match="and"><tspan>n</tspan></xsl:template>
	<xsl:template match="or"><tspan>u</tspan></xsl:template>
	<xsl:template match="xor"><tspan>v</tspan></xsl:template>
</xsl:stylesheet>
