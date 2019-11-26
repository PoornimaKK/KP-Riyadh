<%inherit file="/Group_tem.mako"/>

<%block name="classes">
	%for mod in ['ARS','HSM','CAL','WSH','TPM']:
		<Class name="Alarm${mod}Module" rules="update" traces="error">
			<Objects>
				<Object name="${mod}AE" rules="update" traces="error">
					<Properties>
						<Property name="AreaGroup" dt="string">Area/LI_RM3_46</Property>
						<Property name="FunctionGroup" dt="string">Function/Regulation</Property>
					</Properties>
				</Object>
			</Objects>
		</Class>
	%endfor	
</%block>



