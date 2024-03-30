class Map
{
    string Uid;
    string Name;
    string CleansedName;
    uint BronzeMedalTime;
    uint SilverMedalTime;
    uint GoldMedalTime;
    uint AuthorMedalTime;
    uint ChampionMedalTime;

    Map(CGameCtnChallenge@ map)
    {
        Uid = map.MapInfo.MapUid;
        Name = map.MapInfo.Name;
        CleansedName = GetCleansedTrackmaniaStyledString(Name);

        BronzeMedalTime = map.TMObjective_BronzeTime;
        SilverMedalTime = map.TMObjective_SilverTime;
        GoldMedalTime = map.TMObjective_GoldTime;
        AuthorMedalTime = map.TMObjective_AuthorTime;
#if DEPENDENCY_CHAMPIONMEDALS
        ChampionMedalTime = ChampionMedals::GetCMTime();
#endif
    }

    string GetCleansedTrackmaniaStyledString(string _dirty)
    {
        string pattern = """\$[oiwntsgzOIWNTSGZ]|\$[0-9a-fA-F]{3}""";

        array<string> parts = _dirty.Split("$$");
        for (uint i = 0; i < parts.Length; i++)
            parts[i] = Regex::Replace(parts[i], pattern, "");

        return string::Join(parts, "$");
    }
}
