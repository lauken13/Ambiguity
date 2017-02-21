///*global $, alert, hideElements, htmlElements, trainTrial, experimentInfo:true, showDemographics, initializeTask */
/*jshint multistr: true */

function showIntro() {
  // remove all elements from the screen
  // reset all buttons so they do not have any functions bound to them
  hideElements();
  
  htmlElements.divInstructions.show();
  htmlElements.divInstructions.html('<p>This is part of a study being run at the University of Adelaide. By clicking "Next" below you consent to take part in it.</p><p>Details of the study: The principal investigator is Associate Professor Amy Perfors (amy.perfors@adelaide.edu.au). For any questions regarding the ethics of the study, please contact Professor Paul Delfabbro (paul.delfabbro@adelaide.edu.au). Please direct any questions about this study to Lauren Kennedy  (lauren.kennedy@adelaide.edu.au). Although any data gained from this study may be published, you will not be identified and your personal details will not be divulged, nor will anything be linked to your Amazon ID. We use your Amazon ID merely to ensure you successfully completed the experiment and are paid. You may withdraw at any time, although you will not be paid unless you complete the study.</p>');

  htmlElements.buttonNext.show();
  htmlElements.buttonNext.click(showDemographics);
}

function showInstructions() {
  // remove all elements from the screen
  // reset all buttons so they do not have any functions bound to them
  hideElements();

  htmlElements.divInstructions.html('<p>Welcome to our chocolate factory! We produce boxes of chocolates just like the one shown below:</p>');
  htmlElements.divInstructions.show();
  var testTrialStimuliB1 = ["red","red","red","red","blue","blue","blue","blue"];
  shuffle(testTrialStimuliB1);
  drawEx(testTrialStimuliB1, htmlElements.divImageSpace.width(), htmlElements.divImageSpace.height());
  
  htmlElements.divImageSpace.show();
  htmlElements.buttonNext.show();
  htmlElements.buttonNext.click(showInstructions2);
}

function showInstructions2() {
  // remove all elements from the screen
  // reset all buttons so they do not have any functions bound to them
  hideElements();

 htmlElements.divInstructions.html('<p>We are currently running a promotion. We will show you two different chocolate boxes. <br> You will get to pick one of the two boxes. </p>');
  htmlElements.divInstructions.show(); 
  
  var testTrialStimuliB1 = ["red","red","red","red","blue","blue","blue","blue"];
  var testTrialStimuliB2 = ["red","red","red","red","blue","blue","blue","blue"];
  var exA = shuffle(testTrialStimuliB1); 
  experimentInfo.tmpEx = exA
  var exB = shuffle(testTrialStimuliB2);
  drawLine(exA,exB, htmlElements.divImageSpace.width(), htmlElements.divImageSpace.height());
  htmlElements.divImageSpace.show();
  htmlElements.buttonNext.show();
  htmlElements.buttonNext.click(showInstructions3);
}


function showInstructions3() {
  // remove all elements from the screen
  // reset all buttons so they do not have any functions bound to them
  hideElements();

  htmlElements.divInstructions.html('<p>From the box you pick, we will randomly pick a single chocolate. <br> If it is blue, you win 100 points! If it is red, you do not win anything, but also do not lose anything. <br> Your job is tell us which box of chocolates you would like us to pick from. Our job is to <b> randomly </b> pick the chocolate from the box you chose.</p>');
  htmlElements.divInstructions.show();
  drawEx(experimentInfo.tmpEx , htmlElements.divImageSpace.width(), htmlElements.divImageSpace.height());
  htmlElements.divImageSpace.show();
  htmlElements.buttonNext.show();
  htmlElements.buttonNext.click(showInstructions4);
}

// displays experiment instructions
function showInstructions4() {
  // remove all elements from the screen
  // reset all buttons so they do not have any functions bound to them
  hideElements();
  htmlElements.divInstructions.html('<p> However, <b>one of our '+ experimentInfo.condInstruct +' </b> </p>');
  htmlElements.divInstructions.show();
  htmlElements.buttonNext.show();
  htmlElements.buttonNext.click(showInstructions5);
}


