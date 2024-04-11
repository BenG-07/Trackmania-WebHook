/*
A Media-object inside an an Embed-object.
Can be either an image, thumbnail or video.
*/
class DiscordMedia
{
    // Source url of media (only supports http(s) and attachments).
    string URL;
    
    // A proxied url of the media.
    string ProxyURL;
    
    // Height of media.
    int Height;
    
    // Width of media.
    int Width;
    
    DiscordMedia() { }
    
    DiscordMedia(const string &in url)
    {
        URL = url;
    }
    
    string ToString()
    {
        array<string> content;
        if (URL != '') content.InsertLast('"url": "' + URL + '"');
        if (ProxyURL != '') content.InsertLast('"proxy_url": "' + ProxyURL + '"');
        if (Height != 0) content.InsertLast('"height": ' + Height);
        if (Width != 0) content.InsertLast('"width": ' + Width);
        return '{\n' + string::Join(content, ',\n') + '\n}';
    }
}
