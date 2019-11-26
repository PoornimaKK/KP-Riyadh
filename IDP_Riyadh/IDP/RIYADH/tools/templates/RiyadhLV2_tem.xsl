<%inherit file="/Object_tem.mako"/>
<%! class_ = "RiyadhLV2" %>
<%block name="classes">
	<Class name="MainRiyadhLV2">
		<Objects>
			<Object name="MainRiyadhLV2" rules="update_or_create">
				<Properties>
					${props([("PV_WashingProgram","string","WSHPG"),("PV_WashingAvailability","string","WSHAV"),
							 ("PV_FrontWashCompleted","string","WSHFC"),("PV_RearWashCompleted","string","WSHRC"),
							 ("PV_WashCompleted","string","WSHTC")])}
				</Properties>
			</Object>
		</Objects>
	</Class>
	<Class name="JunctionMMGModule">
		<Objects>
			<Object name="CATSRiyadh" rules="update_or_create">
				<Properties>
					${props([("OperatingModeConfiguration","string",'CMMGCentralRiyadh_<xsl:value-of select="$SERVER_ID"/>')])}
				</Properties>
			</Object>
		</Objects>
	</Class>
</%block>
## ********************************************** -->
##               PYTHON PART                      -->
## ********************************************** -->
<%namespace file="/lib_tem.mako" import="props"/>