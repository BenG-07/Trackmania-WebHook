/*
DO NOT USE THIS - PROBABLY GETS MOVED TO OTHER CLASS.
Some common function for Discord webhook related operations.
*/
class DiscordBase
{
        protected string GetStringIfExists(Json::Value@ value, const string &in key)
        {
            if (value.HasKey(key) && value[key].GetType() == Json::Type::String)
                return value[key];

            return "";
        }

        protected bool GetBoolIfExists(Json::Value@ value, const string &in key)
        {
            if (value.HasKey(key) && value[key].GetType() == Json::Type::Boolean)
                return value[key];

            return false;
        }

        protected int GetIntIfExists(Json::Value@ value, const string &in key)
        {
            if (value.HasKey(key) && value[key].GetType() == Json::Type::Number)
                return value[key];

            return 0;
        }
}
