/*
A Discord user.
*/
class DiscordUser : DiscordBase
{
    // The user's id.
    DiscordSnowflake@ ID;
    // The user's username, not unique across the platform.
    string Username;
    // The user's Discord-tag.
    string Discriminator;
    // The user's display name, if it is set. For bots, this is the application name.
    string GlobalName;
    // The user's avatar hash.
    string Avatar;
    // Whether the user belongs to an OAuth2 application.
    bool Bot;
    // Whether the user is an Official Discord System user (part of the urgent message system).
    bool System;
    // Whether the user has two factor enabled on their account.
    bool MFAEnabled;
    // The user's banner hash.
    string Banner;
    // The user's banner color encoded as an integer representation of hexadecimal color code.
    int AccentColor;
    // The user's chosen language option.
    string Locale;
    // Whether the email on this account has been verified.
    bool Verified;
    // The user's email.
    string Email;
    // The flags on a user's account.
    int Flags;
    // The type of Nitro subscription on a user's account.
    int PremiumType;
    // The public flags on a user's account.
    int PublicFlags;
    // The user's avatar decoration hash.
    string AvatarDecoration;
    DiscordUser(Json::Value@ user)
    {
        if (user.HasKey("id")) @ID = DiscordSnowflake(user["id"]);
        Username = GetStringIfExists(user, "username");
        Discriminator = GetStringIfExists(user, "discriminator");
        GlobalName = GetStringIfExists(user, "global_name");
        Avatar = GetStringIfExists(user, "avatar");
        Bot = GetBoolIfExists(user, "bot");
        System = GetBoolIfExists(user, "system");;
        MFAEnabled = GetBoolIfExists(user, "mfa_enabled");
        Banner = GetStringIfExists(user, "banner");
        AccentColor = GetIntIfExists(user, "accent_color");
        Locale = GetStringIfExists(user, "locale");
        Verified = GetBoolIfExists(user, "verified");
        Email = GetStringIfExists(user, "email");
        Flags = GetIntIfExists(user, "flags");
        PremiumType = GetIntIfExists(user, "premium_type");
        PublicFlags = GetIntIfExists(user, "public_flags");
        AvatarDecoration = GetStringIfExists(user, "avatar_decoration");
    }
}
