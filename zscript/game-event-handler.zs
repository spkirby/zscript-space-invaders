class GameEventHandler : EventHandler {
    override void WorldThingDied(WorldEvent event) {
        foreach (SpaceInvadersGame game : ThinkerIterator.Create("SpaceInvadersGame", Thinker.STAT_DEFAULT)) {
            game.ActorKilled(event.Thing);
        }
    }
}