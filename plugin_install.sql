prompt --application/set_environment
set define off verify off feedback off
whenever sqlerror exit sql.sqlcode rollback
--------------------------------------------------------------------------------
--
-- Oracle APEX export file
--
-- You should run this script using a SQL client connected to the database as
-- the owner (parsing schema) of the application or as a database user with the
-- APEX_ADMINISTRATOR_ROLE role.
--
-- This export file has been automatically generated. Modifying this file is not
-- supported by Oracle and can lead to unexpected application and/or instance
-- behavior now or in the future.
--
-- NOTE: Calls to apex_application_install override the defaults below.
--
--------------------------------------------------------------------------------
begin
wwv_flow_imp.import_begin (
 p_version_yyyy_mm_dd=>'2024.11.30'
,p_release=>'24.2.5'
,p_default_workspace_id=>7911812196517118
,p_default_application_id=>117
,p_default_id_offset=>0
,p_default_owner=>'WKSP_SANDBOX'
);
end;
/
 
prompt APPLICATION 117 - Pretius Notification From Table
--
-- Application Export:
--   Application:     117
--   Name:            Pretius Notification From Table
--   Date and Time:   13:59 Wednesday May 21, 2025
--   Exported By:     ADMIN
--   Flashback:       0
--   Export Type:     Component Export
--   Manifest
--     PLUGIN: 82523212019826971
--   Manifest End
--   Version:         24.2.5
--   Instance ID:     7911662648600789
--

begin
  -- replace components
  wwv_flow_imp.g_mode := 'REPLACE';
