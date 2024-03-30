[SettingsTab name="Discord" icon="DiscordAlt" order=0]
void RenderDiscordSettings()
{
    RenderResetButton();

    settings_discord_URL = UI::InputText("Discord WebHook-URL", settings_discord_URL);
#if !DEPENDENCY_DISCORD
    settings_discord_user_id = UI::InputText("Discord User-ID", settings_discord_user_id);
#endif
    settings_SendPB = UI::Checkbox("Send PB", settings_SendPB);

#if SIG_DEVELOPER
    settings_AdvancedDiscordSettings = UI::Checkbox("Advanced Settings", settings_AdvancedDiscordSettings);
#endif

    if (!settings_AdvancedDiscordSettings) return;

    // Advanced settings

    UI::BeginTabBar("DiscordWebHookSettings", UI::TabBarFlags::FittingPolicyResizeDown);
#if DEPENDENCY_DISCORD
    if (UI::BeginTabItem(Icons::Cogs + " General"))
    {
        settings_discord_user_id = UI::InputText("Discord User-ID", settings_discord_user_id);
		UI::EndTabItem();
    }
#endif
    if (UI::BeginTabItem(Icons::Kenney::Radio + " Medals"))
    {
        RenderMedalInput();
		UI::EndTabItem();
    }
    
    if (UI::BeginTabItem(Icons::File + " Request body"))
    {
        settings_Body = UI::InputTextMultiline("Request body", settings_Body);
		UI::EndTabItem();
    }
    
    UI::EndTabBar();
}

void RenderResetButton()
{
    if (UI::ButtonColored("Reset to default", 0.0f))
    {
        settings_discord_user_id = DiscordDefaults::UserId;
        settings_discord_URL = DiscordDefaults::URL;
        settings_SendPB = true;
        settings_AdvancedDiscordSettings = false;
        settings_no_medal_string = DiscordDefaults::NoMedal;
        settings_bronze_medal_string = DiscordDefaults::BronzeMedal;
        settings_silver_medal_string = DiscordDefaults::SilverMedal;
        settings_gold_medal_string = DiscordDefaults::GoldMedal;
        settings_at_medal_string = DiscordDefaults::AuthorMedal;
        settings_champion_medal_string = DiscordDefaults::ChampionMedal;
        settings_Body = DiscordDefaults::Body;
    }
}

void RenderMedalInput()
{
    settings_no_medal_string = UI::InputText("##no_medal", settings_no_medal_string);
    RenderMedalInputHelp("no", "<:no_medal:1223567676421570601>");

    settings_bronze_medal_string = UI::InputText("##bronze_medal", settings_bronze_medal_string);
    RenderMedalInputHelp("bronze", "<:bronze_medal:1223564781437583381>");

    settings_silver_medal_string = UI::InputText("##silver_medal", settings_silver_medal_string);
    RenderMedalInputHelp("silver", "<:silver_medal:1223564769491943465>");

    settings_gold_medal_string = UI::InputText("##gold_medal", settings_gold_medal_string);
    RenderMedalInputHelp("gold", "<:gold_medal:1223564758427369472>");

    settings_at_medal_string = UI::InputText("##at_medal", settings_at_medal_string);
    RenderMedalInputHelp("author", "<:at_medal:1223564741642027079>");

#if DEPENDENCY_CHAMPIONMEDALS
    settings_champion_medal_string = UI::InputText("##champion_medal", settings_champion_medal_string);
    RenderMedalInputHelp("champion", "<:champion_medal:1223564726500462632>");
#endif
}

void RenderMedalInputHelp(const string &in medalName, const string &in medalId)
{
    UI::SameLine();
    UI::Text("Emoji-ID for " + medalName +" medal");
    if (UI::IsItemHovered())
    {
		UI::BeginTooltip();
		UI::Text("e.g.: " + medalId);
		UI::EndTooltip();
    }
    if (UI::IsItemClicked())
        IO::SetClipboard(medalId);
}
