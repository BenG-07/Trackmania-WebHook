class Player
{
    string Id;
    string Name;

    Player(CGamePlayerInfo@ player)
    {
        Id = player.WebServicesUserId;
        Name = player.Name;
    }
}
