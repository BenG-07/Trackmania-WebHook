namespace Nadeo
{
    // Get Request
    Json::Value LiveServiceGetRequest(const string &in route)
    {
        while (!NadeoServices::IsAuthenticated("NadeoLiveServices")) yield();

        auto req = NadeoServices::Get("NadeoLiveServices", NadeoServices::BaseURLLive() + route);
        return Web::Request(req);
    }
    
    // Post Request
    Json::Value LiveServicePostRequest(const string &in route, const string &in body)
    {
        while (!NadeoServices::IsAuthenticated("NadeoLiveServices")) yield();

        auto req = NadeoServices::Post("NadeoLiveServices", NadeoServices::BaseURLLive() + route, body, "application/json");
        return Web::Request(req);
    }
}