namespace DiscordNotify {
    /*
    Represents the response from discord, when getting a webhook object.
    */
    shared class WebhookResponse : DiscordBase {
        // The id of the webhook.
        Snowflake@ ID;

        // The type of the webhook.
        int Type;

        // The guild id this webhook is for, if any.
        Snowflake@ GuildID;

        // The channel id this webhook is for, if any.
        Snowflake@ ChannelID;

        // The user this webhook was created by (not returned when getting a webhook with its token).
        User@ User;

        // The default name of the webhook.
        string Name;

        // The default user avatar hash of the webhook.
        string Avatar;

        // The secure token of the webhook (returned for Incoming Webhooks).
        string Token;

        // The bot/OAuth2 application that created this webhook.
        Snowflake@ ApplicationID;

        // The guild of the channel that this webhook is following (returned for Channel Follower Webhooks).
        // DiscordGuild@ SourceGuild;

        // The channel that this webhook is following (returned for Channel Follower Webhooks).
        // DiscordChannel@ SourceChannel;

        // The url used for executing the webhook (returned by the webhooks OAuth2 flow).
        string URL;

        WebhookResponse(Json::Value webhook) {
            if (webhook.HasKey("id")) @ID = Snowflake(webhook["id"]);
            Type = GetIntIfExists(webhook, "type");
            if (webhook.HasKey("guild_id")) GuildID = Snowflake(webhook["guild_id"]);
            if (webhook.HasKey("channel_id")) ChannelID = Snowflake(webhook["channel_id"]);
            if (webhook.HasKey("user")) User = DiscordNotify::User(webhook["user"]);
            Name = GetStringIfExists(webhook, "name");
            Avatar = GetStringIfExists(webhook, "avatar");
            Token = GetStringIfExists(webhook, "token");
            // if (webhook.HasKey("source_guild")) @SourceGuild = DiscordGuild(webhook["source_guild"]);
            // if (webhook.HasKey("source_channel")) @SourceChannel = DiscordChannel(webhook["source_channel"]);
            if (webhook.HasKey("application_id")) ApplicationID = Snowflake(webhook["application_id"]);
            URL = GetStringIfExists(webhook, "url");
        }
    }
}
