/*global $, console, hideElements, drawLine, selectNextTrial, htmlElements, experimentInfo */

function testTrial() {
  /* 
  * display a test trial in which a black line is shown on the screen
  * and subjects are asked to respond to it
  *
  * which stimuli to display from testTrialStimuli is determined
  * by the current block (currentBlock) and current trial number (currTrial)
  *
  * in the first test block, participants respond by pressing one of two buttons
  * in the second test block, they respond by moving a slider to indicate belief
  *
  * all of the information to save to the database needs to be added to exp_data.
  * 
  * exp_data is a javascript dictionary, which consists of [key, value] pairs
  * To add a new pair to exp_data, do:
  * exp_data.KEY = VALUE;
  * you can see examples of how this is done below
  *
  * after subjects have selected their response, the function saveTestTrial is called
  */

  // the angle of the line to draw (in degrees) for testing
  var testTrialStimuliB1 = ["red","red","red","red","blue","blue","blue","blue"];
  shuffle(testTrialStimuliB1);
  var testStimuli= [["red","red","red","red","blue","blue","blue","blue"], //None Hidden
				["red","red","red","red","#d9d9d9","blue","blue","blue"], //One blue hidden
				["red","red","red","#d9d9d9","#d9d9d9","blue","blue","blue"],
				["red","red","#d9d9d9","#d9d9d9","#d9d9d9","blue","blue","blue"],
				["red","#d9d9d9","#d9d9d9","#d9d9d9","#d9d9d9","blue","blue","blue"],
				["#d9d9d9","#d9d9d9","#d9d9d9","#d9d9d9","#d9d9d9","blue","blue","blue"],
				["red","red","red","red","#d9d9d9","#d9d9d9","blue","blue"],  //Two blue hidden
				["red","red","red","#d9d9d9","#d9d9d9","#d9d9d9","blue","blue"],
				["red","red","#d9d9d9","#d9d9d9","#d9d9d9","#d9d9d9","blue","blue"],
				["red","#d9d9d9","#d9d9d9","#d9d9d9","#d9d9d9","#d9d9d9","blue","blue"],
				["#d9d9d9","#d9d9d9","#d9d9d9","#d9d9d9","#d9d9d9","#d9d9d9","blue","blue"],
				["red","red","red","red","#d9d9d9","#d9d9d9","#d9d9d9","blue"], //Three blue hidden
				["red","red","red","#d9d9d9","#d9d9d9","#d9d9d9","#d9d9d9","blue"],
				["red","red","#d9d9d9","#d9d9d9","#d9d9d9","#d9d9d9","#d9d9d9","blue"],
				["red","#d9d9d9","#d9d9d9","#d9d9d9","#d9d9d9","#d9d9d9","#d9d9d9","blue"],
				["#d9d9d9","#d9d9d9","#d9d9d9","#d9d9d9","#d9d9d9","#d9d9d9","#d9d9d9","blue"],
				["red","red","red","red","#d9d9d9","#d9d9d9","#d9d9d9","#d9d9d9"], //Four blue hidden
				["red","red","red","#d9d9d9","#d9d9d9","#d9d9d9","#d9d9d9","#d9d9d9"],
				["red","red","#d9d9d9","#d9d9d9","#d9d9d9","#d9d9d9","#d9d9d9","#d9d9d9"],
				["red","#d9d9d9","#d9d9d9","#d9d9d9","#d9d9d9","#d9d9d9","#d9d9d9","#d9d9d9"],
				["#d9d9d9","#d9d9d9","#d9d9d9","#d9d9d9","#d9d9d9","#d9d9d9","#d9d9d9","#d9d9d9"], //All hidden 
				["red","red","red","#d9d9d9","blue","blue","blue","blue"], //No blue hidden
				["red","red","#d9d9d9","#d9d9d9","blue","blue","blue","blue"],
				["red","#d9d9d9","#d9d9d9","#d9d9d9","blue","blue","blue","blue"],
				["#d9d9d9","#d9d9d9","#d9d9d9","#d9d9d9","blue","blue","blue","blue"]];
				
  // remove all elements from the screen
  // reset all buttons so they do not have any functions bound to them
  hideElements();
  // draw test stimuli
  shuffle(testStimuli[1]);
  var tmp = getRandomInt(0,1);
  console.log(tmp);
  
  if (tmp==0){
   drawLine(testTrialStimuliB1,testStimuli[experimentInfo.condition1], htmlElements.divImageSpace.width(), htmlElements.divImageSpace.height());  
  }else {
   drawLine(testStimuli[experimentInfo.condition1],testTrialStimuliB1, htmlElements.divImageSpace.width(), htmlElements.divImageSpace.height());
  }
  htmlElements.divImageSpace.show();

  // increment test trial counter
  experimentInfo.currTrial++;
  
  // get time of beginning of trial
  var base_time = new Date().getTime();
  
  // all of the data from this trial will go into this object
  var exp_data = {};
  exp_data.side=tmp;
  exp_data.seenUnambig=testTrialStimuliB1;
  exp_data.seenAmbig=testStimuli[experimentInfo.condition1];
  exp_data.socialCond=experimentInfo.socialCondition;
  // add demographics data to trial output
  for (var i = 0; i < experimentInfo.demographics.length; i++) {
    exp_data[experimentInfo.demographics[i].name] = experimentInfo.demographics[i].value;
  }

  // fix type of age if it exists (from demographics)
  if ("age" in exp_data)
    exp_data.age = parseInt(exp_data.age, 10);

  // add trial data to trial output
  exp_data.subjectID      = experimentInfo.subjectID;
  exp_data.testTrial      = experimentInfo.currTrial;
  exp_data.block          = experimentInfo.currBlock;
  exp_data.condition      = experimentInfo.condition1;
  exp_data.experiment     = "test_experiment_v1";
  exp_data.completionCode = experimentInfo.completionCode;

  if (experimentInfo.currBlock < 1) {
    // show a trial in which subjects respond by pressing one of two buttons

    // display test trial instructions
    htmlElements.divInstructions.html("These are the two boxes of chocolates you can have us select chocolates from. You want to maximise your chances of us picking a BLUE chocolate. Remember that <b> one of our " + experimentInfo.condInstruct +'</b> <br> Which box of chocolates would you like us to choose from?');
    htmlElements.divInstructions.show();
    
    // set the type of this trial
    exp_data.responseType = "categorize";
    if(experimentInfo.BallsInView=="All"){
		 exp_data.EstBlue='NA';
	    exp_data.EstRed='NA';
	    exp_data.OtherColors='NA';
	    exp_data.EstOther='NA';
     //save trial data
		htmlElements.buttonA.click(function () {saveTestTrial(exp_data, 0, base_time); testFeedback(exp_data);});
		htmlElements.buttonB.click(function () {saveTestTrial(exp_data, 1, base_time); testFeedback(exp_data);});
	} else{
		htmlElements.buttonA.click(function () {showExitQuestions(exp_data, 0, base_time);});
		htmlElements.buttonB.click(function () {showExitQuestions(exp_data, 1, base_time);});	
	}
    // show response buttons
    htmlElements.buttonA.show();
    htmlElements.buttonB.show();
  }
  else {
    // show a trial in which subjects respond by moving a slider
    htmlElements.divInstructions.html('What is the probability this line is green?');
    htmlElements.divInstructions.show();
    
    // set the type of this trial
    exp_data.responseType = "slider";

    // determine what to do when the next button is clicked
    htmlElements.buttonNext.click(function () {saveTestTrial(exp_data, htmlElements.divSlider.slider('value'), base_time);});

    // setup the slider
    htmlElements.divSlider.slider('value', experimentInfo.default_slider_value);
    htmlElements.divSliderInfo.html(htmlElements.divSlider.slider('value') + "%"); // update slider value

    // show the slider and the next button
    htmlElements.divSliderStuff.show();
    htmlElements.buttonNext.show();
  }
}

