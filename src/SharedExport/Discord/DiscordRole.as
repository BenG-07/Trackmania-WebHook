/*
Roles represent a set of permissions attached to a group of users. Roles have names, colors, and can be "pinned" to the side bar, causing their members to be listed separately. Roles can have separate permission profiles for the global context (guild) and channel context. The @everyone role has the same ID as the guild it belongs to.
*/
class DiscordRole : DiscordBase
{
    // Role id.
    DiscordSnowflake@ ID;
    
    // Role name.
    string Name;
    
    // Integer representation of hexadecimal color code.
    int Color;
    
    // If this role is pinned in the user listing.
    bool Hoist;
    
    // Role icon hash.
    string Icon;
    
    // Role unicode emoji.
    string UnicodeEmoji;
    
    // Position of this role.
    int Position;
    
    // Permission bit set.
    string Permissions;
    
    // Whether this role is managed by an integration.
    bool Managed;
    
    // Whether this role is mentionable.
    bool Mentionable;
    
    // The tags this role has.
    //DiscordRoleTags@ Tags;
    
    // Role flags combined as a bitfield.
    int Flags;
    
    DiscordRole(Json::Value role)
    {
        if (role.HasKey("id")) @ID = DiscordSnowflake(role["id"]);
        Name = GetStringIfExists(role, "name");
        Color = GetIntIfExists(role, "color");
        Hoist = GetBoolIfExists(role, "hoist");
        Icon = GetStringIfExists(role, "icon");
        UnicodeEmoji = GetStringIfExists(role, "unicode_emoji");
        Position = GetIntIfExists(role, "position");
        Permissions = GetStringIfExists(role, "permissions");
        Managed = GetBoolIfExists(role, "managed");
        Mentionable = GetBoolIfExists(role, "mentionable");
        //if (role.HasKey("tags")) Tags = DiscordRoleTags(role["tags"]);
        Flags = GetIntIfExists(role, "flags");
    }
}
