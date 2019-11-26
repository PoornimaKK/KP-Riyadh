<%inherit file="/SigRules_tem.mako"/>
<%block name="main">
    <xsl:apply-templates select="$sysdb//Train_Unit"/>
</%block>

<!-- List for RSM commands: [(rsmmode, (rsmkeys), (equation values), (equation status))] -->
<% rsmcommand=[('.RSCommand.DrivingMode' , ('RSM_UTO_OFF', 'RSM_UTO_ON', 'RSM_ATPM_OFF', 'RSM_ATPM_ON'), ('!=0','==0','!=0','==0'),(3,3,5,5), ('','','','')), 
('.RSCommand.RescueCoupling', ('RSM_CAB_OFF', 'RSM_CAB_ON', 'RSM_MAINTAIN_DOORS_CLOSED', 'RSM_RELEASE_DOORS'), ('!=0','==0','!=0','==0'),(3,3,2,2),('.Riyadh', '.Riyadh', '.Riyadh', '.Riyadh')),
('.RSCommand.Others', ('RSM_RESET_EB', 'RSM_TEST_OFF', 'RSM_TEST_ON', 'RSM_RESTRICTION_ON', 'RSM_RESTRICTION_OFF'), ('!=0','==0','!=0','==0','!=0'),(2,1,1,7,7), ('','.Riyadh','.Riyadh','','')),
('.RSCommand.Washing', ('RSM_WASHING_ON', 'RSM_WASHING_OFF'), ('!=0','==0'),(6,6),('',''))]
%>

<!-- Template to call Train Units -->
<xsl:template match="Train_Unit">
%	for name, key, value, eqnnum, eqnstr in rsmcommand:
	<xsl:variable name='tt' select="'${name}'"/>
	<xsl:variable name="nm" select="concat('Train', format-number(@ID, '000') , '${name}')"/>
	<xsl:variable name="control" select="concat($nm, 'RSInterposeCmd.IntOutputPlug_1#', position())"/>
	<Equipment name="{$nm}" type="HMITrainRSMCommand" flavor="RSCommand" CommandTimeOut="12">
		<Requisites>${equation(key, value, eqnnum,eqnstr, "REQUISITE")}</Requisites>
		<CommandResults>${equation(key, value, eqnnum,eqnstr,"COMMANDRESULT")}</CommandResults>
	</Equipment>
%	endfor
</xsl:template>   		

## ********************************************** -->
##               PYTHON PART                      -->
## ********************************************** -->

## Mako code to compute equation for each object
<%def name="equation(ky, vl, eqnnum,eqnstr,el)" >
		% for i in range(len(ky)):
			<xsl:variable name='value' select="'${vl[i]}'"/>
			<xsl:variable name='el' select="'${el}'"/>
			<xsl:variable name='key' select="if ($el='COMMANDRESULT') then '${ky[i]}_ERROR' else '${ky[i]}'"/>
			<xsl:variable name='eqnum' select="'${eqnnum[i]}'"/>
			<xsl:variable name='eqstr' select="'${eqnstr[i]}'"/>
			<xsl:variable name="eqn" select="if($el = 'REQUISITE') then '1' else concat('Train', format-number(@ID, '000'), '.Attributes',$eqstr,'.HMITETrain.boolPlug_',$eqnum, $value )"/>
			<Equation><xsl:value-of select="$nm"/>.RSInterposeCmd.IntOutputPlug_1#${i+1}[<xsl:value-of select="$key"/>]::<xsl:value-of select="$eqn"/></Equation>		
		% endfor
</%def>