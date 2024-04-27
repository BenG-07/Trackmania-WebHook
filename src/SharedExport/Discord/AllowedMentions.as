namespace DiscordNotify {
    /*
    The allowed mention field allows for more granular control over mentions without various hacks to the message content. This will always validate against message content to avoid   phantom pings (e.g. to ping everyone, you must still have @everyone in the message content), and check against user/bot permissions.
    If allowed_mentions is not passed in (i.e. the key does not exist), the mentions will be parsed via the content. This corresponds with existing behavior.
    */
    shared class AllowedMentions {
        // An array of allowed mention types to parse from the content.
        array<AllowedMentionType> DiscordAllowedMentions;

        // Array of role_ids to mention (Max size of 100).
        array<Snowflake@> Roles;

        // Array of user_ids to mention (Max size of 100).
        array<Snowflake@> Users;

        // For replies, whether to mention the author of the message being replied to (default false).
        bool RepliedUser;

        AllowedMentions() {}

        string DiscordAllowedMentionType_ToString(AllowedMentionType type) {
            switch(type) {
                case AllowedMentionType::Roles:
                    return "roles";
                case AllowedMentionType::Users:
                    return "users";
                case AllowedMentionType::Everyone:
                    return "everyone";
            }

            throw("No matching type for DiscordAllowedMentionType!");
            return "";
        }

        string ToString() {
            array<string> content;

            array<string> parseStr;
            for (uint i = 0; i < DiscordAllowedMentions.Length; i++)
                parseStr.InsertLast('"' + DiscordAllowedMentionType_ToString(DiscordAllowedMentions[i]) + '"');
            if (!DiscordAllowedMentions.IsEmpty()) content.InsertLast('"parse": [' + string::Join(parseStr, ',\n') + ']');

            array<string> rolesStr;
            for (uint i = 0; i < Roles.Length; i++)
                rolesStr.InsertLast('"' + Roles[i].ToString() + '"');
            if (!Roles.IsEmpty()) content.InsertLast('"roles": [' + string::Join(rolesStr, ',\n') + ']');

            array<string> usersStr;
            for (uint i = 0; i < Users.Length; i++)
                usersStr.InsertLast('"' + Users[i].ToString() + '"');
            if (!Users.IsEmpty()) content.InsertLast('"Users": [' + string::Join(usersStr, ',\n') + ']');

            if (RepliedUser) content.InsertLast('"replied_user": true');

            return '{\n' + string::Join(content, ',\n') + '\n}';
        }
    }
}
