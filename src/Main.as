void Main()
{
#if DEPENDENCY_DISCORD
    if (settings_discord_user_id == "")
    {
        for (uint tries = 0; tries < 10; tries++)
        {
            if (Discord::IsReady())
            {
                string discordUserId = Discord::GetUser().ID;
                DiscordDefaults::UserId = discordUserId;
                settings_discord_user_id = discordUserId;
                Log("Got Discord User!");
                break;
            }
            Log("Tried to get Discord User - was not ready!");

            sleep(500);
        }
    }
#endif
    startnew(PBLoop);
}

void PBLoop()
{
    auto app = cast<CTrackMania@>(GetApp());
    auto currentMap = app.RootMap;
    string lastMapUid;
    Map@ map;
    User@ user = User(app.LocalPlayerInfo);
    uint currentPB;
    uint previousPB;

    while (true)
    {
        // Wait until player is on a map
        while (!IsValidMap(currentMap))
        {
            sleep(3000);
            @app = cast<CTrackMania@>(GetApp());
            @currentMap = app.RootMap;
        }

        // Map changed
        if (currentMap.MapInfo.MapUid != lastMapUid)
        {
            lastMapUid = currentMap.MapInfo.MapUid;
            @map = Map(currentMap);
            previousPB = GetCurrBestTime(app, map.Uid);
            continue;
        }

        currentPB = GetCurrBestTime(app, map.Uid);

        // New PB
        if (currentPB < previousPB)
        {
            Log("New PB: " + currentPB + " (" + Time::Format(currentPB - previousPB) + ")");
            PB@ pb = PB(user, map, previousPB, currentPB);
            auto message = CreateDiscordPBMessage(pb);

            if (settings_SendPB && FilterSolver::FromSettings().Solve(pb))
                SendDiscordWebHook(message);

            previousPB = currentPB;
        }
        
        sleep(1000);
    }
}

bool IsValidMap(CGameCtnChallenge@ map)
{
    if (map is null || map.MapInfo is null) return false;

    return true;
}

uint GetCurrBestTime(CTrackMania@ app, const string &in mapUid)
{
    auto user_manager = app.Network.ClientManiaAppPlayground.UserMgr;
    auto score_manager = app.Network.ClientManiaAppPlayground.ScoreMgr;
    auto user = user_manager.Users[0];
    return score_manager.Map_GetRecord_v2(user.Id, mapUid, "PersonalBest", "", "TimeAttack", "");
}

DiscordWebhookMessage@ CreateDiscordPBMessage(PB@ pb)
{
    Map@ map = pb.Map;

    auto message = DiscordWebhookMessage();
    auto embed = DiscordEmbed();

    auto mapField = DiscordEmbedField("Map", "[" + map.Name + "](" + URL::TrackmaniaIOLeaderboard + map.Uid + ") by [" + map.AuthorName + "](" + URL::TrackmaniaIOPlayer + map.AuthorLogin + ")");
    auto timeField = DiscordEmbedField("Time", Time::Format(pb.CurrentPB) + (pb.PreviousPB != uint(-1) ? " (-" + Time::Format(pb.PreviousPB - pb.CurrentPB) + ")" : ""), true);
    auto rankField = DiscordEmbedField("Rank", "" + pb.Position, true);

    embed.Color = 65290;
    embed.Fields.InsertLast(mapField);
    embed.Fields.InsertLast(timeField);
    embed.Fields.InsertLast(rankField);
    @embed.Thumbnail = DiscordMedia(map.TrackId != 0 ? URL::TrackmaniaExchangeThumbnail + map.TrackId : "");

    message.Username = "Trackmania";
    message.AvatarUrl = "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQCHBYTbusq8rivJAHP59YQbUtiqoqpbiPUS2Mdxi_pDgiYqGtttj0sS3EO05JS6Xama2A&usqp=CAU";
    message.Flags = DiscordMessageFlags::SUPPRESS_NOTIFICATIONS;
    message.Content = "#[" + pb.User.Name + "](" + URL::TrackmaniaIOPlayer + pb.User.Id +") (<@" + settings_discord_user_id + ">) got a new PB " + Medal::ToDiscordString(pb.Medal);
    message.Embeds.InsertLast(embed);

    return message;
}

void SendDiscordWebHook(DiscordWebhookMessage@ message)
{
    Log("Sending Message to DiscordWebhook");

    string url = settings_discord_URL;
    DiscordWebhook@ webHook = DiscordWebhook(url);
    webHook.Execute(message, true);
}