// displays experiment instructions
function showInstructions5() {
  // remove all elements from the screen
  // reset all buttons so they do not have any functions bound to them
  hideElements();
  htmlElements.divInstructions.html('<p>After our employee did this, one of the wrapping machines malfunctioned. Some of the chocolates are randomly being rewrapped in blank wrappers, so the true colour doesn\'t show. <b> Regardless, the wrapper underneath is still coloured so we will be able to detect whether you win or not.</b> <br> When you are ready to begin, please press the \'next\' button. </p>');
  htmlElements.divInstructions.show();
  drawEx(shuffle(["red","red","#d9d9d9","#d9d9d9","#d9d9d9","#d9d9d9","blue","blue"]), htmlElements.divImageSpace.width(), htmlElements.divImageSpace.height());
  htmlElements.divImageSpace.show();
  htmlElements.buttonNext.show();
  htmlElements.buttonNext.click(showInstructionChecks);
}

function showInstructionChecks() {
  // remove all elements from the screen
  // reset all buttons so they do not have any functions bound to them
  hideElements();

  htmlElements.divInstructions.show();
  htmlElements.divInstructions.html('<p>Here are some questions to check if you have read the instructions correctly. If you answer all the questions correctly you will begin the experiment, otherwise you will be redirected to the instructions page again.</p>');

  var divInstructionChecks = $('#instruction-checks');
  divInstructionChecks.html('<form> \
                              <label for="question1">What is the task?</label><br /> \
                              <input type="radio" name="question1" value="correct" /> To select which chocolate box you want us to grab a chocolate from <br /> \
                              <input type="radio" name="question1" value="incorrect" /> To select a single chocolate out of some chocolate boxes<br /> \
                              <input type="radio" name="question1" value="incorrect" /> To select all of the chocolates in the backwards wrappers<br /><br /> \
                              <label for="question2">What kind of chocolate will give you the most points?</label><br /> \
                              <input type="radio" name="question2" value="incorrect" /> One in a red wrapper<br /> \
                              <input type="radio" name="question2" value="correct" /> One in a blue wrapper<br /> \
                              <input type="radio" name="question2" value="incorrect" /> One in an wrapper that is on backwards<br /><br /> \
                              <label for="question3">What did the employee do?</label><br /> \
                              <input type="radio" name="question3" value="helpful" /> Put more blue chocolates in some of the boxes <br /> \
							  <input type="radio" name="question3" value="malic" /> Put more red chocolates in some of the boxes<br /> \
                              <input type="radio" name="question3" value="neutral" /> Rearranged the chocolates in each box <br /> \
							  </form><br /><br />');
  divInstructionChecks.show();

  htmlElements.buttonNext.show();
  htmlElements.buttonNext.click(validateInstructionChecks);
}

function validateInstructionChecks() {
  // remove all elements from the screen
  // reset all buttons so they do not have any functions bound to them
  hideElements();

  $('form').show();
  var instructionChecks = $('form').serializeArray();

  var ok = true;
  for(var i = 0; i < instructionChecks.length; i++) {
    // check for incorrect responses
	if (i<2){
		if(instructionChecks[i].value !== "correct") {
		  ok = false;
		  break;
		}
	} else {
		if((instructionChecks[2].value !== "helpful" && experimentInfo.socialCondition =="helpful") || (instructionChecks[2].value !== "neutral" && experimentInfo.socialCondition =="neutral") || (instructionChecks[2].value !== "malic" && experimentInfo.socialCondition =="malic") ) {
		  ok = false;
		  break;
		}
	}

    // check for empty answers
    if(instructionChecks[i].value === "") {
      alert('Please fill out all fields.');
      ok = false;
      break;
    }
  }

  // where this is the number of questions in the instruction check
  if (instructionChecks.length !== 3) {
    ok = false;
  }

  if(!ok) {
    alert("You didn't answer all the questions correctly. Please read through the instructions and take the quiz again to continue.");
    showInstructions(); // go back to instruction screen
  }
  else {
    // remove instruction checks form
    $('#instruction-checks').html('');
    initializeTask(); // start experiment
  }
}

