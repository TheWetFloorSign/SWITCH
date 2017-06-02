define(['Class','ImageLoader','SpriteSheet'],function(Class,ImageLoader,SpriteSheet){
	var assets = {};
	var Assets = Class.extend({
		init:function(_name,_path){
			var body = document.body;
			canvas = document.createElement("CANVAS");
			canvas.setAttribute("id", "canvas2");
			//body.appendChild(canvas);
			var graphics = canvas.getContext("2d");
			
			assets[_name] = this;
			this.name = _name;
			this.path = _path;
			var image = new Image();
			image.src = _path;
			this.sheet = image;
			
			image.onload = function()
			{
				console.log(image)
			canvas.width = image.width * 2;
			canvas.height = image.height;
			graphics.save();
			graphics.drawImage(image,0,0);
			graphics.scale(-1,1);
			graphics.drawImage(image,-image.width * 2,0);
			graphics.scale(-1,1);
			var image2 = new Image();
			
			/*image2.src = canvas.toDataURL("image/png");
			assets[_name].sheet = image2;*/
			//canvas.remove();
			}
		}
	});
	
	Assets.getAssets = function(_name){
		return assets[_name];
	}
	return Assets;
});