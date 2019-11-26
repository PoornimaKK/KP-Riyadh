<%inherit file="/Object_tem.mako"/>
<%! class_ = "TPBerthTUView" %>

<%block name="classes">
	<Class name="TPBerthTUView">
    	<Objects>
    	  <xsl:apply-templates select="//Block[sys:sigarea/@id =$SERVER_ID]"/>
  		</Objects>
    </Class>
</%block>

<!-- This block will calculate properties and multilingual value of TPPerthTUView -->
<xsl:template match="Block">
	<xsl:variable name="ttnm" select="concat('TI_', @Name, '.TrainIndicator')"/>
	<xsl:variable name="ori" select="Block_Orientation[1]"/>
	<Object name="{$ttnm}" rules="update_or_create">
   		<Properties>
	   		 ${props([	
						('long_5','string','SituationType'),
						('long_6','string','CCCouplingStatus'),
						('long_7','string','CCDrivingMode'),
	   		 			('long_8','string','TF_TrainOperatingMode'), 
     		 			('bstr_1','string','RollingStockID'),
        	 			('long_2','string','Direction'),
        	 			('bool_7','string','LEAVE_NOW_ATS_COMMUNICATION'),
        	 			('TrainNumber','i4','1')])} 
       		<Property name="Orientation" dt="string"><xsl:value-of select="if ($ori='Down') then 'Left' else 'Right' "/></Property>			
        	<PropertyList name="TrackPortion">
            	<ListElem index="1" dt="string">TI_<xsl:value-of select="@Name"/>.TrackPortion</ListElem>
            </PropertyList>
            ${multilingualvalue("$ttnm")}            		
		</Properties>
	</Object>
	<xsl:variable name="ttnm" select="concat('TI_', @Name , '.MultiTrainIndicator')"/>
	<Object name="{$ttnm}" rules="update_or_create">
		<Properties>
			${props([('bstr_1','string','RollingStockID'),
        		('bstr_3','string','DestinationCode'),
        		('long_1','string','TrainCode'),
        		('long_2','string','Direction'),
        		('long_7','string','CCDrivingMode'),
        		('long_8','string','TF_TrainOperatingMode'),
        		('bool_1','string','Associated'),
				('long_5','string','SituationType'),
        		('TrainNumber','i4','2')])}
				<Property name="Orientation" dt="string"><xsl:value-of select="if ($ori='Down') then 'Left' else 'Right' "/></Property>			
        	
				<PropertyList name="TrackPortion">
					<ListElem index="1" dt="string">TI_<xsl:value-of select="@Name"/>.TrackPortion</ListElem>
				</PropertyList>
				${multilingualvalue("$ttnm")}
		</Properties>	
	</Object>    
</xsl:template>

## ********************************************** -->
##               PYTHON PART                      -->
## ********************************************** -->

<%namespace file="/lib_tem.mako" import="multilingualvalue, props"/>
