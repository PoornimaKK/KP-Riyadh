<%inherit file="/Object_tem.mako"/>
<%! class_ = "AlarmRiyadhLV2" %>

<%block name="classes">
	%for mod in ['ARS','HSM','CAL','WSH','TPM']:
		<Class name="Alarm${mod}Module">
			<Objects>
				<Object name="${mod}AE" rules="update_or_create"/>
			</Objects>
		</Class>
	%endfor	
</%block>
