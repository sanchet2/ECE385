var getPixels = require("get-pixels"),
  _ = require("underscore"),
  fs = require("fs"),
  util = require("util"),
  async =require("async"),
  sizeOfImg = require('image-size');

var currentSize=314112;
function getwithName(x, callback) {
  getPixels(x, function(err, pixels) {
    if (err) {
      console.log("Bad image path")
      callback("bad img")
      return
    }


    console.log("Started "+x)
    var dimensions = sizeOfImg(x);
    console.log(dimensions.width, dimensions.height);
     currentSize+=dimensions.width*dimensions.height;
     console.log(currentSize);
    var ans = [];
    var check = 3;
    var three = 0;
    var rgb = {};

    for (var i = 0; i < pixels.data.length; i++) {
      if (i == check) {
        check = check + 4
        ans.push(pad(0, 2))
        rgb = {};
      } else {
        ans.push(pad(pixels.data[i].toString(16), 2))
        if (three == 0) {
          rgb["r"] = pixels.data[i]
          three++;
        }
        if (three == 1) {
          rgb["g"] = pixels.data[i];
          three++;
        }
        if (three == 2) {
          rgb["b"] = pixels.data[i];
          three = 0;
        }
      }
    }

    var stringans = "";
    for (var i = 0; i < ans.length; i++) {
      stringans += ans[i];
    }
    console.log((ans.length/2).toString(16))

    var needed = stringans.toUpperCase();

    fs.appendFile('enemies.hex', needed, function(err) {
      if (err)
        return console.log(err);
      console.log('wrote sprite');
      callback()
    });

    function pad(n, width, z) {
      z = z || '0';
      n = n + '';
      return n.length >= width ? n : new Array(width - n.length + 1).join(z) + n;
    }

  })
}




//var files=['rocketship1.png','rocketship2.png']

var files=[];
for(var i=0;i<10;i++){
  files.push("enemies/enemy"+i+".png");
}
async.eachSeries(files,getwithName,function(err){
  if(err){
    console.log("I fucked up");
  }
  else{
    console.log("Done writing files")
  }
})
