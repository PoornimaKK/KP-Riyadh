<%inherit file="/Object_tem.mako"/>
<%! class_ = "WashingMachine" %>

<%block name="classes">
  	<Class name="WashingMachine">
  		<Objects>
  			<Object name="WashingMachine" rules="update_or_create">
				<Properties>
					${props([("ID", "string" ,'WashingMachine'),
							 ("SharedOnIdentifier", "string", 'WashingMachine')])}
				</Properties>
			</Object>
  		</Objects>
  	</Class>
</%block>
## ********************************************** -->
##               PYTHON PART                      -->
## ********************************************** -->
<%namespace file="/lib_tem.mako" import="props,multilingualvalue"/>