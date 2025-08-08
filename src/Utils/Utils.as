// @example Log("Hello, world!");
void Log(const string &in message)
{
    if (!settings_debug_log) return;
    
    trace(message);
}

// @example LogJson("APIResponse", response);
void LogJson(const string &in label, Json::Value@ json)
{
    if (!settings_debug_log) return;
    
    trace(label + ": " + Json::Write(json));
}