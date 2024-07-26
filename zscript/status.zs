class StatusHandler : EventHandler {
	override void RenderOverlay(RenderEvent event) {
		if (AutoMapActive) {
			return;
		}
	
        Statusbar.BeginHUD();

        foreach (SpaceInvadersGame game : ThinkerIterator.Create("SpaceInvadersGame", Thinker.STAT_DEFAULT)) {
            UpdateStatus(game);
        }
	}

    ui void UpdateStatus(SpaceInvadersGame game) {
        let x = -224;

        for (let i = 1; i < game.playerLives; i++) {
            Statusbar.DrawImage(
                "PLYSA0",
                (x, 0),
                Statusbar.DI_SCREEN_CENTER_BOTTOM | Statusbar.DI_ITEM_LEFT_BOTTOM,
                scale: (1, 1)
            );

            x += 32;
        }

        Statusbar.DrawImage(
            "GROUND",
            (-224, -24),
            Statusbar.DI_SCREEN_CENTER_BOTTOM | Statusbar.DI_ITEM_LEFT_BOTTOM
        );

        Statusbar.DrawImage(
            "STCREDIT",
            (224, 0),
            Statusbar.DI_SCREEN_CENTER_BOTTOM | Statusbar.DI_ITEM_RIGHT_BOTTOM
        );

        Statusbar.DrawImage(
            "STSCORES",
            (0, 0),
            Statusbar.DI_SCREEN_CENTER_TOP | Statusbar.DI_ITEM_TOP | Statusbar.DI_ITEM_CENTER
        );

        let scoreStr = string.Format("%04d", game.score);
        
        for (int i = 0; i < int(scoreStr.Length()); i++) {
            Statusbar.DrawImage(
                "NUMBER" .. (scoreStr.ByteAt(i) - 48),
                (-176 + (i * 16), 24),
                Statusbar.DI_SCREEN_CENTER_TOP | Statusbar.DI_ITEM_LEFT_TOP
            );
        }
    }
}	
