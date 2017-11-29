var canvas = document.getElementById("myCanvas");
var ctx = canvas.getContext("2d");

var x = canvas.width / 2;
var y = canvas.height - 30;
var dx = 2;
var dy = -2;
var ballRadius = 10;

var paddleWidth = 50;
var paddleHeight = 10;
var paddleX1 = (canvas.width - paddleHeight) / 2 - 50;
var paddleX2 = (canvas.width - paddleHeight) / 2 + 50;

var left1Pressed = false;
var right1Pressed = false;
var left2Pressed = false;
var right2Pressed = false;

var brickRowCount = 3;
var brickColumnCount = 5;
var brickWidth = 75;
var brickHeight = 20;
var brickPadding = 10;
var brickOffsetTop = 30;
var brickOffsetLeft = 30;

var influencex = .8;

var bricks = [];
for (c = 0; c < brickColumnCount; c++) {
	bricks[c] = [];
	for (r = 0; r < brickRowCount; r++) {
		bricks[c][r] = {x:0, y:0, uthere:true};
	}
}


document.addEventListener("keydown", keyDownHandler, false);
document.addEventListener("keyup", keyUpHandler, false);


function keyDownHandler(e) {
	if (e.keyCode == 68) {
		right1Pressed = true;
	} else if (e.keyCode == 65) {
		left1Pressed = true;
	}
	if (e.keyCode == 39) {
		right2Pressed = true;
	} else if (e.keyCode == 37) {
		left2Pressed = true;
	}
}

function keyUpHandler(e) {
	if (e.keyCode == 68) {
		right1Pressed = false;
	} else if (e.keyCode == 65) {
		left1Pressed = false;
	}
	if (e.keyCode == 39) {
		right2Pressed = false;
	} else if (e.keyCode == 37) {
		left2Pressed = false;
	}
}


function drawball() {
	ctx.beginPath();
	ctx.arc(x,y,ballRadius,0,Math.PI*2);
	ctx.fillStyle = "#000000";
	ctx.fill();
	ctx.closePath();
}

function drawPaddles() {
	ctx.beginPath();
	ctx.rect(paddleX1, canvas.height - paddleHeight, paddleWidth, paddleHeight);
	ctx.fillStyle = "#000000";
	ctx.fill();
	ctx.closePath();

	ctx.beginPath();
	ctx.rect(paddleX2, canvas.height - paddleHeight, paddleWidth, paddleHeight);
	ctx.fillStyle = "#ff0";
	ctx.fill();
	ctx.closePath();
}

function drawBricks() {
	var count = 0;
	for (c = 0; c < brickColumnCount; c++) {
		for (r = 0; r < brickRowCount; r++) {
			var brickX = (c*(brickWidth+brickPadding))+brickOffsetLeft;
			var brickY = (r*(brickHeight+brickPadding))+brickOffsetTop;
			bricks[c][r].x = brickX;
			bricks[c][r].y = brickY;
			ctx.beginPath();
			ctx.rect(brickX,brickY,brickWidth,brickHeight);
			if (bricks[c][r].uthere) {
				ctx.fillStyle = "#000000";
			} else {
				count++;
				ctx.fillStyle = "#eee";
			}
			ctx.fill();
			ctx.closePath();
		}
	}
	if (count == brickRowCount * brickColumnCount) {
		alert("You Win!");
		document.location.reload();
	}
}

function collisionDetection() {
	for (c = 0; c < brickColumnCount; c++) {
		for (r = 0; r < brickRowCount; r++) {
			var b = bricks[c][r];
			var distX = Math.abs(x - b.x - brickWidth/2);
			var distY = Math.abs(y - b.y - brickHeight/2);


		    if (distX > (brickWidth / 2 + ballRadius)) {
		        continue;
		    }
		    if (distY > (brickHeight / 2 + ballRadius)) {
		        continue;
		    }

			if (distX <= (brickWidth/2) && b.uthere) {
				b.uthere = false;

				dy = -dy;
				return;
			}
			if (distY <= (brickHeight/2) && b.uthere) {
				b.uthere = false;
				dx = -dx;
				return;
			}
			//rect corners
			var deltaX = distX - brickWidth/2;
			var deltaY = distY - brickHeight/2;
			if ((deltaX*deltaX + deltaY*deltaY) <= (ballRadius * ballRadius) && b.uthere) {
				b.uthere = false;
				dx = -dx;
				dy = -dy;


				return;
			}
		}
	}
}

function draw() {
	ctx.clearRect(0,0,canvas.width,canvas.height);

	drawPaddles();
	drawBricks();
	collisionDetection();
	drawball();
	if (left1Pressed && paddleX1 > 0) {
		paddleX1 -= 5;
	} else if (right1Pressed && paddleX1 < canvas.width  - paddleWidth && paddleX1 < paddleX2 - paddleWidth) {
		paddleX1 += 5;
	}
	if (left2Pressed && paddleX2 > 0 && paddleX2 > paddleX1 + paddleWidth) {
		paddleX2 -= 5;
	} else if (right2Pressed && paddleX2 < canvas.width  - paddleWidth) {
		paddleX2 += 5;
	}



	if (y + dy < ballRadius) {
		dy = -dy;
	} else if (y + dy > canvas.height - ballRadius) {
		if ((x > paddleX1 - 5 && x < paddleX1 + paddleWidth + 5)) {
			var speedxy = Math.sqrt(dx*dx + dy*dy);
			var posx = (x - paddleX1) - (paddleWidth / 2);
			console.log(speedxy);
			dx = speedxy * influencex * (posx > 0? 1 : -1);
			dy = -dy;
			// dy = Math.sqrt(speedxy*speedxy - dx*dx) * (dy > 0? -1 : 1);
		} else if ((x > paddleX2 - 5 && x < paddleX2 + paddleWidth + 5)) {
			var speedxy = Math.sqrt(dx*dx + dy*dy);
			var posx = (x - paddleX2) - (paddleWidth / 2);
			console.log(speedxy);
			dx = speedxy * influencex * (posx > 0? 1 : -1);;
			dy = -dy;
			// dy = Math.sqrt(speedxy*speedxy - dx*dx) * (dy > 0? -1 : 1);
		} else {
			alert("You Lose!");
			document.location.reload();

		}
	}
	if (x + dx < ballRadius || x + dx > canvas.width - ballRadius) {
		dx = -dx;
	}
	x += dx;
	y += dy;

}




setInterval(draw, 10);