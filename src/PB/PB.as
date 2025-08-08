class PB
{
    User@ User;
    Map@ Map;
    uint PreviousPB;
    uint CurrentPB;
    int Position;
    Medal Medal;

    PB(User@ user, Map@ map, uint previousPB, uint currentPB)
    {
        @User = user;
        @Map = map;
        PreviousPB = previousPB;
        CurrentPB = currentPB;
        Position = GetPBPosition(Map.Uid, CurrentPB);
        Medal = GetReachedMedal(CurrentPB, Map);
    }

    // The positions returned by this endpoint correspond to existing records.
    // documentation:https://webservices.openplanet.dev/live/leaderboards/surround
    int GetPBPosition(const string &in mapUid, uint time)
    {
        for (int tries = 0; tries < 10; tries++)
        {
            try
            {
                auto info = Nadeo::LiveServiceGetRequest("/api/token/leaderboard/group/Personal_Best/map/" + mapUid + "/surround/0/0?onlyWorld=true&score=" + time);
                LogJson("API Response Surround - Try " +  (tries + 1) + " of 10", info);

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
                            sleep(100 * (tries + 1));
                            continue;
                        }

                        return position;
                    }
                }
            }
            catch {}

            // Wait between retries
            sleep(100 * (tries + 1));
        }

        return -1;
    }
    
    private Medal GetReachedMedal(uint currentPB, Map@ map)
    {
#if DEPENDENCY_CHAMPIONMEDALS
        if (currentPB <= map.ChampionMedalTime) return Medal::Champion;
#endif
        if (currentPB <= map.AuthorMedalTime) return Medal::Author;
        if (currentPB <= map.GoldMedalTime) return Medal::Gold;
        if (currentPB <= map.SilverMedalTime) return Medal::Silver;
        if (currentPB <= map.BronzeMedalTime) return Medal::Bronze;
        return Medal::No;
    }
}
