namespace DiscordNotify {
    /*
    A provider inside an Embed-object.
    */
    shared class Provider {
        // Name of provider.
        string Name;

        // Url of provider.
        string URL;

        Provider() {}

        string ToString() {
            array<string> content;

            if (Name != '') content.InsertLast('"name": "' + Name + '"');
            if (URL != '') content.InsertLast('"url": "' + URL + '"');

            return '{\n' + string::Join(content, ',\n') + '\n}';
        }
    }
}