function showInputOptions() {
  /*
  * allow the user to specify which condition they are in
  * as well as which aspect of the experiment to start in
  *
  * this function is particularly useful for debugging and testing
  */

  // remove all elements from the screen
  // reset all buttons so they do not have any functions bound to them
  hideElements();
  
  // first present the input options for the experiment (for debugging purposes)
  // allows you to set the experimental conditions instead of randomly assigning them above
  var divInputOptions = $('#input-options');
  divInputOptions.show();
  divInputOptions.html('<h3>Experiment options.</h3> \
                        <p>Which tokens should be hidden?</p> \
                        <select id="condition1"> \
                          <option value=0>None Hidden</option> \
                          <option value=1>One Blue, No Red</option> \
						  <option value=2>One Blue, One Red</option> \
						  <option value=3>One Blue, Two Red</option> \
						  <option value=4>One Blue, Three Red</option> \
						  <option value=5>One Blue, Four Red</option> \
						  <option value=6>Two Blue, No Red</option> \
						  <option value=7>Two Blue, One Red</option> \
						  <option value=8>Two Blue, Two Red</option> \
						  <option value=9>Two Blue, Three Red</option> \
						  <option value=10>Two Blue, Four Red</option> \
						  <option value=11>Three Blue, No Red</option> \
						  <option value=12>Three Blue, One Red</option> \
						  <option value=13>Three Blue, Two Red</option> \
						  <option value=14>Three Blue, Three Red</option> \
						  <option value=15>Three Blue, Four Red</option> \
						  <option value=16>Four Blue, No Red</option> \
						  <option value=17>Four Blue, One Red</option> \
						  <option value=18>Four Blue, Two Red</option> \
						  <option value=19>Four Blue, Three Red</option> \
						  <option value=20>Four Blue, Four Red</option> \
						  <option value=21>No Blue, One Red</option> \
						  <option value=22>No Blue, Two Red</option> \
						  <option value=23>No Blue, Three Red</option> \
						  <option value=24>No Blue, Four Red</option> \
						  </select> \
						<p> What social condition would you like to be in? </p> \
						<select id="social"> \
							<option value="neutral">Neutral</option> \
							<option value="malic">Malicious</option> \
							<option value="helpful">Helpful</option> \
						</select> \
                        <p>What section should we start in?</p> \
                        <select id="section"> \
                          <option value="intro">Introduction</option> \
                          <option value="demographics">Demographics</option> \
                          <option value="instructions">Instructions</option> \
                          <option value="test">Test Trial</option> \
                        </select> \
						<br /><br />');

  htmlElements.buttonNext.show();
  htmlElements.buttonNext.click(function () {

    experimentInfo.condition1 = $('#condition1').val();
    experimentInfo.socialCondition=$('#social').val();
	console.log(experimentInfo.socialCondition);
	if (experimentInfo.socialCondition=='neutral'){
		experimentInfo.condInstruct="employees enjoys rearranging the order of the chocolates in the boxes, though he doesn't change which ones go where and he didn't get to all of them.";
	} else 	if (experimentInfo.socialCondition=='malic'){
		experimentInfo.condInstruct="employees who thinks the company is losing money on this promotion randomly puts more red chocolates in some of the boxes, though he didn't get to all of them.";
	} else 	if (experimentInfo.socialCondition=='helpful'){
		experimentInfo.condInstruct="employees wants to increase the odds that people will get prize money so he randomly puts more blue chocolates in some of the boxes, though he didn't get to all of them.";
	}
    // determinewhich section to start with:
    switch ($('#section').val()) {
      case "intro":
        showIntro();
        break;
      case "demographics":
        showDemographics();
        break;
      case "instructions":
        showInstructions();
        break;
      case "test":
        initializeTask();
        break;
    }
  });

}