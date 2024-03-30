class PB
{
    User@ User;
    Map@ Map;
    uint PreviousPB;
    uint CurrentPB;
    int position;

    PB(User@ user, Map@ map, uint previousPB, uint currentPB)
    {
        @User = user;
        @Map = map;
        PreviousPB = previousPB;
        CurrentPB = currentPB;
        position = GetPBPosition(Map.Uid, CurrentPB);
    }

    int GetPBPosition(const string &in mapUid, uint time)
    {
        for (int tries = 0; tries < 10; tries++)
        {
            try
            {
                auto info = Nadeo::LiveServiceRequest("/api/token/leaderboard/group/Personal_Best/map/" + mapUid + "/surround/0/0?onlyWorld=true");

                if (info.HasKey("tops"))
                {
                    auto tops = info["tops"];
                    if (tops.GetType() == Json::Type::Array)
                    {
                        auto top = tops[0]["top"];
                        auto score = top[0]["score"];
                        auto position = top[0]["position"];
                        // If wrong time/leaderboard entry was fetched => try again
                        if(int(time) != score)
                        {
                            sleep(100 * tries);
                            continue;
                        }

                        return position;
                    }
                }
            }
            catch {}
        }

        return -1;
    }
    
    string GetReachedMedal()
    {
#if DEPENDENCY_CHAMPIONMEDALS
        if (CurrentPB <= Map.ChampionMedalTime) return settings_champion_medal_string;
#endif
        if (CurrentPB <= Map.AuthorMedalTime) return settings_at_medal_string;
        if (CurrentPB <= Map.GoldMedalTime) return settings_gold_medal_string;
        if (CurrentPB <= Map.SilverMedalTime) return settings_silver_medal_string;
        if (CurrentPB <= Map.BronzeMedalTime) return settings_bronze_medal_string;
        return settings_no_medal_string;
    }
}
