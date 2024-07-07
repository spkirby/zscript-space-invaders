class PlayerShipInputHandler : EventHandler {
	override bool InputProcess(InputEvent event) {
		if (
			event.Type != InputEvent.Type_KeyDown &&
			event.Type != InputEvent.Type_KeyUp
		) {
			return false;
		}
		
		int left1, left2 = Bindings.GetKeysForCommand("+moveleft");
		int right1, right2 = Bindings.GetKeysForCommand("+moveright");
		int attack1, attack2 = Bindings.GetKeysForCommand("+attack");
		
		if (event.KeyScan == left1 || event.KeyScan == left2) {
			SendNetworkEvent("PlayerShipMove", event.Type == InputEvent.Type_KeyDown ? -1 : 0);
			return true;
		}
		else if (event.KeyScan == right1 || event.KeyScan == right2) {
			SendNetworkEvent("PlayerShipMove", event.Type == InputEvent.Type_KeyDown ? 1 : 0);
			return true;
		}
		else if (
			event.Type == InputEvent.Type_KeyDown &&
			(event.KeyScan == attack1 || event.KeyScan == attack2)
		) {
			SendNetworkEvent("PlayerShipFire");
			return true;
		}
		
		return false;
	}
	
	override void NetworkProcess(ConsoleEvent event) {
		if (event.Name == "PlayerShipMove") {
			let it = ThinkerIterator.Create("PlayerShip");
			PlayerShip ship;
			
			while (ship = PlayerShip(it.Next())) {
				ship.SetDirection(event.Args[0]);
			}
		}
		else if (event.Name == "PlayerShipFire") {
			let it = ThinkerIterator.Create("PlayerShip");
			PlayerShip ship;
			
			while (ship = PlayerShip(it.Next())) {
				ship.Fire();
			}
		}
	}
}
