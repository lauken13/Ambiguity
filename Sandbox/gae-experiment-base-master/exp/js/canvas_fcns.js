/*global $, document, htmlElements, experimentInfo:true */

function drawLine(colour1, colour2, width, height) {
  /*
  * drawLine draws a line in the html canvas
  * it assumes the canvas is already initialized
  * this function does not return any value when finished
  * 
  * degrees: the angle of the line
  * colour: the color of the line
  * width: the width of the canvas to draw on
  * height: the height of hte canvas to draw on
  */
  shuffle(colour1);
  shuffle(colour2);
  // the length of the line
  var length = 200;
  var colour = [colour1,colour2];
  var boxWidth = width/9*4-width/9*4/40*3;
  var boxHeight = height/2;
  // set line colour
  
    for (k=0; k<2; k++){
	   experimentInfo.context.fillStyle = " #773d22";
	   experimentInfo.context.strokeStyle="black";
	   experimentInfo.context.stroke();
	   experimentInfo.context.fillRect(k*1.25*boxWidth,boxHeight/2+boxHeight/8-boxWidth/40,boxWidth+boxWidth/40*2,boxHeight/2+boxWidth/40*2);
	}
  
	for (k=0; k<2; k++){
	  for (j=0; j < 2; j++){
		  for (i = 0; i < 4; i++) {
			    experimentInfo.context.rect(k*1.25*boxWidth+i*boxWidth/4+boxWidth/40,boxHeight/2+boxHeight/8+j*boxHeight/4,boxWidth/4,boxHeight/4);
				experimentInfo.context.fillStyle = "#9f512d";
				experimentInfo.context.fill();
				experimentInfo.context.strokeStyle=" #773d22";
				experimentInfo.context.stroke();
		  }
	  }
	}
	
	for (k=0; k<2; k++){
	  for (j=0; j < 2; j++){
		  for (i = 0; i < 4; i++) {
			drawStar(k*1.25*boxWidth+boxWidth/8+i*boxWidth/4+boxWidth/40, boxHeight/2+ boxHeight/4 +j*boxHeight/4,20,boxHeight/9, boxWidth/9.5);
		  }
	  }
	}	  
			  
	for (k=0; k<2; k++){
	  for (j=0; j < 2; j++){
		  for (i = 0; i < 4; i++) {
				experimentInfo.context.beginPath();
				experimentInfo.context.arc(k*1.25*boxWidth+boxWidth/8+i*boxWidth/4+boxWidth/40, boxHeight/2+ boxHeight/4 +j*boxHeight/4, boxWidth/11, 0, 2 * Math.PI, false);
				experimentInfo.context.fillStyle = colour[k][(j*4)+i];
				experimentInfo.context.fill();
				experimentInfo.context.strokeStyle="black";
				experimentInfo.context.stroke();
		  }
	  }
	}
  
  // draw circle
}
function drawEx(colour1, width, height) {
 // the length of the line
  var length = 200;
  var colour = colour1;
  var boxWidth = width-2*width/40;
  var boxHeight = width/2-2*width/40;
  // set line colour
  
	   experimentInfo.context.fillStyle = " #773d22";
	   experimentInfo.context.strokeStyle="black";
	   experimentInfo.context.stroke();
	   experimentInfo.context.fillRect(0,(height-boxHeight)/2,width,width/2);
  
	  for (j=0; j < 2; j++){
		  for (i = 0; i < 4; i++) {
			    experimentInfo.context.rect(i*boxWidth/4+boxWidth/40,(height-boxHeight)/2+boxWidth/40+j*boxHeight/2,boxWidth/4,boxHeight/2);
				experimentInfo.context.fillStyle = "#9f512d";
				experimentInfo.context.fill();
				experimentInfo.context.strokeStyle=" #773d22";
				experimentInfo.context.stroke();
		  }
	  }
	
	  for (j=0; j < 2; j++){
		  for (i = 0; i < 4; i++) {
			drawStar(boxWidth/8+i*boxWidth/4+boxWidth/40, boxHeight/4 +(height-boxHeight)/2+boxWidth/40+j*boxHeight/2,20,boxWidth/8, boxWidth/10);
		  }
	  }	  
			  
	  for (j=0; j < 2; j++){
		  for (i = 0; i < 4; i++) {
				experimentInfo.context.beginPath();
				experimentInfo.context.arc(boxWidth/8+i*boxWidth/4+boxWidth/40, boxHeight/4 +(height-boxHeight)/2+boxWidth/40+j*boxHeight/2, boxWidth/11, 0, 2 * Math.PI, false);
				experimentInfo.context.fillStyle = colour[(j*4)+i];
				experimentInfo.context.fill();
				experimentInfo.context.strokeStyle="black";
				experimentInfo.context.stroke();
		  }
	  }
  
  // draw circle
}
function drawStar(cx, cy, spikes, outerRadius, innerRadius) {
    var rot = Math.PI / 2 * 3;
    var x = cx;
    var y = cy;
    var step = Math.PI / spikes;

    experimentInfo.context.beginPath();
    experimentInfo.context.moveTo(cx, cy - outerRadius)
    for (p = 0; p < spikes; p++) {
        x = cx + Math.cos(rot) * outerRadius;
        y = cy + Math.sin(rot) * outerRadius;
        experimentInfo.context.lineTo(x, y)
        rot += step

        x = cx + Math.cos(rot) * innerRadius;
        y = cy + Math.sin(rot) * innerRadius;
        experimentInfo.context.lineTo(x, y)
        rot += step
    }
    experimentInfo.context.lineTo(cx, cy - outerRadius)
    experimentInfo.context.closePath();
    experimentInfo.context.strokeStyle='#ffbf80';
    experimentInfo.context.stroke();
    experimentInfo.context.fillStyle='#4d2600';
    experimentInfo.context.fill();

}


function drawSquare(width, height) {
  /*
  * drawLine draws a line in the html canvas
  * it assumes the canvas is already initialized
  * this function does not return any value when finished
  * 
  * degrees: the angle of the line
  * colour: the color of the line
  * width: the width of the canvas to draw on
  * height: the height of hte canvas to draw on
  */

  // the length of the line

				experimentInfo.context.rect(0,(width-height)/2,height,height,height);
				experimentInfo.context.fillStyle = "blue";
                experimentInfo.context.fill();
				experimentInfo.context.stroke();

  
  // draw circle
}

function initializeCanvas() {
  /*
  * initialize the canvas and context variables
  */
  
  // define the canvas and context objects in experimentInfo from the contents of the html canvas element
  experimentInfo.canvas = document.getElementById("drawing");
  experimentInfo.canvas.width = htmlElements.divImageSpace.width();
  experimentInfo.canvas.height = htmlElements.divImageSpace.height();
  experimentInfo.context = experimentInfo.canvas.getContext("2d");
}

function imageClear() {
  /*
  * clear the html canvas
  */

  experimentInfo.context.fillStyle = '#ffffff'; // work around for Chrome
  experimentInfo.context.fillRect(0, 0, experimentInfo.canvas.width, experimentInfo.canvas.height); // fill in the canvas with white
  experimentInfo.canvas.width = experimentInfo.canvas.width; // clears the canvas 
}


function hideCanvas() {
  /*
  * clear the canvas and then hide it
  */

  // clear the canvas
  imageClear();

  // hides the canvas drawing
  htmlElements.divImageSpace.hide();
}

