/*
A Discord webhook with most functionalities you can use without Authorization.
*/
class DiscordWebhook
{
    // The ID of the Webhook.
    int ID;
    
    // The Token of the Webhook.
    string Token;
    
    // The base endpoint of the Webhook.
    string WebhookEndpoint;
    
    // The endpoint to manage messages of the Webhook.
    string MessagesEndpoint;

    DiscordWebhook(const string &in url)
    {
        if (Regex::Match(url, """(https:\/\/)?((ptb|canary)\.)?discord\.com\/api\/webhooks\/[0-9]*\/[\w-]+""").Length == 0)
            throw("Invalid discord webhook url: " + url);
        
        WebhookEndpoint = url;
        MessagesEndpoint = WebhookEndpoint + "/messages";
        auto parts = Regex::Replace(WebhookEndpoint, """(https:\/\/)?((ptb|canary)\.)?discord\.com\/   api\\/webhooks\/""", "").Split("/");
        ID = Text::ParseInt(parts[0]);
        Token = parts[1];
    }

    DiscordWebhook(int id, const string &in token)
    {
        ID = id;
        Token = token;
        WebhookEndpoint = ID + "/" + Token;
        MessagesEndpoint = WebhookEndpoint + "/messages";
    }

    /*
    Gets information for this webhook from Discord.
    
    Returns the webhook information or `null` on failure.
    */
    DiscordWebhookResponse@ Get()
    {
        Net::HttpRequest@ request = Net::HttpRequest();
        request.Method = Net::HttpMethod::Get;
        request.Url = this.WebhookEndpoint;
        request.Headers["Host"] = "discord.com";
        request.Start();

        while (!request.Finished()) { sleep(1); }

        // Statuscode 204: OK
        if (request.ResponseCode() == 200)
            return DiscordWebhookResponse(request.String());

        // Any other Statuscode: Error
        error("Err: Failed to fetch information about the Discord webhook (ID: " + ID + ") - (Code: " + request.ResponseCode() + ") " + request.String());
        return null;
    }

    /*
    Modifies this webhook.
    body: must be valid json syntax. accepted keys: "name"

    Returns the webhook information or `null` on failure.
    */
    DiscordWebhookResponse@ Modify(const string &in body)
    {
        // TODO: add avatar-compatibility
        Net::HttpRequest@ request = Net::HttpRequest();
        request.Method = Net::HttpMethod::Patch;
        request.Url = this.WebhookEndpoint;
        request.Headers["Host"] = "discord.com";
        request.Headers["Content-Type"] = "application/json";
        request.Headers["Content-Length"] = "" + body.Length;
        request.Body = body;
        request.Start();
        
        while (!request.Finished()) { sleep(1); }

        // Statuscode 204: OK
        if (request.ResponseCode() == 200)
            return DiscordWebhookResponse(request.String());

        // Any other Statuscode: Error
        error("Err: Failed to modify the Discord webhook (ID: " + ID + ") - (Code: " + request.ResponseCode() + ") " + request.String());
        return null;
    }

    /*
    Deletes this webhook.

    Returns if the operation was successful.
    */
    bool Delete()
    {
        Net::HttpRequest@ request = Net::HttpRequest();
        request.Method = Net::HttpMethod::Delete;
        request.Url = this.WebhookEndpoint;
        request.Headers["Host"] = "discord.com";
        request.Start();

        while (!request.Finished()) { sleep(1); }

        // Statuscode 204: OK - No content
        if (request.ResponseCode() == 204)
            return true;

        // Any other Statuscode: Error
        error("Err: Failed to delete the Discord webhook (ID: " + ID + ") - (Code: " + request.ResponseCode() + ") " + request.String());
        return false;
    }

