define(['Class','Camera','Assets','KeyManager','Player','Background'],function(Class,Camera,Assets,KeyManager,Player,Background){
	var _this;
	
	var title,width,height,g,camera,running,scale,keyManager;
	keyManager = new KeyManager();
	
	var Game = Class.extend({
		init:function(_title,_width,_height,_scale){
			_this = this;
			title = _title;
			if(_scale == undefined)_scale = 1;
			var running = false;
			var ast = new Assets("test","images/BeatEmUpSprites20160327.png");
			var ast = new Assets("bg","images/Background.png");
			this.testOb = new Player();
			this.testOb.keyManager = keyManager;
			
			this.bg = new Background();
			
			this.testOb.x = this.testOb.y = 100;
			document.title = title;
			width = _width/_scale;
			height = _height/_scale;
			scale = _scale;
			
			keyManager.addActionBinding("left",65);
			keyManager.addActionBinding("right",68);
			keyManager.addActionBinding("up",87);
			keyManager.addActionBinding("up",32);
			keyManager.addActionBinding("down",83);
			/*var audio = new Audio('audio/Yes - Roundabout.mp3');
			audio.volume = .2;
			audio.mozPreservesPitch = false;
			audio.playbackRate = 0.5;
			audio.play();*/
		}
	});
	
	Game.prototype.build = function(){
		console.log(width);
		camera = new Camera(width,height,scale);
		camera.addDraw(this.testOb.getComponent("GraphicsComponent"));
		camera.addDraw(this.bg.getComponent("GraphicsComponent"));
		camera.follow(this.testOb);
	}
	
	Game.prototype.tick = function(_dt){
		keyManager.tick();	
		this.testOb.updateMe(_dt);
	}
	
	function render(){
		camera.update();
	}
	
	Game.prototype.run = function(){
		this.build();
		var self = this;
		var fps =60;
		var timePerTick = 1000/fps;
		var delta = 0;
		var now;
		var last = Date.now();
		var timer = 0;
		var ticks = 0;
		function loop(){
			if(running){
				now = Date.now();
				delta = now -last;
				timer += delta;
				last = now;
			}
			if(timer >= timePerTick){
				dt = timer/1000;
				self.tick(dt);
				render();
				timer = 0;
			}
			window.requestAnimationFrame(loop);
		}
		loop();
	}
	
	Game.prototype.start = function(){
		if(running)return;
		running = true;
		this.run();
	}
	
	Game.prototype.getWidth = function(){
		return width;
	}
	
	Game.prototype.getHeight = function(){
		return height;
	}
	return Game;
});