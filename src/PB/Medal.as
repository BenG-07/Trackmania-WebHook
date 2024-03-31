enum Medal
{
    No,
    Bronze,
    Silver,
    Gold,
    Author,
    Champion
}

namespace Medal
{
    string ToString(Medal medal)
    {
        switch (medal)
        {
            case Medal::No:
                return settings_no_medal_string;
            case Medal::Bronze:
                return settings_bronze_medal_string;
            case Medal::Silver:
                return settings_silver_medal_string;
            case Medal::Gold:
                return settings_gold_medal_string;
            case Medal::Author:
                return settings_at_medal_string;
            case Medal::Champion:
                return settings_champion_medal_string;
        }

        return "";
    }
}
