<%inherit file="/Object_tem.mako"/>
<%! class_ = "OPCMModule" %>

<%block name="classes">
	<Class name="OPCMModule">
		<Objects>
			<Object name="ATS-ISM" rules="update_or_create"/>
		</Objects>
	</Class>
</%block>
