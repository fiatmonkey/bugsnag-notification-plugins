NotificationPlugin = require "../../notification-plugin"

class BigPanda extends NotificationPlugin
    @receiveEvent = (config, event, callback) ->

        # Refer to http://docs.datadoghq.com/api/#events
        payload = {
            app_key: config.api_key, # Event title; limited to 100 characters.
            status: "warning", # null, # 'error', 'warning', 'info' 
            host: "foobar.com", #null, # project name 
            check: "ExceptionHandler Error", # null , # event trigger type - if 'info' ingore event?
            MetaData: "Some Meta Data", #[], # extra information: production::DEV
            ErrorLink: "http://fiatmonkey.com", #null, # link to error URL
            description: "IF there really was an error...", # null, # trigger and trigger type?
        }
        # Default text body... just give a link to the bugsnag error
        payload.ErrorLink = "#{event.error.url}"

        # Add some tags
        if event.error.appVersion
            payload.MetaData << "app-version:#{event.error.appVersion}"
        if event.error.releaseStage
            payload.MetaData << "release-stage:#{event.error.releaseStage}"

        if event.error.severity == "info"
            payload.status = "ok"
        else if event.error.severity == "warning"
            payload.status = "warning"
        else
            payload.status = "critical"

        if event.trigger.type == "comment"
            payload.title = event.user.name + " commented on " +
                event.error.exceptionClass
            if event.error.message
                payload.description = event.error.message + " - " + payload.text
        else if event.trigger.type == "projectSpiking"
            payload.check = "Spike of " + event.trigger.rate +
                " exceptions/minute from " + event.project.name
        else
            payload.check = event.trigger.message + " in " +
                event.error.releaseStage + " from " +
                event.project.name

        console.log("API Key " +config.api_key)
        console.log("access_token " +config.access_token)
        @request
            .post("https://demo-api.bigpanda.io/data/v2/alerts")
            .set('Authorization', "Bearer "+config.access_token)
            .set('Content-Type', 'application/json')
            .timeout(4000)
            .send(payload)
            .on "error", (err) ->
                callback(err)
            .end (res) ->
                callback(res.error)
module.exports = BigPanda 