end;
/
prompt --application/shared_components/plugins/dynamic_action/pretius_notifications_from_table
begin
wwv_flow_imp_shared.create_plugin(
 p_id=>wwv_flow_imp.id(82523212019826971)
,p_plugin_type=>'DYNAMIC ACTION'
,p_name=>'PRETIUS_NOTIFICATIONS_FROM_TABLE'
,p_display_name=>'Pretius Notifications From Table'
,p_category=>'NOTIFICATION'
,p_plsql_code=>wwv_flow_string.join(wwv_flow_t_varchar2(
'function f_render (',
'	p_dynamic_action in apex_plugin.t_dynamic_action,',
'	p_plugin         in apex_plugin.t_plugin ',
') return apex_plugin.t_dynamic_action_render_result is',
'	C_ATTR_CALLBACKS_INTERVAL CONSTANT p_dynamic_action.attribute_01%type := nvl(p_dynamic_action.attribute_01, 10000);',
'	C_ATTR_SETTINGS           CONSTANT p_dynamic_action.attribute_09%type := p_dynamic_action.attribute_09;',
'    C_RENDER_TIME             CONSTANT date := SYSDATE;',
'    l_result                  apex_plugin.t_dynamic_action_render_result;',
'begin',
'	if apex_application.g_debug then',
'		apex_plugin_util.debug_dynamic_action (',
'			p_plugin         => p_plugin,',
'			p_dynamic_action => p_dynamic_action ',
'		);',
'	end if;',
'',
'	apex_javascript.add_library (',
'		p_name      => ''notificationsFromTable'',',
'		p_directory => p_plugin.file_prefix,',
'		p_version   => null ',
'	);',
'',
'    l_result.ajax_identifier := apex_plugin.get_ajax_identifier;',
'    l_result.javascript_function :=',
'        ''function(){',
'            notificationsFromTable.start({''                                                                 ||',
'                        apex_javascript.add_attribute(''ajaxIdentifier'',		l_result.ajax_identifier)	    ||       ',
'            			apex_javascript.add_attribute(''callbackInterval'',	C_ATTR_CALLBACKS_INTERVAL)	    ||',
'                        apex_javascript.add_attribute(''renderTime'',			C_RENDER_TIME)	                ||',
'            			apex_javascript.add_attribute(''settings'',	        C_ATTR_SETTINGS , false, false )||    ',
'                    ''});',
'        }',
'        '';',
'',
'    return l_result;',
'',
'exception',
'	when others then ',
'		apex_error.add_error (',
'			p_message          => ''Pretius Notifications from table: Unidentified error occured. </br> ',
'														 SQLERRM: ''|| SQLERRM || ''</br> ',
'														 Contact application administrator.'',',
'			p_display_location => apex_error.c_inline_in_notification  ',
'		);',
'',
'end f_render;',
'',
'function f_ajax (',
'    p_plugin          in apex_plugin.t_plugin,',
'    p_dynamic_action  in apex_plugin.t_dynamic_action',
') return apex_plugin.t_dynamic_action_ajax_result is',
'    l_result                            apex_plugin.t_dynamic_action_ajax_result;',
'    l_operation                         varchar2(50)  := apex_application.g_x01;',
'    l_notification_id                   number        := to_number(apex_application.g_x02);',
'    l_render_time                       varchar2(250) := apex_application.g_x03;',
'',
'    C_ATTR_NOTIFICATIONS_SOURCE_QUERY       CONSTANT p_dynamic_action.attribute_02%type := p_dynamic_action.attribute_02;',
'    C_ATTR_EXECUTE_PLSQL                    CONSTANT p_dynamic_action.attribute_08%type := p_dynamic_action.attribute_08;',
'    C_ATTR_SETTINGS                         CONSTANT p_dynamic_action.attribute_09%type := p_dynamic_action.attribute_09;',
'',
'    C_ATTR_MAPPING_PRIMARY_KEY              CONSTANT p_dynamic_action.attribute_03%type := p_dynamic_action.attribute_03;',
'	C_ATTR_MAPPING_NOTIFICATION_TYPE        CONSTANT p_dynamic_action.attribute_04%type := p_dynamic_action.attribute_04;',
'	C_ATTR_MAPPING_EVENT_NAME               CONSTANT p_dynamic_action.attribute_05%type := p_dynamic_action.attribute_05;',
'	C_ATTR_MAPPING_NOTIFICAITON_MESSAGE     CONSTANT p_dynamic_action.attribute_06%type := p_dynamic_action.attribute_06;',
'    C_ATTR_MAPPING_CREATED_ON               CONSTANT p_dynamic_action.attribute_10%type := p_dynamic_action.attribute_10;         ',
'',
'    l_query_transformed                 varchar2(32767);',
'    l_context                           apex_exec.t_context;',
'    l_export                            apex_data_export.t_export;',
'begin',
'	--debug',
'	if apex_application.g_debug then',
'		apex_debug.info(''Pretius Notifications From Table - AJAX Callback initiated. Command: '' || l_operation);',
'	end if;',
'',
'    if l_operation = ''GET_NOTIFICATIONS'' then',
'        --------------------------------------------------------------------------------',
'        -- Transform the source query so that the result contains aliased columns:',
'        -- id, type, title, message',
'        --------------------------------------------------------------------------------',
'',
'        l_query_transformed :=',
'            ''select '' || ',
'                C_ATTR_MAPPING_PRIMARY_KEY          || '' as id, ''     ||',
'                C_ATTR_MAPPING_NOTIFICATION_TYPE    || '' as type, ''   ||',
'                C_ATTR_MAPPING_EVENT_NAME           || '' as event_name, ''  ||',
'                C_ATTR_MAPPING_NOTIFICAITON_MESSAGE || '' as message '' ||',
'            ''from ('' || C_ATTR_NOTIFICATIONS_SOURCE_QUERY || '')'';',
'',
'        if  instr(C_ATTR_SETTINGS, ''ONLY_NEW_NOTIFICATIONS'') > 0 then',
'            l_query_transformed := l_query_transformed || ',
'                '' where '' || C_ATTR_MAPPING_CREATED_ON || '' > to_date('''''' || l_render_time || '''''', ''''DD-MM-YYYY HH24:MI:SS'''')'';',
'        end if;',
'',
'	    if apex_application.g_debug then',
'	    	apex_debug.info(''Pretius Notifications From Table - AJAX Callback. Fetching notifications, query: '' || l_query_transformed);',
'	    end if;            ',
'',
'        --------------------------------------------------------------------------------',
'        -- Open the query context using APEX_EXEC and export the result as JSON (CLOB)',
'        --------------------------------------------------------------------------------',
'        l_context := apex_exec.open_query_context(',
'            p_location => apex_exec.c_location_local_db,',
'            p_sql_query => l_query_transformed',
'        );',
'        l_export := apex_data_export.export(',
'            p_context => l_context,',
'            p_format  => apex_data_export.c_format_json,',
'            p_as_clob => true',
'        );',
'        apex_exec.close(l_context);',
'',
'        --apex_json.initialize_clob_output;',
'        apex_json.open_object;     ',
'        apex_json.write(''data'', l_export.content_clob);',
'        apex_json.close_object;',
'',
'    elsif l_operation = ''EXECUTE_PLSQL'' then',
'    ',
'        if p_dynamic_action.attribute_08 is null then',
'            raise_application_error(-20004, ''Custom PL/SQL action not defined.'');',
'        end if;',
'',
'        --------------------------------------------------------------------------------',
'        -- In the developer''s code, the token :NOTIFICATION_ID is expected.',
'        -- Perform a simple replacement of this token with the safe value.',
'        --------------------------------------------------------------------------------',
'        apex_plugin_util.execute_plsql_code (',
'            p_plsql_code => replace(C_ATTR_EXECUTE_PLSQL, '':NOTIFICATION_ID'', to_char(l_notification_id) ) ',
'        );',
'',
'        apex_json.open_object;',
'        apex_json.write(''status'', ''OK'');',
'        apex_json.close_object;',
'',
'    else',
'        apex_json.open_object;',
'        apex_json.write(''status'', ''Invalid request'');',
'        apex_json.close_object;',
'    end if;',
'',
'    return l_result;',
'',
'exception',
'    when others then',
'        apex_json.open_object;',
'        apex_json.write(''error'', apex_escape.html(sqlerrm));',
'        apex_json.close_object;',
'',
'		apex_json.close_all;     ',
'		apex_error.add_error (',
'			p_message          => ''Pretius Notifications from table: Unidentified error occured. </br> ',
'														 SQLERRM: ''|| SQLERRM || ''</br> ',
'														 Contact application administrator.'',',
'			p_display_location => apex_error.c_inline_in_notification  ',
'		);        ',
'        return l_result;',
'end f_ajax;',
''))
,p_api_version=>1
,p_render_function=>'f_render'
,p_ajax_function=>'f_ajax'
,p_substitute_attributes=>false
,p_version_scn=>42201744036208
,p_subscribe_plugin_settings=>true
,p_help_text=>'Pretius Notifications From Table plugin can be used to fetch notifications from a database table with a given interval. Fetched notifications can be displayed as native APEX error or success messages.'
,p_version_identifier=>'24.2.0'
,p_files_version=>98
);
wwv_flow_imp_shared.create_plugin_attr_group(
 p_id=>wwv_flow_imp.id(82524194175869885)
,p_plugin_id=>wwv_flow_imp.id(82523212019826971)
,p_title=>'Column Mapping'
,p_display_sequence=>20
);
wwv_flow_imp_shared.create_plugin_attribute(
 p_id=>wwv_flow_imp.id(82523666617859625)
,p_plugin_id=>wwv_flow_imp.id(82523212019826971)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>1
,p_display_sequence=>10
,p_prompt=>'Callbacks Interval'
,p_attribute_type=>'NUMBER'
,p_is_required=>true
,p_default_value=>'10000'
,p_unit=>'ms'
,p_is_translatable=>false
,p_help_text=>'Define how often the plugin fetches new notifications. Value is in milliseconds.'
);
wwv_flow_imp_shared.create_plugin_attribute(
 p_id=>wwv_flow_imp.id(82523903107867454)
,p_plugin_id=>wwv_flow_imp.id(82523212019826971)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>2
,p_display_sequence=>20
,p_prompt=>'Notifications source query'
,p_attribute_type=>'SQL'
,p_is_required=>true
,p_default_value=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select',
'    id,',
'    type,',
'    event_name,',
'    message,',
'    created',
'from ',
'    notifications'))
,p_sql_min_column_count=>3
,p_is_translatable=>false
,p_examples=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<pre>',
'select',
'    id,',
'    type,',
'    event_name,',
'    message,',
'    created',
'from ',
'    notifications',
'</pre>',
'<pre>',
'  select ',
'      ID,',
'      MESSAGE,',
'      EVENT_NAME,',
'      TYPE,',
'      USERNAME,',
'      IS_READ,',
'      CREATED',
'   from ',
'      NOTIFICATIONS',
'  where',
'      -- get notification only inteded for ',
'      -- the app user or for any user (if null)',
'      upper(nvl(USERNAME, :APP_USER)) = upper(:APP_USER) ',
'</pre>'))
,p_help_text=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<p>A SQL query used to fetch new notifications. It should contain at least three columns that stands for: ',
'  <ul>',
'  <li> Primary key of the notifications source </li>',
'  <li> Type of the notification </li>',
'  <li> Notification message </li>',
'  </ul>',
'</p>',
'<p>Optional columns that the query can contain:',
'  <ul>',
'    <li> Event name - values of that column are the event names that are going to be triggered when the notification is fetched </li>',
'    <li> Created date - a date and time when the notification was inserted to a table. It can be used to skip notifications that are older then the time a user entered the page. </li>',
'  </ul>',
'</p>',
'<p> Any column names are allowed. The mapping between a column and its purpose is defined in a Column Mapping section. </p>'))
);
wwv_flow_imp_shared.create_plugin_attribute(
 p_id=>wwv_flow_imp.id(82524862859877057)
,p_plugin_id=>wwv_flow_imp.id(82523212019826971)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>3
,p_display_sequence=>30
,p_prompt=>'Primary key'
,p_attribute_type=>'TEXT'
,p_is_required=>true
,p_default_value=>'ID'
,p_is_translatable=>false
,p_attribute_group_id=>wwv_flow_imp.id(82524194175869885)
,p_help_text=>'A column name that is a Primary Key / unique identifier of a notification from the provided source query.'
);
wwv_flow_imp_shared.create_plugin_attribute(
 p_id=>wwv_flow_imp.id(82525103608881692)
,p_plugin_id=>wwv_flow_imp.id(82523212019826971)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>4
,p_display_sequence=>40
,p_prompt=>'Notification type'
,p_attribute_type=>'TEXT'
,p_is_required=>true
,p_default_value=>'TYPE'
,p_is_translatable=>false
,p_attribute_group_id=>wwv_flow_imp.id(82524194175869885)
,p_help_text=>'A column name that in the provided source query contains a type of the notification. The supported notification types are: SUCCESS, ERROR. If the value of the provided column is none of those values then no notification is displayed (but the event st'
||'ill can be triggered).'
);
wwv_flow_imp_shared.create_plugin_attribute(
 p_id=>wwv_flow_imp.id(82525502098883512)
,p_plugin_id=>wwv_flow_imp.id(82523212019826971)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>5
,p_display_sequence=>50
,p_prompt=>'Event name'
,p_attribute_type=>'TEXT'
,p_is_required=>true
,p_default_value=>'EVENT_NAME'
,p_is_translatable=>false
,p_depending_on_attribute_id=>wwv_flow_imp.id(84344388535437885)
,p_depending_on_has_to_exist=>true
,p_depending_on_condition_type=>'IN_LIST'
,p_depending_on_expression=>'TRIGGER_EVENT'
,p_attribute_group_id=>wwv_flow_imp.id(82524194175869885)
,p_help_text=>'A column name that in the provided source query contains an event name. The event is triggered when the notification is fetched on a body element. Event is triggered if a proper option is checked, but regardless of the notification type.'
);
wwv_flow_imp_shared.create_plugin_attribute(
 p_id=>wwv_flow_imp.id(82525882867884298)
,p_plugin_id=>wwv_flow_imp.id(82523212019826971)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>6
,p_display_sequence=>60
,p_prompt=>'Notification message'
,p_attribute_type=>'TEXT'
,p_is_required=>true
,p_default_value=>'MESSAGE'
,p_is_translatable=>false
,p_attribute_group_id=>wwv_flow_imp.id(82524194175869885)
,p_help_text=>'A column name that in the provided source query contains a notification message. The message will be the notification content, displayed with an error or a success template, depending on the notification type.'
);
wwv_flow_imp_shared.create_plugin_attribute(
 p_id=>wwv_flow_imp.id(83524873424121342)
,p_plugin_id=>wwv_flow_imp.id(82523212019826971)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>8
,p_display_sequence=>80
,p_prompt=>'Execute PL/SQL Code'
,p_attribute_type=>'PLSQL'
,p_is_required=>true
,p_default_value=>wwv_flow_string.join(wwv_flow_t_varchar2(
'delete from',
'    notifications',
'where',
'    id = :NOTIFICATION_ID;'))
,p_is_translatable=>false
,p_depending_on_attribute_id=>wwv_flow_imp.id(84344388535437885)
,p_depending_on_has_to_exist=>true
,p_depending_on_condition_type=>'IN_LIST'
,p_depending_on_expression=>'EXECUTE_PLSQL'
,p_examples=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<pre>',
'delete from',
'    notifications',
'where',
'    id = :NOTIFICATION_ID;',
'</pre>',
'<pre>',
'update',
'    notifications',
'set ',
'    is_read = ''Y''',
'where ',
'    id = :NOTIFICATION_ID;',
'</pre>'))
,p_help_text=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<p>',
'Provide a PL/SQL code that is going to be executed after the notification is displayed. The code is executed with a delay equal to Callbacks Interval. This can be used to delete or mark the notifications as read. ',
'</p>',
'<p>',
'Use a bind variable <b>:NOTIFICATION_ID </b> in the code to refer to the notification.',
'</p>'))
);
wwv_flow_imp_shared.create_plugin_attribute(
 p_id=>wwv_flow_imp.id(84344388535437885)
,p_plugin_id=>wwv_flow_imp.id(82523212019826971)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>9
,p_display_sequence=>70
,p_prompt=>'Settings'
,p_attribute_type=>'CHECKBOXES'
,p_is_required=>false
,p_default_value=>'ONLY_NEW_NOTIFICATIONS'
,p_is_translatable=>false
,p_lov_type=>'STATIC'
);
wwv_flow_imp_shared.create_plugin_attr_value(
 p_id=>wwv_flow_imp.id(85134909280189270)
,p_plugin_attribute_id=>wwv_flow_imp.id(84344388535437885)
,p_display_sequence=>10
,p_display_value=>'Display only new notifications'
,p_return_value=>'ONLY_NEW_NOTIFICATIONS'
,p_help_text=>'Select this option to ignore any notifications from the source that were inserted before the time the plugin was initialised on a page. This option requires defining created date column in the source query and a column mapping.'
);
wwv_flow_imp_shared.create_plugin_attr_value(
 p_id=>wwv_flow_imp.id(85135367192192890)
,p_plugin_attribute_id=>wwv_flow_imp.id(84344388535437885)
,p_display_sequence=>20
,p_display_value=>'Execute PL/SQL Code after notification display'
,p_return_value=>'EXECUTE_PLSQL'
,p_help_text=>'Provide a PL/SQL code that is going to be executed after the notification is displayed. The code is executed with a delay equal to Callbacks Interval. This can be used to delete or mark the notifications as read.'
);
wwv_flow_imp_shared.create_plugin_attr_value(
 p_id=>wwv_flow_imp.id(85135746152197798)
,p_plugin_attribute_id=>wwv_flow_imp.id(84344388535437885)
,p_display_sequence=>30
,p_display_value=>'Trigger Event when displaying notificaiton'
,p_return_value=>'TRIGGER_EVENT'
,p_help_text=>'Select this option to trigger a browser event when the notification is displayed. Event is triggered on a body element.'
);
wwv_flow_imp_shared.create_plugin_attribute(
 p_id=>wwv_flow_imp.id(84345231442441073)
,p_plugin_id=>wwv_flow_imp.id(82523212019826971)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>10
,p_display_sequence=>100
,p_prompt=>'Created on'
,p_attribute_type=>'TEXT'
,p_is_required=>true
,p_default_value=>'CREATED'
,p_is_translatable=>false
,p_depending_on_attribute_id=>wwv_flow_imp.id(84344388535437885)
,p_depending_on_has_to_exist=>true
,p_depending_on_condition_type=>'IN_LIST'
,p_depending_on_expression=>'ONLY_NEW_NOTIFICATIONS'
,p_attribute_group_id=>wwv_flow_imp.id(82524194175869885)
,p_help_text=>'A column name that in the provided source query contains a date and time when the row was inserted to the table. It is used to skip all the notifications that were added to the database before plugin initialisation.'
);
wwv_flow_imp_shared.create_plugin_event(
 p_id=>wwv_flow_imp.id(67022897337566470)
,p_plugin_id=>wwv_flow_imp.id(82523212019826971)
,p_name=>'notifications-from-table--fetchsuccess'
,p_display_name=>'After notifications fetch'
);
wwv_flow_imp_shared.create_plugin_event(
 p_id=>wwv_flow_imp.id(67023284308566471)
,p_plugin_id=>wwv_flow_imp.id(82523212019826971)
,p_name=>'notifications-from-table--plsqlsuccess'
,p_display_name=>'After PL/SQL processing finished'
);
end;
/
begin
wwv_flow_imp.g_varchar2_table := wwv_flow_imp.empty_varchar2_table;
wwv_flow_imp.g_varchar2_table(1) := '766172206E6F74696669636174696F6E7346726F6D5461626C653D66756E6374696F6E28297B76617220653D6E6577205365743B636F6E737420743D2250726574697573204E6F74696669636174696F6E732066726F6D207461626C65202D20222C733D';
wwv_flow_imp.g_varchar2_table(2) := '617065782E64656275672E4C4F475F4C4556454C2E494E464F3B66756E6374696F6E2069286E297B636F6E737420613D6E2E63616C6C6261636B496E74657276616C2C6F3D6E2E616A61784964656E7469666965722C723D6E2E72656E64657254696D65';
wwv_flow_imp.g_varchar2_table(3) := '2D612C633D66756E6374696F6E2865297B636F6E737420743D653D3E652E746F537472696E6728292E706164537461727428322C223022293B72657475726E60247B7428652E676574446174652829297D2D247B7428652E6765744D6F6E746828292B31';
wwv_flow_imp.g_varchar2_table(4) := '297D2D247B652E67657446756C6C5965617228297D20247B7428652E676574486F7572732829297D3A247B7428652E6765744D696E757465732829297D3A247B7428652E6765745365636F6E64732829297D607D286E65772044617465287229292C673D';
wwv_flow_imp.g_varchar2_table(5) := '6E756C6C213D6E2E73657474696E677326266E2E73657474696E67732E696E6465784F662822455845435554455F504C53514C22293E2D312C753D6E756C6C213D6E2E73657474696E677326266E2E73657474696E67732E696E6465784F662822545249';
wwv_flow_imp.g_varchar2_table(6) := '474745525F4556454E5422293E2D313B617065782E64656275672E6D65737361676528732C742C224665746368696E67206E6F74696669636174696F6E732E2E2E22292C617065782E7365727665722E706C7567696E286F2C7B7830313A224745545F4E';
wwv_flow_imp.g_varchar2_table(7) := '4F54494649434154494F4E53222C7830333A637D2C7B64617461547970653A226A736F6E222C737563636573733A66756E6374696F6E2869297B6C6574206E3D4A534F4E2E706172736528692E64617461292C723D5B5D3B617065782E64656275672E6D';
wwv_flow_imp.g_varchar2_table(8) := '65737361676528732C742C22466574636865643A20222C6E2E6974656D732E6C656E6774682C22206E6F74696669636174696F6E28732922292C617065782E6576656E742E747269676765722822626F6479222C226E6F74696669636174696F6E732D66';
wwv_flow_imp.g_varchar2_table(9) := '726F6D2D7461626C652D2D66657463687375636365737322292C6E26266E2E6974656D732E6C656E6774683E303F286E2E6974656D732E666F7245616368282866756E6374696F6E2869297B692E6964262621652E68617328692E696429262628652E61';
wwv_flow_imp.g_varchar2_table(10) := '646428692E6964292C6E756C6C213D692E747970652626692E74797065262628692E7479706526262273756363657373223D3D3D692E747970652E746F4C6F7765724361736528293F617065782E6D6573736167652E73686F7750616765537563636573';
wwv_flow_imp.g_varchar2_table(11) := '7328692E6D657373616765293A692E747970652626226572726F72223D3D3D692E747970652E746F4C6F7765724361736528292626722E70757368287B747970653A226572726F72222C6C6F636174696F6E3A2270616765222C6D6573736167653A692E';
wwv_flow_imp.g_varchar2_table(12) := '6D6573736167652C756E736166653A21317D29292C752626617065782E6576656E742E747269676765722822626F6479222C692E6576656E745F6E616D657C7C22222C7B6E6F74696669636174696F6E49643A692E69642C747970653A692E747970652C';
wwv_flow_imp.g_varchar2_table(13) := '6D6573736167653A692E6D6573736167657D292C67262673657454696D656F7574282866756E6374696F6E28297B617065782E64656275672E6D65737361676528732C742C224E6F74696669636174696F6E20746F2062652070726F6365737365643A20';
wwv_flow_imp.g_varchar2_table(14) := '222C692E6964292C617065782E7365727665722E706C7567696E286F2C7B7830313A22455845435554455F504C53514C222C7830323A692E69647D2C7B737563636573733A66756E6374696F6E28297B617065782E6576656E742E747269676765722822';
wwv_flow_imp.g_varchar2_table(15) := '626F6479222C226E6F74696669636174696F6E732D66726F6D2D7461626C652D2D706C73716C7375636365737322292C617065782E64656275672E6D65737361676528732C742C224E6F74696669636174696F6E2070726F636573736564207375636365';
wwv_flow_imp.g_varchar2_table(16) := '737366756C6C793A20222C692E6964297D2C6572726F723A66756E6374696F6E28652C732C6E297B617065782E64656275672E6572726F7228742C224572726F722070726F63657373696E67206E6F74696669636174696F6E20222C692E69642C223A20';
wwv_flow_imp.g_varchar2_table(17) := '222C732C6E297D7D297D292C6129297D29292C722E6C656E6774683E30262628617065782E6D6573736167652E636C6561724572726F727328292C617065782E6D6573736167652E73686F774572726F727328722929293A617065782E64656275672E6D';
wwv_flow_imp.g_varchar2_table(18) := '65737361676528732C742C224E6F206E6577206E6F74696669636174696F6E7320746F20646973706C617922297D2C6572726F723A66756E6374696F6E28652C732C69297B617065782E64656275672E6572726F7228742C224572726F72206665746368';
wwv_flow_imp.g_varchar2_table(19) := '696E67206E6F74696669636174696F6E733A222C732C69297D7D292C73657454696D656F7574282866756E6374696F6E28297B69286E297D292C61297D72657475726E7B73746172743A66756E6374696F6E2865297B617065782E64656275672E6D6573';
wwv_flow_imp.g_varchar2_table(20) := '7361676528732C742C22696E697469616C697A6174696F6E22292C692865297D7D7D28293B';
end;
/
begin
wwv_flow_imp_shared.create_plugin_file(
 p_id=>wwv_flow_imp.id(23751217873688515)
,p_plugin_id=>wwv_flow_imp.id(82523212019826971)
,p_file_name=>'notificationsFromTable.min.js'
,p_mime_type=>'text/javascript'
,p_file_charset=>'utf-8'
,p_file_content=>wwv_flow_imp.varchar2_to_blob(wwv_flow_imp.g_varchar2_table)
);
end;
/
begin
wwv_flow_imp.g_varchar2_table := wwv_flow_imp.empty_varchar2_table;
wwv_flow_imp.g_varchar2_table(1) := '2F2A0A2A20506C7567696E3A2050726574697573204E6F74696669636174696F6E732046726F6D205461626C650A2A2056657273696F6E3A20312E300A2A0A2A20417574686F723A204164616D204B6965727A6B6F77736B6920200A2A204D61696C3A20';
wwv_flow_imp.g_varchar2_table(2) := '6164616D5F6B6965727A6B6F77736B694069636C6F75642E636F6D0A2A20547769747465723A2040615F6B6965727A6B6F77736B690A2A20426C6F673A200A2A0A2A20446570656E64733A0A2A20202020617065782F64656275672E6A730A2A20202020';
wwv_flow_imp.g_varchar2_table(3) := '617065782F7365727665722E6A730A2A20202020617065782E6D6573736167652E6A730A2A204368616E6765733A0A2A0A2A2F0A0A766172206E6F74696669636174696F6E7346726F6D5461626C65203D202866756E6374696F6E28297B0A202020202F';
wwv_flow_imp.g_varchar2_table(4) := '2F2053657420746F2073746F726520646973706C61796564206E6F74696669636174696F6E204944730A2020202076617220646973706C61796564496473203D206E65772053657428293B0A20202020636F6E73742044454255475F505245464958203D';
wwv_flow_imp.g_varchar2_table(5) := '202750726574697573204E6F74696669636174696F6E732066726F6D207461626C65202D20273B0A20202020636F6E73742044454255475F4C4556454C203D20617065782E64656275672E4C4F475F4C4556454C2E494E464F3B0A0A2020202066756E63';
wwv_flow_imp.g_varchar2_table(6) := '74696F6E20666F726D617444617465286461746529207B0A2020202020202020636F6E737420706164203D20286E756D29203D3E206E756D2E746F537472696E6728292E706164537461727428322C20273027293B0A0A2020202020202020636F6E7374';
wwv_flow_imp.g_varchar2_table(7) := '20646179203D2070616428646174652E676574446174652829293B0A2020202020202020636F6E7374206D6F6E7468203D2070616428646174652E6765744D6F6E74682829202B2031293B202F2F204D6F6E7468732061726520302D62617365640A2020';
wwv_flow_imp.g_varchar2_table(8) := '202020202020636F6E73742079656172203D20646174652E67657446756C6C5965617228293B0A2020202020202020636F6E737420686F757273203D2070616428646174652E676574486F7572732829293B0A2020202020202020636F6E7374206D696E';
wwv_flow_imp.g_varchar2_table(9) := '75746573203D2070616428646174652E6765744D696E757465732829293B0A2020202020202020636F6E7374207365636F6E6473203D2070616428646174652E6765745365636F6E64732829293B0A0A202020202020202072657475726E2060247B6461';
wwv_flow_imp.g_varchar2_table(10) := '797D2D247B6D6F6E74687D2D247B796561727D20247B686F7572737D3A247B6D696E757465737D3A247B7365636F6E64737D603B0A202020207D0A0A2020202066756E6374696F6E2066657463684E6F74696669636174696F6E73286F7074696F6E7329';
wwv_flow_imp.g_varchar2_table(11) := '207B0A2020202020202020636F6E73742063616C6C6261636B496E74657276616C20203D206F7074696F6E732E63616C6C6261636B496E74657276616C3B0A0909636F6E737420616A61784964656E74696669657220093D206F7074696F6E732E616A61';
wwv_flow_imp.g_varchar2_table(12) := '784964656E7469666965723B0A2020202020202020636F6E73742072656E64657254696D654D696E7573496E74657276616C203D206F7074696F6E732E72656E64657254696D65202D2063616C6C6261636B496E74657276616C3B0A2020202020202020';
wwv_flow_imp.g_varchar2_table(13) := '636F6E737420666F726D6174656452656E64657254696D654D696E7573496E74657276616C203D20666F726D617444617465286E657720446174652872656E64657254696D654D696E7573496E74657276616C29293B0A2020202020202020636F6E7374';
wwv_flow_imp.g_varchar2_table(14) := '2065786563757465506C73716C436F646520203D206F7074696F6E732E73657474696E677320213D206E756C6C202626206F7074696F6E732E73657474696E67732E696E6465784F662827455845435554455F504C53514C2729203E202D313B0A202020';
wwv_flow_imp.g_varchar2_table(15) := '2020202020636F6E737420747269676765724576656E742020202020203D206F7074696F6E732E73657474696E677320213D206E756C6C202626206F7074696F6E732E73657474696E67732E696E6465784F662827545249474745525F4556454E542729';
wwv_flow_imp.g_varchar2_table(16) := '203E202D313B0A20200A2020202020202020617065782E64656275672E6D6573736167652844454255475F4C4556454C2C2044454255475F5052454649582C20274665746368696E67206E6F74696669636174696F6E732E2E2E27293B0A202020202020';
wwv_flow_imp.g_varchar2_table(17) := '2020617065782E7365727665722E706C7567696E280A202020202020202020202020616A61784964656E7469666965722C200A2020202020202020202020207B200A202020202020202020202020202020207830313A20274745545F4E4F544946494341';
wwv_flow_imp.g_varchar2_table(18) := '54494F4E53272C0A202020202020202020202020202020207830333A20666F726D6174656452656E64657254696D654D696E7573496E74657276616C0A2020202020202020202020207D2C200A2020202020202020202020207B0A202020202020202020';
wwv_flow_imp.g_varchar2_table(19) := '2020202020202064617461547970653A20276A736F6E272C0A20202020202020202020202020202020737563636573733A2066756E6374696F6E286461746129207B0A20202020202020202020202020202020202020206C657420726573706F6E736520';
wwv_flow_imp.g_varchar2_table(20) := '3D204A534F4E2E706172736528646174612E64617461293B0A20202020202020202020202020202020202020206C657420617065784572726F724172726179203D205B5D3B0A2020202020202020202020202020202020202020617065782E6465627567';
wwv_flow_imp.g_varchar2_table(21) := '2E6D6573736167652844454255475F4C4556454C2C2044454255475F5052454649582C2027466574636865643A20272C20726573706F6E73652E6974656D732E6C656E6774682C2027206E6F74696669636174696F6E28732927293B0A20202020202020';
wwv_flow_imp.g_varchar2_table(22) := '20202020202020202020202020617065782E6576656E742E747269676765722827626F6479272C20276E6F74696669636174696F6E732D66726F6D2D7461626C652D2D66657463687375636365737327293B0A0A20202020202020202020202020202020';
wwv_flow_imp.g_varchar2_table(23) := '2020202069662028726573706F6E736520262620726573706F6E73652E6974656D732E6C656E677468203E203029207B0A202020202020202020202020202020202020202020202020726573706F6E73652E6974656D732E666F72456163682866756E63';
wwv_flow_imp.g_varchar2_table(24) := '74696F6E286974656D29207B0A202020202020202020202020202020202020202020202020202020202F2F204966206E6F74696669636174696F6E2068617320616E20696420616E64206861736E2774206265656E20646973706C61796564206265666F';
wwv_flow_imp.g_varchar2_table(25) := '72650A20202020202020202020202020202020202020202020202020202020696620286974656D2E69642026262021646973706C617965644964732E686173286974656D2E69642929207B0A0A2020202020202020202020202020202020202020202020';
wwv_flow_imp.g_varchar2_table(26) := '2020202020202020202F2F2041646420746F2074686520616C726561647920646973706C61796564206D657373616765730A2020202020202020202020202020202020202020202020202020202020202020646973706C617965644964732E6164642869';
wwv_flow_imp.g_varchar2_table(27) := '74656D2E6964293B0A0A20202020202020202020202020202020202020202020202020202020202020202F2F20446973706C6179206E6F74696669636174696F6E206261736564206F6E20747970650A2020202020202020202020202020202020202020';
wwv_flow_imp.g_varchar2_table(28) := '202020202020202020202020696620286974656D2E7479706520213D20756E646566696E6564202626206974656D2E7479706529207B0A202020202020202020202020202020202020202020202020202020202020202020202020696620286974656D2E';
wwv_flow_imp.g_varchar2_table(29) := '74797065202626206974656D2E747970652E746F4C6F776572436173652829203D3D3D2027737563636573732729207B0A20202020202020202020202020202020202020202020202020202020202020202020202020202020617065782E6D6573736167';
wwv_flow_imp.g_varchar2_table(30) := '652E73686F775061676553756363657373286974656D2E6D657373616765293B0A2020202020202020202020202020202020202020202020202020202020202020202020207D20656C736520696620286974656D2E74797065202626206974656D2E7479';
wwv_flow_imp.g_varchar2_table(31) := '70652E746F4C6F776572436173652829203D3D3D20276572726F722729207B0A202020202020202020202020202020202020202020202020202020202020202020202020202020202F2F2061646420746F20616E206172726179206E6F772C2064697370';
wwv_flow_imp.g_varchar2_table(32) := '6C6179206C6174657220616C6C206174206F6E63650A20202020202020202020202020202020202020202020202020202020202020202020202020202020617065784572726F7241727261792E70757368287B0A20202020202020202020202020202020';
wwv_flow_imp.g_varchar2_table(33) := '20202020202020202020202020202020202020202020202020202020747970653A20202020202020276572726F72272C0A20202020202020202020202020202020202020202020202020202020202020202020202020202020202020206C6F636174696F';
wwv_flow_imp.g_varchar2_table(34) := '6E3A2020202770616765272C0A20202020202020202020202020202020202020202020202020202020202020202020202020202020202020206D6573736167653A202020206974656D2E6D6573736167652C0A2020202020202020202020202020202020';
wwv_flow_imp.g_varchar2_table(35) := '202020202020202020202020202020202020202020202020202020756E736166653A202020202066616C73650A202020202020202020202020202020202020202020202020202020202020202020202020202020207D293B0A2020202020202020202020';
wwv_flow_imp.g_varchar2_table(36) := '202020202020202020202020202020202020202020202020207D0A20202020202020202020202020202020202020202020202020202020202020207D0A0A0A20202020202020202020202020202020202020202020202020202020202020202F2F205472';
wwv_flow_imp.g_varchar2_table(37) := '696767657220616E206576656E74206966206F7074696F6E207761732073656C65637465640A202020202020202020202020202020202020202020202020202020202020202069662028747269676765724576656E7429207B0A20202020202020202020';
wwv_flow_imp.g_varchar2_table(38) := '2020202020202020202020202020202020202020202020202020617065782E6576656E742E74726967676572280A2020202020202020202020202020202020202020202020202020202020202020202020202020202027626F6479272C200A2020202020';
wwv_flow_imp.g_varchar2_table(39) := '20202020202020202020202020202020202020202020202020202020202020202020206974656D2E6576656E745F6E616D65207C7C2027272C200A202020202020202020202020202020202020202020202020202020202020202020202020202020207B';
wwv_flow_imp.g_varchar2_table(40) := '0A2020202020202020202020202020202020202020202020202020202020202020202020202020202020202020276E6F74696669636174696F6E496427202020203A206974656D2E69642C0A202020202020202020202020202020202020202020202020';
wwv_flow_imp.g_varchar2_table(41) := '202020202020202020202020202020202020202027747970652720202020202020202020202020203A206974656D2E747970652C0A2020202020202020202020202020202020202020202020202020202020202020202020202020202020202020276D65';
wwv_flow_imp.g_varchar2_table(42) := '73736167652720202020202020202020203A206974656D2E6D6573736167650A202020202020202020202020202020202020202020202020202020202020202020202020202020207D0A2020202020202020202020202020202020202020202020202020';
wwv_flow_imp.g_varchar2_table(43) := '20202020202020202020293B0A20202020202020202020202020202020202020202020202020202020202020207D0A0A20202020202020202020202020202020202020202020202020202020202020202F2F20446570656E64696E67206F6E2065786563';
wwv_flow_imp.g_varchar2_table(44) := '757465506C73716C436F64652069662073656C65637465642E0A09090920202020090909092F2F2072756E206974206F6E6C7920616674657220696E74657276616C2C20736F20696E2063617365206F66206E6F74696669636174696F6E2064656C6574';
wwv_flow_imp.g_varchar2_table(45) := '696F6E20697420776F6E27742063617573650A09090920202020090909092F2F2073696D756C74616E656F757320757365727320746F206D69737320746865206E6F74696669636174696F6E730A20202020202020202020202020202020202020202020';
wwv_flow_imp.g_varchar2_table(46) := '202020202020202020206966202865786563757465506C73716C436F646529207B0A09090909202020200909092020202073657454696D656F75742866756E6374696F6E2829207B0A202020202020202020202020202020202020202020202020202020';
wwv_flow_imp.g_varchar2_table(47) := '20202020202020202020202020617065782E64656275672E6D6573736167652844454255475F4C4556454C2C2044454255475F5052454649582C20274E6F74696669636174696F6E20746F2062652070726F6365737365643A20272C206974656D2E6964';
wwv_flow_imp.g_varchar2_table(48) := '293B0A09090909202020200909092020202009092F2F205061737320746865206E6F74696669636174696F6E206964207573696E67207830320A0909090920202020090909202020200909617065782E7365727665722E706C7567696E28616A61784964';
wwv_flow_imp.g_varchar2_table(49) := '656E7469666965722C207B0A0909090920202020090909202020200909097830313A2027455845435554455F504C53514C272C0A0909090920202020090909202020200909097830323A206974656D2E69640A0909090920202020090909202020200909';
wwv_flow_imp.g_varchar2_table(50) := '7D2C207B0A090909092020202009090920202020090909737563636573733A2066756E6374696F6E28297B0A2020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202061706578';
wwv_flow_imp.g_varchar2_table(51) := '2E6576656E742E747269676765722827626F6479272C20276E6F74696669636174696F6E732D66726F6D2D7461626C652D2D706C73716C7375636365737327293B0A09090909202020200909092020202009090909617065782E64656275672E6D657373';
wwv_flow_imp.g_varchar2_table(52) := '6167652844454255475F4C4556454C2C2044454255475F5052454649582C20274E6F74696669636174696F6E2070726F636573736564207375636365737366756C6C793A20272C206974656D2E6964293B0A090909092020202009090920202020090909';
wwv_flow_imp.g_varchar2_table(53) := '7D2C0A0909090920202020090909202020200909096572726F723A2066756E6374696F6E286A715848522C20746578745374617475732C206572726F725468726F776E29207B0A09090909202020200909092020202009090909617065782E6465627567';
wwv_flow_imp.g_varchar2_table(54) := '2E6572726F722844454255475F5052454649582C20274572726F722070726F63657373696E67206E6F74696669636174696F6E20272C206974656D2E69642C20273A20272C20746578745374617475732C206572726F725468726F776E293B0A09090909';
wwv_flow_imp.g_varchar2_table(55) := '20202020090909202020200909097D0A09090909202020200909092020202009097D293B0A0909090920202020090909202020207D2C2063616C6C6261636B496E74657276616C293B0A2020202020202020202020202020202020202020202020202020';
wwv_flow_imp.g_varchar2_table(56) := '2020202020207D0A202020202020202020202020202020202020202020202020202020207D0A2020202020202020202020202020202020202020202020207D293B0A2020202020202020202020202020202020202020202020202F2F2073686F77206170';
wwv_flow_imp.g_varchar2_table(57) := '6578206572726F7273206174206F6E63652069662074686579206170706572617265640A20202020202020202020202020202020202020202020202069662028617065784572726F7241727261792E6C656E677468203E2030297B0A2020202020202020';
wwv_flow_imp.g_varchar2_table(58) := '2020202020202020202020202020202020202020617065782E6D6573736167652E636C6561724572726F727328293B0A20202020202020202020202020202020202020202020202020202020617065782E6D6573736167652E73686F774572726F727328';
wwv_flow_imp.g_varchar2_table(59) := '617065784572726F724172726179293B0A2020202020202020202020202020202020202020202020207D0A20202020202020202020202020202020202020207D20656C7365207B0A090909092020202009617065782E64656275672E6D65737361676528';
wwv_flow_imp.g_varchar2_table(60) := '44454255475F4C4556454C2C2044454255475F5052454649582C20274E6F206E6577206E6F74696669636174696F6E7320746F20646973706C617927293B0A20202020202020202020202020202020202020207D0A202020202020202020202020202020';
wwv_flow_imp.g_varchar2_table(61) := '207D2C0A202020202020202020202020202020206572726F723A2066756E6374696F6E286A715848522C20746578745374617475732C206572726F725468726F776E29207B0A2020202020202020202020202020202020202020617065782E6465627567';
wwv_flow_imp.g_varchar2_table(62) := '2E6572726F722844454255475F5052454649582C20274572726F72206665746368696E67206E6F74696669636174696F6E733A272C20746578745374617475732C206572726F725468726F776E293B0A202020202020202020202020202020207D0A2020';
wwv_flow_imp.g_varchar2_table(63) := '202020202020202020207D0A2020202020202020293B0A202020202020202073657454696D656F75742866756E6374696F6E28297B0A20202020202020202020202066657463684E6F74696669636174696F6E73286F7074696F6E73293B0A2020202020';
wwv_flow_imp.g_varchar2_table(64) := '2020207D2C2063616C6C6261636B496E74657276616C293B20202020202020200A202020207D0A0A2020202066756E6374696F6E207374617274286F7074696F6E7329207B0A2020202020202020617065782E64656275672E6D65737361676528444542';
wwv_flow_imp.g_varchar2_table(65) := '55475F4C4556454C2C2044454255475F5052454649582C2027696E697469616C697A6174696F6E27293B0A0A20202020202020202F2F20537461727420706572696F646963206665746368696E67206F66206E6F74696669636174696F6E730A20202020';
wwv_flow_imp.g_varchar2_table(66) := '2020202066657463684E6F74696669636174696F6E73280A2020202020202020202020206F7074696F6E730A2020202020202020293B0A202020207D0A0A2020202072657475726E207B0A202020202020202073746172743A2073746172740A20202020';
wwv_flow_imp.g_varchar2_table(67) := '7D3B0A7D2928293B0A';
end;
/
begin
wwv_flow_imp_shared.create_plugin_file(
 p_id=>wwv_flow_imp.id(83324155234008310)
,p_plugin_id=>wwv_flow_imp.id(82523212019826971)
,p_file_name=>'notificationsFromTable.js'
,p_mime_type=>'text/javascript'
,p_file_charset=>'utf-8'
,p_file_content=>wwv_flow_imp.varchar2_to_blob(wwv_flow_imp.g_varchar2_table)
);
end;
/
prompt --application/end_environment
begin
wwv_flow_imp.import_end(p_auto_install_sup_obj => nvl(wwv_flow_application_install.get_auto_install_sup_obj, false)
);
commit;
end;
/
set verify on feedback on define on
prompt  ...done
