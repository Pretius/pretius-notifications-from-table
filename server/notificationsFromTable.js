/*
* Plugin: Pretius Notifications From Table
* Version: 1.0
*
* Author: Adam Kierzkowski  
* Mail: adam_kierzkowski@icloud.com
* Twitter: @a_kierzkowski
* Blog: 
*
* Depends:
*    apex/debug.js
*    apex/server.js
*    apex.message.js
* Changes:
*
*/

var notificationsFromTable = (function(){
    // Set to store displayed notification IDs
    var displayedIds = new Set();
    const DEBUG_PREFIX = 'Pretius Notifications from table - ';
    const DEBUG_LEVEL = apex.debug.LOG_LEVEL.INFO;

    function formatDate(date) {
        const pad = (num) => num.toString().padStart(2, '0');

        const day = pad(date.getDate());
        const month = pad(date.getMonth() + 1); // Months are 0-based
        const year = date.getFullYear();
        const hours = pad(date.getHours());
        const minutes = pad(date.getMinutes());
        const seconds = pad(date.getSeconds());

        return `${day}-${month}-${year} ${hours}:${minutes}:${seconds}`;
    }

    function fetchNotifications(options) {
        const callbackInterval  = options.callbackInterval;
		const ajaxIdentifier 	= options.ajaxIdentifier;
        const renderTimeMinusInterval = options.renderTime - callbackInterval;
        const formatedRenderTimeMinusInterval = formatDate(new Date(renderTimeMinusInterval));
        const executePlsqlCode  = options.settings != null && options.settings.indexOf('EXECUTE_PLSQL') > -1;
        const triggerEvent      = options.settings != null && options.settings.indexOf('TRIGGER_EVENT') > -1;
  
        apex.debug.message(DEBUG_LEVEL, DEBUG_PREFIX, 'Fetching notifications...');
        apex.server.plugin(
            ajaxIdentifier, 
            { 
                x01: 'GET_NOTIFICATIONS',
                x03: formatedRenderTimeMinusInterval
            }, 
            {
                dataType: 'json',
                success: function(data) {
                    let response = JSON.parse(data.data);
                    let apexErrorArray = [];
                    apex.debug.message(DEBUG_LEVEL, DEBUG_PREFIX, 'Fetched: ', response.items.length, ' notification(s)');
                    apex.event.trigger('body', 'notifications-from-table--fetchsuccess');

                    if (response && response.items.length > 0) {
                        response.items.forEach(function(item) {
                            // If notification has an id and hasn't been displayed before
                            if (item.id && !displayedIds.has(item.id)) {

                                // Add to the already displayed messages
                                displayedIds.add(item.id);

                                // Display notification based on type
                                if (item.type != undefined && item.type) {
                                    if (item.type && item.type.toLowerCase() === 'success') {
                                        apex.message.showPageSuccess(item.message);
                                    } else if (item.type && item.type.toLowerCase() === 'error') {
                                        // add to an array now, display later all at once
                                        apexErrorArray.push({
                                            type:       'error',
                                            location:   'page',
                                            message:    item.message,
                                            unsafe:     false
                                        });
                                    }
                                }


                                // Trigger an event if option was selected
                                if (triggerEvent) {
                                    apex.event.trigger(
                                        'body', 
                                        item.event_name || '', 
                                        {
                                            'notificationId'    : item.id,
                                            'type'              : item.type,
                                            'message'           : item.message
                                        }
                                    );
                                }

                                // Depending on executePlsqlCode if selected.
			    				// run it only after interval, so in case of notification deletion it won't cause
			    				// simultaneous users to miss the notifications
                                if (executePlsqlCode) {
				    			    setTimeout(function() {
                                        apex.debug.message(DEBUG_LEVEL, DEBUG_PREFIX, 'Notification to be processed: ', item.id);
				    			    		// Pass the notification id using x02
				    			    		apex.server.plugin(ajaxIdentifier, {
				    			    			x01: 'EXECUTE_PLSQL',
				    			    			x02: item.id
				    			    		}, {
				    			    			success: function(){
                                                    apex.event.trigger('body', 'notifications-from-table--plsqlsuccess');
				    			    				apex.debug.message(DEBUG_LEVEL, DEBUG_PREFIX, 'Notification processed successfully: ', item.id);
				    			    			},
				    			    			error: function(jqXHR, textStatus, errorThrown) {
				    			    				apex.debug.error(DEBUG_PREFIX, 'Error processing notification ', item.id, ': ', textStatus, errorThrown);
				    			    			}
				    			    		});
				    			    }, callbackInterval);
                                }
                            }
                        });
                        // show apex errors at once if they apperared
                        if (apexErrorArray.length > 0){
                            apex.message.clearErrors();
                            apex.message.showErrors(apexErrorArray);
                        }
                    } else {
				    	apex.debug.message(DEBUG_LEVEL, DEBUG_PREFIX, 'No new notifications to display');
                    }
                },
                error: function(jqXHR, textStatus, errorThrown) {
                    apex.debug.error(DEBUG_PREFIX, 'Error fetching notifications:', textStatus, errorThrown);
                }
            }
        );
        setTimeout(function(){
            fetchNotifications(options);
        }, callbackInterval);        
    }

    function start(options) {
        apex.debug.message(DEBUG_LEVEL, DEBUG_PREFIX, 'initialization');

        // Start periodic fetching of notifications
        fetchNotifications(
            options
        );
    }

    return {
        start: start
    };
})();
