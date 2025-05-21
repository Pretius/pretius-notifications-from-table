function f_render (
	p_dynamic_action in apex_plugin.t_dynamic_action,
	p_plugin         in apex_plugin.t_plugin 
) return apex_plugin.t_dynamic_action_render_result is
	C_ATTR_CALLBACKS_INTERVAL CONSTANT p_dynamic_action.attribute_01%type := nvl(p_dynamic_action.attribute_01, 10000);
	C_ATTR_SETTINGS           CONSTANT p_dynamic_action.attribute_09%type := p_dynamic_action.attribute_09;
    C_RENDER_TIME             CONSTANT date := SYSDATE;
    l_result                  apex_plugin.t_dynamic_action_render_result;
begin
	if apex_application.g_debug then
		apex_plugin_util.debug_dynamic_action (
			p_plugin         => p_plugin,
			p_dynamic_action => p_dynamic_action 
		);
	end if;

	apex_javascript.add_library (
		p_name      => 'notificationsFromTable',
		p_directory => p_plugin.file_prefix,
		p_version   => null 
	);

    l_result.ajax_identifier := apex_plugin.get_ajax_identifier;
    l_result.javascript_function :=
        'function(){
            notificationsFromTable.start({'                                                                 ||
                        apex_javascript.add_attribute('ajaxIdentifier',		l_result.ajax_identifier)	    ||       
            			apex_javascript.add_attribute('callbackInterval',	C_ATTR_CALLBACKS_INTERVAL)	    ||
                        apex_javascript.add_attribute('renderTime',			C_RENDER_TIME)	                ||
            			apex_javascript.add_attribute('settings',	        C_ATTR_SETTINGS , false, false )||    
                    '});
        }
        ';

    return l_result;

exception
	when others then 
		apex_error.add_error (
			p_message          => 'Pretius Notifications from table: Unidentified error occured. </br> 
														 SQLERRM: '|| SQLERRM || '</br> 
														 Contact application administrator.',
			p_display_location => apex_error.c_inline_in_notification  
		);

end f_render;

function f_ajax (
    p_plugin          in apex_plugin.t_plugin,
    p_dynamic_action  in apex_plugin.t_dynamic_action
) return apex_plugin.t_dynamic_action_ajax_result is
    l_result                            apex_plugin.t_dynamic_action_ajax_result;
    l_operation                         varchar2(50)  := apex_application.g_x01;
    l_notification_id                   number        := to_number(apex_application.g_x02);
    l_render_time                       varchar2(250) := apex_application.g_x03;

    C_ATTR_NOTIFICATIONS_SOURCE_QUERY       CONSTANT p_dynamic_action.attribute_02%type := p_dynamic_action.attribute_02;
    C_ATTR_EXECUTE_PLSQL                    CONSTANT p_dynamic_action.attribute_08%type := p_dynamic_action.attribute_08;
    C_ATTR_SETTINGS                         CONSTANT p_dynamic_action.attribute_09%type := p_dynamic_action.attribute_09;

    C_ATTR_MAPPING_PRIMARY_KEY              CONSTANT p_dynamic_action.attribute_03%type := p_dynamic_action.attribute_03;
	C_ATTR_MAPPING_NOTIFICATION_TYPE        CONSTANT p_dynamic_action.attribute_04%type := p_dynamic_action.attribute_04;
	C_ATTR_MAPPING_EVENT_NAME               CONSTANT p_dynamic_action.attribute_05%type := p_dynamic_action.attribute_05;
	C_ATTR_MAPPING_NOTIFICAITON_MESSAGE     CONSTANT p_dynamic_action.attribute_06%type := p_dynamic_action.attribute_06;
    C_ATTR_MAPPING_CREATED_ON               CONSTANT p_dynamic_action.attribute_10%type := p_dynamic_action.attribute_10;         

    l_query_transformed                 varchar2(32767);
    l_context                           apex_exec.t_context;
    l_export                            apex_data_export.t_export;
begin
	--debug
	if apex_application.g_debug then
		apex_debug.info('Pretius Notifications From Table - AJAX Callback initiated. Command: ' || l_operation);
	end if;

    if l_operation = 'GET_NOTIFICATIONS' then
        --------------------------------------------------------------------------------
        -- Transform the source query so that the result contains aliased columns:
        -- id, type, title, message
        --------------------------------------------------------------------------------

        l_query_transformed :=
            'select ' || 
                C_ATTR_MAPPING_PRIMARY_KEY          || ' as id, '     ||
                C_ATTR_MAPPING_NOTIFICATION_TYPE    || ' as type, '   ||
                C_ATTR_MAPPING_EVENT_NAME           || ' as event_name, '  ||
                C_ATTR_MAPPING_NOTIFICAITON_MESSAGE || ' as message ' ||
            'from (' || C_ATTR_NOTIFICATIONS_SOURCE_QUERY || ')';

        if  instr(C_ATTR_SETTINGS, 'ONLY_NEW_NOTIFICATIONS') > 0 then
            l_query_transformed := l_query_transformed || 
                ' where ' || C_ATTR_MAPPING_CREATED_ON || ' > to_date(''' || l_render_time || ''', ''DD-MM-YYYY HH24:MI:SS'')';
        end if;

	    if apex_application.g_debug then
	    	apex_debug.info('Pretius Notifications From Table - AJAX Callback. Fetching notifications, query: ' || l_query_transformed);
	    end if;            

        --------------------------------------------------------------------------------
        -- Open the query context using APEX_EXEC and export the result as JSON (CLOB)
        --------------------------------------------------------------------------------
        l_context := apex_exec.open_query_context(
            p_location => apex_exec.c_location_local_db,
            p_sql_query => l_query_transformed
        );
        l_export := apex_data_export.export(
            p_context => l_context,
            p_format  => apex_data_export.c_format_json,
            p_as_clob => true
        );
        apex_exec.close(l_context);

        --apex_json.initialize_clob_output;
        apex_json.open_object;     
        apex_json.write('data', l_export.content_clob);
        apex_json.close_object;

    elsif l_operation = 'EXECUTE_PLSQL' then
    
        if p_dynamic_action.attribute_08 is null then
            raise_application_error(-20004, 'Custom PL/SQL action not defined.');
        end if;

        --------------------------------------------------------------------------------
        -- In the developer's code, the token :NOTIFICATION_ID is expected.
        -- Perform a simple replacement of this token with the safe value.
        --------------------------------------------------------------------------------
        apex_plugin_util.execute_plsql_code (
            p_plsql_code => replace(C_ATTR_EXECUTE_PLSQL, ':NOTIFICATION_ID', to_char(l_notification_id) ) 
        );

        apex_json.open_object;
        apex_json.write('status', 'OK');
        apex_json.close_object;

    else
        apex_json.open_object;
        apex_json.write('status', 'Invalid request');
        apex_json.close_object;
    end if;

    return l_result;

exception
    when others then
        apex_json.open_object;
        apex_json.write('error', apex_escape.html(sqlerrm));
        apex_json.close_object;

		apex_json.close_all;     
		apex_error.add_error (
			p_message          => 'Pretius Notifications from table: Unidentified error occured. </br> 
														 SQLERRM: '|| SQLERRM || '</br> 
														 Contact application administrator.',
			p_display_location => apex_error.c_inline_in_notification  
		);        
        return l_result;
end f_ajax;
