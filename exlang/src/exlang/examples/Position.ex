class Position {
	double x = 0;
	double y;

	__init__() {
		this.x = 0;
		this.y = 0;
	}

	__init__(double x, double y) {
		this.x = x;
		this.y = y;
	}

	double getX() = x;

	double getY() = y;

	moveTo!(double newX, double newY) {
		x = newX;
		y = newY;
	}

	moveTo!(Position newPos) {
		x = newPos.getX();
		y = newPos.getY();
	}

	move!(double deltaX, double deltaY) {
		x.add!(deltaX);
		y.add!(deltaY);
	}

	move!(Position deltaPos) {
		x.add!(deltaPos.x);
		y.add!(deltaPos.y);
	}

	move!(Direction dir, double distance) {
		move!(dir.getMovement(distance));
	}

	Position copy() = Position(x, y);

	double distanceTo(Position otherPos) =
		Math.sqrt(Math.pow(x.minus(otherPos.x), 2).plus(Math.pow(y.minus(otherPos.y), 2)));

	Direction directionTo(Position otherPos) =
		Direction(otherPos.x.minus(x), otherPos.y.minus(y));
	
	property moveProperty(double deltaX, double deltaY) {
		assert move(deltaX, deltaY).getX() == getX().plus(deltaX);
		assert move(deltaX, deltaY).getY() == getY().plus(deltaY);
	}
	
	property moveDistanceProperty(Direction dir, double distance) {
		assert distanceTo(move(dir, distance)) == distance;
	}
}
