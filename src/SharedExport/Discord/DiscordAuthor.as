/*
The author of an embeded field.
*/
class DiscordAuthor : DiscordBase
{
    // Name of author.
    string Name;

    // Url of author (only supports http(s)).
    string URL;

    // Url of author icon (only supports http(s) and attachments).
    string IconURL;

    // A proxied url of author icon.
    string ProxyIconURL;

    DiscordAuthor() { }

    DiscordAuthor(Json::Value author)
    {
        Name = GetStringIfExists(author, "name");
        URL = GetStringIfExists(author, "url");
        IconURL = GetStringIfExists(author, "icon_url");
        ProxyIconURL = GetStringIfExists(author, "proxy_icon_url");
    }
    
    string ToString()
    {
        array<string> content;
        if (Name != '') content.InsertLast('"name": "' + Name + '"');
        if (URL != '') content.InsertLast('"url": "' + URL + '"');
        if (IconURL != '') content.InsertLast('"icon_url": "' + IconURL + '"');
        if (ProxyIconURL != '') content.InsertLast('"proxy_icon_url": "' + ProxyIconURL + '"');
        return '{\n' + string::Join(content, ',\n') + '\n}';
    }
}
