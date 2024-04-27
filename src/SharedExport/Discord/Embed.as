namespace DiscordNotify {
    /*
    An embeded object to better seperate fields in a message.
    */
    shared class Embed {
        // Title of embed.
        string Title;

        // Type of embed (always "rich" for webhook embeds).
        string Type;

        // Description of embed.
        string Description;

        // Url of embed.
        string URL;

        // Timestamp of embed content.
        uint64 Timestamp;

        // Color code of the embed.
        int Color;

        // Footer information.
        Footer@ Footer;

        // Image information.
        Media@ Image;

        // Thumbnail information.
        Media@ Thumbnail;

        // Video information.
        Media@ Video;

        // Provider information.
        Provider@ Provider;

        // Author information.
        Author@ Author;

        // Fields information, max of 25.
        array<EmbedField@> Fields;

        Embed() {}

        string ToString() {
            array<string> content;

            if (Title != '') content.InsertLast('"title": "' + Title + '"');
            if (Type != '') content.InsertLast('"type": "' + Type + '"');
            if (Description != '') content.InsertLast('"description": "' + Description + '"');
            if (URL != '') content.InsertLast('"url": "' + URL + '"');
            if (Timestamp != 0) content.InsertLast('"timestamp": "' + Timestamp + '"');
            if (Color != 0) content.InsertLast('"color": ' + Color);
            if (Footer !is null) content.InsertLast('"footer": ' + Footer.ToString());
            if (Image !is null) content.InsertLast('"image": ' + Image.ToString());
            if (Thumbnail !is null) content.InsertLast('"thumbnail": ' + Thumbnail.ToString());
            if (Video !is null) content.InsertLast('"video": ' + Video.ToString());
            if (Provider !is null) content.InsertLast('"provider": ' + Provider.ToString());
            if (Author !is null) content.InsertLast('"author": ' + Author.ToString());

            array<string> fieldsStr;
            for (uint i = 0; i < Fields.Length; i++)
                fieldsStr.InsertLast(Fields[i].ToString());
            if (!Fields.IsEmpty()) content.InsertLast('"fields": [' + string::Join(fieldsStr, ',\n') + ']');

            return '{\n' + string::Join(content, ',\n') + '\n}';
        }
    }
}
