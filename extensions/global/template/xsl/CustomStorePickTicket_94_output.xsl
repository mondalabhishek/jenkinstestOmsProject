<!--
Licensed Materials - Property of IBM
IBM Sterling Selling and Fulfillment Suite - Foundation
(C) Copyright IBM Corp. 2007, 2012 All Rights Reserved.
US Government Users Restricted Rights - Use, duplication or disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
-->
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fn="http://www.w3.org/2005/xpath-functions" xmlns:java="http://xml.apache.org/xslt/java"
	xmlns:fopUtil="com.yantra.pca.ycd.fop.YCDFOPUtils" exclude-result-prefixes="java">
	<xsl:import href="/template/prints/ycd/xsl/CommonTemplates_HTML.xsl"/>
	<xsl:output method="html" encoding="UTF-8" indent="yes" />
 	<xsl:variable name="ireport.scriptlethandling" select="2"/>
	<xsl:variable name="ireport.encoding" select="UTF-8"/>
	<xsl:variable name="DelMethodShip">SHP</xsl:variable>
	<xsl:variable name="DelMethodPick">PICK</xsl:variable>
	<xsl:variable name="DelMethodDel">DEL</xsl:variable>

 	<xsl:variable name="locale">
		<xsl:value-of select="/MultiApi/API[@Name='getOrganizationHierarchy']/Output/Organization/@LocaleCode" />
	</xsl:variable>

	<xsl:template match="/">
		<xsl:apply-templates select="/MultiApi" />
	</xsl:template>
	<xsl:template match="MultiApi">
		<html>
			<xsl:attribute name="lang">
				<xsl:value-of select="$locale" />
			</xsl:attribute>
			<body>
			<style>
				<xsl:text disable-output-escaping="yes">
					body {
						font-family: "HelvNeueRomanforIBM", Helvetica, Arial, Tahoma, Verdana, sans-serif;
						font-size: 12px;
					}
			
					table {
						font-size: 12px;
					}
			
					div.page {
						width: 100%;
					}
					div.page:not(:last-child) {
						page-break-after: always;
					}
					div.already_printed, div.already_printed table {
						color: #666;
					}
			
					.storedetails {
						width: 100%;
					}
					.storedetails td {
						width: 50%;
					}
					.storedetails td:first-child{
						font-size: 40px;
						color: #C8C8F8;
					}
			
					.storedetails .storeaddress {
						float: right;
					}
			
					.storedetails .storeaddress .company {
						font-weight: bold;
					}
			
					.title {
							text-align: center;
							font-size: 25px;
							background-color: #C8C8F8;
							padding: 2px 0px;
					}
						
					.orderheader {
						padding-top: 10px;
						width:100%;
					}
					.orderheader table {
						border-spacing: 0px 5px;
					}
			
					.orderheader table tr td:first-child {
						font-weight: bold;
						padding-right: 20px;
						padding-left: 5px;
					}
			
					.orderheader .currentdate {
						vertical-align:top;
					}
			
					.orderheader .currentdate table{
						float: right;
					}
			
					.orderheader .addressheader {
						background-color: C8C8F8;
					}
			
					.orderheader .addressheader td{
						padding: 5px;
					}
			
					.orderheader table tr.addressdetails td{
						font-weight: normal;
					}
			
					table.shipmentlines {
						width: 100%;
						margin-left: 5px;
					}
			
					table.shipmentlines, table.shipmentlines th, table.shipmentlines td {
						border:1px solid;
						border-collapse: collapse;
						padding: 2px 2px;
					}
			
					table.shipmentlines th {
						padding: 5px 2px;
						background-color:#DDDDDD;
					}
			
					.footer {
						padding-top: 10px;
						bottom:0px;
						text-align:center;
					}

				</xsl:text>
			</style>
			<xsl:for-each select="API[(normalize-space(@Name) = &quot;getSortedShipmentDetails&quot;)]">
				<div>
				<xsl:attribute name="class">
					<xsl:text>page </xsl:text>
					<xsl:if test="Output/Shipment/@PickTicketPrinted = 'Y'">
						<xsl:text>already_printed</xsl:text>
					</xsl:if>
				</xsl:attribute>
				<xsl:apply-templates select="Output/Shipment" />
				<footer class="footer">
				<xsl:if test="Output/Shipment/@PickTicketPrinted = 'Y'">
					<div><xsl:text>REPRINT</xsl:text></div>
				</xsl:if>
				<div><xsl:text>---END OF PICK TICKET---</xsl:text></div>
				</footer>
				</div>
			</xsl:for-each>
		</body>
		</html>
	</xsl:template>

	<xsl:template match="Shipment">
		<xsl:apply-templates select="ShipNode" />
		<div class="title"><xsl:value-of select="fopUtil:getLocalizedString('PICK TICKET',$locale)" /></div>
		<xsl:variable name="Instruction" select="Instructions/Instruction/@InstructionText" />
		<xsl:variable name="City" select="ToAddress/@City" />
		<xsl:variable name="State" select="ToAddress/@State" />
		<xsl:variable name="ShortZipCode" select="ToAddress/@ShortZipCode" />
		<xsl:variable name="FormattedCityStateZipCodeStore">
		    <xsl:value-of select="concat($City,',' ,$State,',', $ShortZipCode)" />
		</xsl:variable>
		

		<table class="orderheader">
			<tr>

				<td>
					<table>
							<tr>
								<td>
									<xsl:value-of select="fopUtil:getLocalizedString('Order Number:',$locale)" />
								</td>
								<td>
									<xsl:value-of select="fopUtil:getDisplayOrderNo(@DisplayOrderNo)" />
								</td>
							</tr>
						<xsl:if test="@DeliveryMethod=$DelMethodPick">							
							<tr>
								<td>
									<xsl:value-of select="fopUtil:getLocalizedString('Store Notified On:',$locale)" />
								</td>

								<td>
									<xsl:value-of select="fopUtil:getFormattedDateTime(@ShipDate,$locale)" />
								</td>
							</tr>
							<tr>
								<td>
									<xsl:value-of select="fopUtil:getLocalizedString('Pick Up Date:',$locale)" />
								</td>

								<td>
									<xsl:value-of select="fopUtil:getFormattedDateTime(@RequestedShipmentDate,$locale)" />
								</td>
							</tr>
							<tr>
								<td>
									<xsl:value-of select="fopUtil:getLocalizedString('Customer Name:',$locale)" />
								</td>
								<td>
									<xsl:value-of select="concat(ToAddress/@FirstName,' ',ToAddress/@LastName)"/>
								</td>
							</tr>

							
						</xsl:if>
								
						  <xsl:if test="@DeliveryMethod=$DelMethodShip"> 
							 <tr>
								<td>
									<xsl:value-of select="fopUtil:getLocalizedString('Expected Delivery Date:',$locale)" />
								</td>
								<td>
									<xsl:value-of select="fopUtil:getFormattedDate(@ExpectedDeliveryDate,$locale)" />   
								</td>
							</tr> 
							<tr class="addressheader">
								<td colspan="2">
									<xsl:value-of select="fopUtil:getLocalizedString('Ship To',$locale)" />
								</td>
							</tr>
							<tr class="addressdetails">
								<td colspan="2">
									<div><xsl:value-of select="ToAddress/@Company" /></div>
									<div><xsl:value-of select="ToAddress/@AddressLine1" /></div>
									<div><xsl:value-of select="ToAddress/@AddressLine2" /></div>
									<div><xsl:value-of select="$FormattedCityStateZipCodeStore" /></div>
									<div><xsl:value-of select="ToAddress/@Country" /></div>
									<div><xsl:value-of select="ToAddress/@DayPhone" /></div>
									<div><xsl:value-of select="ToAddress/@EmailID" /></div>
								</td>
							</tr>
						 </xsl:if> 
					</table>
					</td>

					 <td>
						<xsl:if	test="$Instruction != ''">
							<xsl:if	test="@DeliveryMethod=$DelMethodShip">
							</xsl:if>
							<div><xsl:value-of select="fopUtil:getLocalizedString('Special Instructions',$locale)" /></div>
							<div id="instruction"><xsl:value-of select="$Instruction" /></div>
						</xsl:if>
					</td>
					
					<td class="currentdate">
						<table>
							<tr>
								<td>
									<xsl:value-of select="fopUtil:getLocalizedString('Current Date:',$locale)" />
								</td>
								<td>
									<xsl:value-of select="fopUtil:getCurrentDate($locale,'true')" />
								</td>
					  		</tr>
							<tr>
								<td>
									<xsl:value-of select="fopUtil:getLocalizedString('Staging Location:',$locale)" />
								</td>
								<td>
								</td>
							</tr>
					  	</table>
					</td>
				</tr>
		</table> 

		 <xsl:apply-templates select="ShipmentLines" /> 
	</xsl:template>
	

	<xsl:template match="ShipmentLines">
		<table class="shipmentlines">
			<thead>
				<tr>
					<th>
						<xsl:value-of select="fopUtil:getLocalizedString('Sl. No',$locale)" />
					</th>
					<th>
						<xsl:value-of select="fopUtil:getLocalizedString('Product ID',$locale)" />
					</th>
					<th>
						<xsl:value-of select="fopUtil:getLocalizedString('Product Description',$locale)" />
					</th>
					<th>
						<xsl:value-of select="fopUtil:getLocalizedString('DepartmentCode',$locale)" />
					</th>
					<th>
						<xsl:value-of select="fopUtil:getLocalizedString('Original Quantity',$locale)" />
					</th>
					<th>
						<xsl:value-of select="fopUtil:getLocalizedString('Picked Quantity',$locale)" />
					</th>
					<th>
						<xsl:value-of select="fopUtil:getLocalizedString('UOM',$locale)" />
					</th>					
				</tr>
			</thead>
			<xsl:for-each select="ShipmentLine">
				<tr>
					<xsl:variable name="i" select="position()" />
					<td>
						<xsl:value-of select="$i" />
					</td>
					<td>
						<xsl:value-of select="@ItemID" />
					</td>
					<td>
						<xsl:value-of select="OrderLine/ItemDetails/PrimaryInformation/@ExtendedDisplayDescription" />
					</td>
					<td><xsl:value-of select="@DepartmentCode" /></td>
					<td style="text-align:right">
						<xsl:variable name="lineQty" select="@Quantity" />
						<xsl:variable name="lineUOM" select="@UnitOfMeasure" />
						<xsl:value-of select="concat(fopUtil:getFormattedDouble($lineQty,$locale),' ',/MultiApi/API[@Name='getItemUOMMasterList']/Output/ItemUOMMasterList/ItemUOMMaster[@UnitOfMeasure=$lineUOM]/@Description)" />
					</td>
					
					<td></td>
					<td></td>
				</tr>
			</xsl:for-each>
		</table>
	</xsl:template>
</xsl:stylesheet>
