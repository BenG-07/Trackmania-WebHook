namespace DiscordNotify {
    /*
    A field inside an Embed-object.
    */
    shared class EmbedField {
        // Name of the field.
        string Name;

        // Value of the field.
        string Value;

        // Whether or not this field should display inline.
        bool Inline;

        EmbedField() {}

        EmbedField(const string &in name, const string &in value, bool inline = false) {
            Name = name;
            Value = value;
            Inline = inline;
        }

        string ToString() {
            array<string> content;
            
            if (Name != '') content.InsertLast('"name": "' + Name + '"');
            if (Value != '') content.InsertLast('"value": "' + Value + '"');
            if (Inline) content.InsertLast('"inline": true');

            return '{\n' + string::Join(content, ',\n') + '\n}';
        }
    }
}