    /*
    Sends a message via this webhook.
    message: the message
    wait: whether to wait for server confirmation or not - returns null when `false`

    Returns the response.
    */
    DiscordMessage@ Execute(DiscordWebhookMessage@ message, bool wait = false/*, DiscordSnowflake@ threadID = null*/)
    {
        string url = this.WebhookEndpoint;
        if (wait)
            url += "?wait=true";
        
        string body = message.ToString();

        Net::HttpRequest@ request = Net::HttpRequest();
        request.Method = Net::HttpMethod::Post;
        request.Url = url;
        request.Headers["Host"] = "discord.com";
        request.Headers["Content-Type"] = "application/json";
        request.Headers["Content-Length"] = "" + body.Length;
        request.Body = body;
        request.Start();

        while (!request.Finished()) { sleep(1); }

        // Statuscode 200: OK - wait was true => return Message
        if (request.ResponseCode() == 200)
            return DiscordMessage(Json::Parse(request.String()));

        // Statuscode 204: OK - wait was false => return null
        if (request.ResponseCode() == 204)
            return null;

        // Any other Statuscode: Error
        error("Err: Failed to execute the Discord webhook (ID: " + ID + ") - (Code: " + request.ResponseCode() + ") " + request.String());
        return null;
    }

    /*
    Gets a message sent via this webhook.
    messageID: The ID of the message.

    Returns the message or `null` on failure.
    */
    DiscordMessage@ GetMessage(int messageID/*, DiscordSnowflake@ threadID = null*/)
    {
        string url = this.MessagesEndpoint + "/" + messageID;

        Net::HttpRequest@ request = Net::HttpRequest();
        request.Method = Net::HttpMethod::Get;
        request.Url = url;
        request.Headers["Host"] = "discord.com";
        request.Start();

        while (!request.Finished()) { sleep(1); }

        // Statuscode 200: OK
        if (request.ResponseCode() == 200)
            return DiscordMessage(request.String());

        // Any other Statuscode: Error
        error("Err: Failed to fetch the message (ID: " + messageID + ") from the Discord webhook (ID: " + ID + ") - (Code: " + request.ResponseCode() + ") " + request.String());
        return null;
    }
    
    /*
    Edits a message sent via this webhook.
    messageID: The ID of the message.
    message: The new message.

    Returns the message or `null` on failure.
    */
    DiscordMessage@ EditMessage(int messageID, DiscordWebhookMessage@ message/*, DiscordSnowflake@ threadID = null*/)
    {
        string url = this.MessagesEndpoint + "/" + messageID;
        string body = message.ToString();
        
        Net::HttpRequest@ request = Net::HttpRequest();
        request.Method = Net::HttpMethod::Patch;
        request.Url = url;
        request.Headers["Host"] = "discord.com";
        request.Headers["Content-Type"] = "application/json";
        request.Headers["Content-Length"] = "" + body.Length;
        request.Body = body;
        request.Start();

        while (!request.Finished()) { sleep(1); }

        // Statuscode 200: OK
        if (request.ResponseCode() == 200)
            return DiscordMessage(request.String());

        // Any other Statuscode: Error
        error("Err: Failed to edit the message (ID: " + messageID + ") from the Discord webhook (ID: " + ID + ") - (Code: " + request.ResponseCode() + ") " + request.String());
        return null;
    }

    /*
    Deletes a message sent via this webhook.
    messageID: The ID of the message.

    Returns if the operation was successful.
    */
    bool DeleteMessage(int messageID/*, DiscordSnowflake@ threadID = null*/)
    {
        string url = this.MessagesEndpoint + "/" + messageID;

        Net::HttpRequest@ request = Net::HttpRequest();
        request.Method = Net::HttpMethod::Delete;
        request.Url = url;
        request.Headers["Host"] = "discord.com";
        request.Start();

        while (!request.Finished()) { sleep(1); }

        // Statuscode 204: OK - No content
        if (request.ResponseCode() == 204)
            return true;

        // Any other Statuscode: Error
        error("Err: Failed to delete the message (ID: " + messageID + ") from the Discord webhook (ID: " + ID + ") - (Code: " + request.ResponseCode() + ") " + request.String());
        return false;
    }
}
