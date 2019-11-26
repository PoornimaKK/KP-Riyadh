<%inherit file="/Object_tem.mako"/>
<%! class_ = "HMITrainAttributes" %>

<%block name="classes">
	<Class name="HMITrainAttributes">
	     <Objects>
			 <!-- Template for generating Object's from template Train_Unit-->
			 <xsl:apply-templates select="//Trains_Unit/Train_Unit"/>
		 </Objects>
	</Class>
</%block>

<!-- Template for generating Object's from Table Train_Unit-->
<xsl:template match="Train_Unit">
	<xsl:variable name="TrainName" select="concat('Train',format-number(@ID,'000'))"/>
	<Object name="{$TrainName}.Attributes.Riyadh" rules="update_or_create">
		<Properties>
			${props([('TrainName','string','<xsl:value-of select="$TrainName"/>'),('bool_1','string','TEST_MODE_STATUS'),
		         ('bool_2','string','MAINTAIN_DOORS_CLOSE_COMPLETED'),('bool_3','string','CAB_DEACTIVATION_COMPLETE'),
				 ('bool_4','string','COUPLING_AVAILABLE_CAB_1'),('bool_5','string','COUPLING_AVAILABLE_CAB_2'),('bool_6','string','TF_CCHold'),
				 ('bool_7','string','CCGoingToEOAForRescue'),('bool_8','string','CCEOAForRescueReached'),('bool_9','string','CCSMIRescueCouplingActive'),
				 ('ustr_1','string','TM1StopAreaName'),('bstr_2','string','ATCSectorId'), ('long_1','string','DEFAULT_TM_CAUSES'),('bstr_3','string','TFCharacteristic'),('bstr_4','string','FrontTPID'),('bstr_5','string','RSTrainDoorIsolationOnSideA'),('bstr_6','string','RSTrainDoorIsolationOnSideB'),('long_3','string','CCMotionContext'),
				 ('long_4','string','CCSpeed'),('long_5','string','CCMaxSpeed'),('long_6','string','TF_TrainOperatingMode'),
				 ('long_7','string','CCDrivingMode'),('long_8','string','CCCoreResetStatus'),('long_9','string','CCEBStatus')])}
			${multilingualvalue("$TrainName")}
		</Properties>
	</Object>
	<Object name="{$TrainName}.Attributes" rules="update_or_create">
		<Properties>
			${props([('TrainName','string', '<xsl:value-of select="$TrainName"/>'), ('bstr_5','string','RollingStockID'),('long_2','string','TFDirection'),('long_7','string','CCCouplingStatus'),
			         ('long_9','string','CCTrainID'), ('bool_2','string','EB_RELEASE_REQUEST_FBK'), ('bool_3','string','PROHIBITION_UTO_AUTHORISATION_FBK'), ('bool_5','string','PROHIBITION_ATPM_AUTHORISATION_FBK'), ('bool_6','string','WASHING_MODE_STATE_REQUEST_FBK'), ('bool_7','string','STATION_RESTRICTION_INHIBITED_FBK'),
			         ('bool_8','string','CCGoingToDefaultSSA'), ('bool_9','string','ImmobilisationStatus'), ('bstr_7','string','TFAdjacentLeft'),('bstr_8','string','TFAdjacentRight')])}
			${multilingualvalue("$TrainName")}
		</Properties>
	</Object>
</xsl:template>

## ********************************************** -->
##               PYTHON PART                      -->
## ********************************************** -->
<%namespace file="/lib_tem.mako" import="multilingualvalue, props"/>
