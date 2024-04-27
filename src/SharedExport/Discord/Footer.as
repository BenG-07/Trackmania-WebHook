namespace DiscordNotify {
    /*
    A footer at the end of an Embed-object.
    */
    shared class Footer
    {
        // Footer text - can not be empty.
        string Text;

        // Url of footer icon (only supports http(s) and attachments).
        string IconURL;

        // A proxied url of footer icon.
        string ProxyIconURL;

        Footer(const string &in text)
        {
            this.Text = text;
        }

        string ToString()
        {
            array<string> content;
            
            content.InsertLast('"text": "' + Text + '"');
            if (IconURL != '') content.InsertLast('"icon_url": "' + IconURL + '"');
            if (ProxyIconURL != '') content.InsertLast('"proxy_icon_url": "' + ProxyIconURL + '"');

            return '{\n' + string::Join(content, ',\n') + '\n}';
        }
    }
}
