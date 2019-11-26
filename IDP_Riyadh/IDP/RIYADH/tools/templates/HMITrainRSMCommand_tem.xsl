<%inherit file="/Object_tem.mako"/>
<%! class_ = "HMITrainRSMCommand" %>

<!-- List for RSM commands: [(rsmmode, (rsmcommand), (rsmfield), (rsmvalue))] -->
<% rsmcommand=[('.RSCommand.DrivingMode' , ('RSCommand1', 'RSCommand2', 'RSCommand3', 'RSCommand4'), ('UTO_PROHIBITION', 'UTO_PROHIBITION', 'ATPM_PROHIBITION', 'ATPM_PROHIBITION'), ('01', '00', '01', '00')), 
('.RSCommand.RescueCoupling', ('RSCommand1','RSCommand2', 'RSCommand3', 'RSCommand4'), ('ACTIVE_CAB_REQUEST', 'ACTIVE_CAB_REQUEST', 'MAINTAIN_DOORS_CLOSED', 'MAINTAIN_DOORS_CLOSED'), ('01', '00', '01', '00')),
('.RSCommand.Others', ('RSCommand1', 'RSCommand2', 'RSCommand3', 'RSCommand4', 'RSCommand5'), ('EB_RELEASE_REQUEST', 'TEST_MODE_REQUEST', 'TEST_MODE_REQUEST', 'STATION_RESTRICTION_INHIBITION', 'STATION_RESTRICTION_INHIBITION'), ('01', '00', '01', '00', '01')),
('.RSCommand.Washing', ('RSCommand1', 'RSCommand2'), ('WASHING_STATE_REQUEST', 'WASHING_STATE_REQUEST'), ('01', '00'))] 
%>

<%block name="classes">
	 <Class name='HMITrainRSMCommand'>
	 	<Objects>
	 		<xsl:apply-templates select="$sysdb//Train_Unit"/>
	 	</Objects>
	 </Class>
</%block>

<!-- Template to call Train Units -->
<xsl:template match="Train_Unit">
%	for name, cmmd, field, value in rsmcommand:
	<xsl:variable name='tt' select="concat('Train', format-number(@ID, '000') , '${name}')"/>
	<xsl:variable name="nm" select="concat('Train', format-number(@ID, '000'))"/>
	<xsl:variable name="rsid" select="current()/RS_Identifier"/>
	<Object name="{$tt}" rules="update_or_create">
		<Properties>
			${props([('SharedOnIdentifier','string','<xsl:value-of select="$tt"/>'),('SharedOnIdentifierDefinition','boolean','1')])}	
			% for i in range(len(cmmd)):
			<xsl:variable name="rsmcommand">%RollingStockID%|<xsl:value-of select="$rsid"/>|XmlRSMCommand|&lt;GenericSettingRequest&gt;&lt;Field name="${field[i]}" value="${value[i]}" DEMUX="1"/&gt;&lt;/GenericSettingRequest&gt;</xsl:variable>
				${prop(cmmd[i], '<xsl:value-of select="$rsmcommand"/>' , 'string')}
			% endfor
			${multilingualvalue("$nm")}
		</Properties>
	</Object>
%	endfor
</xsl:template>   		

## ********************************************** -->
##               PYTHON PART                      -->
## ********************************************** -->

<%namespace file="/lib_tem.mako" import="props, prop, multilingualvalue"/>
