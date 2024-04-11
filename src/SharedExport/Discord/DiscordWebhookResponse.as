/*
Represents the response from discord, when getting a webhook object.
*/
class DiscordWebhookResponse : DiscordBase
{
    // The id of the webhook.
    DiscordSnowflake@ ID;

    // The type of the webhook.
    int Type;

    // The guild id this webhook is for, if any.
    DiscordSnowflake@ GuildID;

    // The channel id this webhook is for, if any.
    DiscordSnowflake@ ChannelID;

    // The user this webhook was created by (not returned when getting a webhook with its token).
    DiscordUser@ User;

    // The default name of the webhook.
    string Name;

    // The default user avatar hash of the webhook.
    string Avatar;

    // The secure token of the webhook (returned for Incoming Webhooks).
    string Token;

    // The bot/OAuth2 application that created this webhook.
    DiscordSnowflake@ ApplicationID;

    // The guild of the channel that this webhook is following (returned for Channel Follower Webhooks).
    // DiscordGuild@ SourceGuild;

    // The channel that this webhook is following (returned for Channel Follower Webhooks).
    // DiscordChannel@ SourceChannel;

    // The url used for executing the webhook (returned by the webhooks OAuth2 flow).
    string URL;
    
    DiscordWebhookResponse(Json::Value webhook)
    {
        if (webhook.HasKey("id")) @ID = DiscordSnowflake(webhook["id"]);
        Type = GetIntIfExists(webhook, "type");
        if (webhook.HasKey("guild_id")) GuildID = DiscordSnowflake(webhook["guild_id"]);
        if (webhook.HasKey("channel_id")) ChannelID = DiscordSnowflake(webhook["channel_id"]);
        if (webhook.HasKey("user")) User = DiscordUser(webhook["user"]);
        Name = GetStringIfExists(webhook, "name");
        Avatar = GetStringIfExists(webhook, "avatar");
        Token = GetStringIfExists(webhook, "token");
        // if (webhook.HasKey("source_guild")) @SourceGuild = DiscordGuild(webhook["source_guild"]);
        // if (webhook.HasKey("source_channel")) @SourceChannel = DiscordChannel(webhook["source_channel"]);
        if (webhook.HasKey("application_id")) ApplicationID = DiscordSnowflake(webhook["application_id"]);
        URL = GetStringIfExists(webhook, "url");
    }
}
