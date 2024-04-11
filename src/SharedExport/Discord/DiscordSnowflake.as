/*
Discord utilizes Twitter's snowflake format for uniquely identifiable descriptors (IDs). These IDs are guaranteed to be unique across all of Discord, except in some unique scenarios in which child objects share their parent's ID. Because Snowflake IDs are up to 64 bits in size (e.g. a uint64), they are always returned as strings in the HTTP API to prevent integer overflows in some languages. See Gateway ETF/JSON for more information regarding Gateway encoding.
*/
class DiscordSnowflake
{
    int64 Snowflake;
    
    // Milliseconds since Discord Epoch, the first second of 2015 or 1420070400000.
    uint64 Timestamp;

    int InternalWorkerID;

    int InternalProcessID;

    // For every ID that is generated on that process, this number is incremented.
    int Increment;

    DiscordSnowflake(const string &in str)
    {
        Snowflake = Text::ParseUInt64(str);
        Timestamp = (Snowflake >> 22) + 1420070400000;
        InternalWorkerID = (Snowflake & 0x3E0000) >> 17;
        InternalProcessID = (Snowflake & 0x1F000) >> 12;
        Increment = Snowflake & 0xFFF;
    }
    
    string ToString()
    {
        return '' + Snowflake;
    }
}
