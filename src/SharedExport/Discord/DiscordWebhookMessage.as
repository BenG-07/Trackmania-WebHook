/*
A Message that can be sent via a webhook.
*/
class DiscordWebhookMessage
{
    // The message contents (up to 2000 characters).
    string Content;

    // Override the default username of the webhook.
    string Username;
    
    // Override the default avatar of the webhook.
    string AvatarUrl;

    // True if this is a TTS message.
    bool TTS;

    // Array of up to 10 embed objects.
    array<DiscordEmbed@> Embeds;

    // Allowed mentions for the message.
    DiscordAllowedMentions@ AllowedMentions;

    // Message flags combined as a bitfield (only SUPPRESS_EMBEDS and SUPPRESS_NOTIFICATIONS can be set).
    uint Flags;

    // Name of thread to create (requires the webhook channel to be a forum or media channel).
    string ThreadName;

    // TODO:
    //DiscordFileContent@ Files;
    //string PayloadJson;
    //DiscordAttachment@ Attachements;
    //array<DiscordSnowflake@> AppliedTags;

    // Requires an application-owned webhook.
    //array<DiscordComponent@> Components;

    DiscordWebhookMessage() { }

    string ToString()
    {
        array<string> content;
        if (Content != '') content.InsertLast('"content": "' + Content + '"');
        if (Username != '') content.InsertLast('"username": "' + Username + '"');
        if (AvatarUrl != '') content.InsertLast('"avatar_url": "' + AvatarUrl + '"');
        if (TTS) content.InsertLast('"tts": true');
        array<string> embedsStr;
        for (uint i = 0; i < Embeds.Length; i++)
            embedsStr.InsertLast(Embeds[i].ToString());
        if (!Embeds.IsEmpty()) content.InsertLast('"embeds": [' + string::Join(embedsStr, ',\n') + ']');
        if (AllowedMentions !is null) content.InsertLast(AllowedMentions.ToString());
        if (Flags != 0) content.InsertLast('"flags": ' + Flags);
        if (ThreadName != '') content.InsertLast('"thread_name": "' + ThreadName + '"');
        return '{\n' + string::Join(content, ',\n') + '\n}';
    }
}
