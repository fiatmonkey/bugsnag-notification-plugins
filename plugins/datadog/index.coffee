NotificationPlugin = require "../../notification-plugin"

class Bigpanda extends NotificationPlugin
    @receiveEvent = (config, event, callback) ->

        # Refer to https://a.bigpanda.io/#/app/integrations/alertsapi/instructions/alertsapi
        payload = {
            app_key: null, # Application Key for BigPanda Account. - required
            status: null, # alert severity; critical, low, ok, ack. - required
            host: null, # Server application or device name - required
            check: null, # Alert name - required
            description: “This is a description of the error“, # Error Description
            cluster: null, # cluster name
        }


            payload.status = “critical”
            payload.host = “bugsnag.server.net”
            payload.check = “Memory is low”
            payload.cluster = “cluster.bugsnag.server.net”
	    payload.app_key = “8364dd767869eb645a69c3f800d13fb9”
           
            

        @request
            .post("https://demo-api.bigpanda.io/data/v2/alerts")
	    .set(‘Authorization’, ‘Bearer 0b34908c6b568cbb78c8a5e4b4e0df13’)
            .set('Content-Type', 'application/json')
            .timeout(4000)
            .send(payload)
            

module.exports = Bigpanda
