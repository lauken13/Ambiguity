/*global $, console, initializeCanvas, initializeSlider, hideElements, showInputOptions, showIntro, trainTrial, testTrial, hideCanvas, hideSlider */


// set this to false if you want the user to determine which condition to start in
// set this to true if you want to randomize the condition
var randomizeConditions = true;

// all experiment details will go into this object
var experimentInfo = {};

// all html elements that must be manipulated will go into this object
var htmlElements = {};

function start () {
  /* 
  * start is the first function called (from init_exp.js) when all the files are loaded
  * this function initializes many things, such as:
  * a bunch of javascript objects, the canvas we will draw on, the slider, and the subject id
  *
  * if radomizeConditions is set to false the user can select which condition they will see
  * and which segment of the experiment they will start in
  * otherwise the condition is randomized and 
  * this function finishes by calling showIntro to begin the experiment
  */
  
  // this function builds a unique completion code for this particpant
  function makecode() {
    var text = "";
    var possible = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";

    for( var i=0; i < 5; i++ )
        text += possible.charAt(Math.floor(Math.random() * possible.length));

    text += "#-";

    for( var j=0; j < 5; j++ )
        text += possible.charAt(Math.floor(Math.random() * possible.length));

    return text;
  }
  
  
  // variables that will store the current trial number and current block number
  experimentInfo.currTrial = 0;
  experimentInfo.currBlock = 0;

  // how many test trials to do per block
  experimentInfo.maxTestTrial = 1;

  // initialize references to elements in html
  initDivReferences();
  
  // initialize html canvas object
  initializeCanvas();

  // generate a subject ID by generating a random number between 1 and 1000000
  experimentInfo.subjectID = Math.round(Math.random() * 1000000);
  
  experimentInfo.completionCode = makecode();

  // if you set this to true, it allow user to select conditions and where to start
  if (!randomizeConditions) {
    showInputOptions();
  } else {
    // randomize experimental conditions
    initializeCondition();
    showIntro();
  }
}

function initDivReferences () {
  /* 
  * initDivReferences makes a number of jQuery requests to get html elements
  * the results are stored in javascript variables to make accessing them much faster
  * it does not return any value when finished
  *
  * you might want to add new js variables here if you add new html elements
  * to your index.html file. Be sure you declare new ones as is done above for these variables
  */
  
  htmlElements.divImageSpace = $('#imageSpace');
  htmlElements.divInstructions = $('#instructions');

  htmlElements.buttonA = $('#a');
  htmlElements.buttonB = $('#b');
  htmlElements.buttonNext = $('#next');

}

function initializeCondition () {
  /* 
  * initializeCondition randomly determines which condition to run the current user
  * it does not return any value when finished
  *
  * if you have more than 2 conditions, you might want to add more functionality here
  */
  var  potentialConditions = [8,10,14,18,20];
  var BallsInView= ["2Blue_2Red","Two_Blue","1Red_1Blue","Two_Red","None"];
  var noBallsHidden=["four","six","six","six","eight"];
  // randomly assign condition
  var r = Math.floor(Math.random() * 5); // generate random number
 console.log(r);
   experimentInfo.condition1 = potentialConditions[r];
   experimentInfo.BallsInView = BallsInView[r];
   experimentInfo.NumberHidden=noBallsHidden[r];
console.log(experimentInfo.BallsInView); 
 var s = Math.ceil(Math.random() * 3); // generate random number
  if (s === 1) {
    experimentInfo.socialCondition = 'neutral';
  } else if (s === 2) {
    experimentInfo.socialCondition = 'malic';
  } else if (s === 3) {
    experimentInfo.socialCondition = 'helpful';
  }   
	console.log(experimentInfo.socialCondition);
	if (experimentInfo.socialCondition=='neutral'){
		experimentInfo.condInstruct="employees enjoys rearranging the order of the chocolates in the boxes, though he doesn't change which ones go where and he didn't get to all of them.";
	} else 	if (experimentInfo.socialCondition=='malic'){
		experimentInfo.condInstruct="employees who thinks the company is losing money on this promotion randomly puts more red chocolates in some of the boxes, though he didn't get to all of them.";
	} else 	if (experimentInfo.socialCondition=='helpful'){
		experimentInfo.condInstruct="employees wants to increase the odds that people will get prize money so he randomly puts more blue chocolates in some of the boxes, though he didn't get to all of them.";
	}
}

function initializeTask () {
  /* 
  * initializeTask does all the configuration before beginning training and testing
  * when done, start training by calling trainTrial
  */
  
  // initialize the slider
  // change text value of response buttons depending on colour condition
  htmlElements.buttonB.prop('value', 'Right Box');
  htmlElements.buttonA.prop('value', 'Left Box');
  
  // start the training
  testTrial();
}

function selectNextTrial () {
  /*
  * selectNextTrial determines based on the currTrial and currBlock variables
  * what the next type of trial should be or if the experiment is done
  * 
  * the appropriate function is called next
  */
  
  // how many blocks to do total
  var maxBlock = 1;

  // determine which section to go to next
  if(experimentInfo.currTrial < experimentInfo.maxTestTrial) {
    testTrial(); // next test trial
  }
  else {
    // increment block 
    experimentInfo.currBlock++;

    if(experimentInfo.BallsInView !=='All') {
      showExitQuestions(); // next training block
    }
    else {
      testFeedback(); // end of experiment
    }
  }
}

function finishExperiment(exp_data) {
  /* 
  * finishExperiment is called when all trials are complete and subjects are done
  * removes everything from the screen and thanks the subject
  */
  
  // remove all elements from the screen
  // reset all buttons so they do not have any functions bound to them
  hideElements();
  saveData(exp_data);
  htmlElements.divInstructions.html('You have completed the experiment! If you are doing the experiment from Mechanical Turk, please enter the code ' + experimentInfo.completionCode + ' to complete the HIT.');
  htmlElements.divInstructions.show();
}

function hideElements() {
  /*
  * hide all buttons, slider, and text
  * clear the canvas and hide it
  */
  
  hideButtons();
  hideCanvas();
  hideText();
}

function hideText() {
  /*
  * hide all text elements
  */

  $('.text').hide();
}

function hideButtons() {
  /*
  * hide all button elements
  * unbind them so any functions previously attached to them are no longer attached
  */

  // hides all buttons
  $(':button').hide();

  // unbinds all buttons
  $(':button').unbind();
}