function testFeedback(exp_data) {
  /* 
  * display a training trial in which a colored line is shown on the screen
  * and subjects are asked to press next when done studying it
  *
  * which stimuli to display from trainingTrialStimuli is determined
  * by the current block (currentBlock) and current trial number (currTrial)
  *
  * after each Next click, checks if the correct number of training trials have been shown
  * if so, proceed to test trials
  * otherwise, show another training trial
  */

  // the angle of the line to draw (in degrees) for testing
  hideElements();
  // display training trial instructions
  htmlElements.divInstructions.html('We randomly selected a chocolate from the box you chose and it was blue! Congratulations you won at this game! You get 100 extra points!');
  htmlElements.divInstructions.show();
  drawSquare(htmlElements.divImageSpace.width(), htmlElements.divImageSpace.height());
  // draw training stimuli in canvas
  htmlElements.divImageSpace.show();
  htmlElements.buttonNext.show();
    htmlElements.buttonNext.click(function() {finishExperiment(exp_data);}); // Finish Experiment
}

function saveTestTrial(exp_data, response, base_time) {
  /*
  * saveTestTrial should be passed an object (exp_data) containing all of the
  * data from the current trial to save to the database
  * 
  * when exp_data is completely built, it is passed as a paramter to saveData
  * which actually writes the information to the database on Google App Engine
  * 
  * after writing the data, this function calls selectNextTrial to determine
  * what the next type of trial should be
  *
  * to see how to retrieve all data, please look at the documentation in README.md
  */
  
  // record the response time and include it in the object to write to file

  // add the subject's response to the data object
  exp_data.response = response; 
 if (exp_data.response==0 & exp_data.side==0){
	 exp_data.ambiguous = 'N';
 }else if (exp_data.response==0 & exp_data.side==1){
	 exp_data.ambiguous = 'Y';
 }else if (exp_data.response==1 & exp_data.side==0){
	 exp_data.ambiguous = 'Y';
 } else if (exp_data.response==1 & exp_data.side==1){
	 exp_data.ambiguous = 'N';
 }
  // print the data to console for debugging
  // determine what type of trial to run next
}


function saveData(data) {
  /*
  * write a new row to the database
  *
  * data: a dictionary composed of key, value pairs
  *       containing all the info to write to the database
  *
  * an anonymous function is used because it creates a
  * copy of all information in the data variable, 
  * thus if any other functions change the data object after this function executes
  * then the information written to the database does not change
  */

  (function (d) {
    $.post('submit',  {"content": JSON.stringify(d)});
  })(data);
}

function shuffle(array) {
    for (var i = array.length - 1; i > 0; i--) {
        var j = Math.floor(Math.random() * (i + 1));
        var temp = array[i];
        array[i] = array[j];
        array[j] = temp;
    }
    return array;
}
/**
 * Returns a random integer between min (inclusive) and max (inclusive)
 * Using Math.round() will give you a non-uniform distribution!
 */
function getRandomInt(min, max) {
    return Math.floor(Math.random() * (max - min + 1)) + min;
}