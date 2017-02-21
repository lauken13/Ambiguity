/*global $, alert, hideElements, htmlElements, experimentInfo:true, showInstructions */
/*jshint multistr: true */


function showExitQuestions(exp_data, choice, base_time) {
  // remove all elements from the screen
  // reset all buttons so they do not have any functions bound to them
  hideElements();
  exp_data.rt = new Date().getTime() - base_time;
  
  // modify here if you want to get different demographic information
  var divExit = $('#demographics');
  divExit.show();
  divExit.html('<p>You saw '+experimentInfo.NumberHidden+' chocolates that were re-wrapped with grey wrappers. We want to ask you some questions about what you thought the wrappper color underneath. Of the '+experimentInfo.NumberHidden+ '  double-wrapped chocolates, please estimate the following:</p>\
						<form> \
                          <label for="EstNoRed">How many of the double wrappped chocolates (grey) that you saw do you think had <b> blue </b> wrappers underneath?</label><br><input name="EstNoRed" /><br /><br /> \
                          <label for="EstNoBlue">How many of the double wrappped chocolates (grey) that you saw do you think had <b> red </b> wrappers underneath?</label><br><input name="EstNoBlue" /><br /><br /> \
						  <label for="OtherColors">Do you think there were any other colored wrappers underneath? </label> <br> \
                            <input type="radio" name="OtherColors" value="Yes" /> Yes &nbsp; \
                            <input type="radio" name="OtherColors" value="No" /> No &nbsp; \
                            <input type="radio" name="OtherColors" value="Unsure" /> Unsure<br /><br> \
                          <label for="EstNoOther">If you thought there were other colors covered by the blank wrappers, how many different other colors do you think there were? If you didn\'t think there were other colors, please enter zero here. <br> </label><input name="EstNoOther" /><br /><br /> \
                          </form><br />');

  htmlElements.buttonNext.show();
htmlElements.buttonNext.click(function() {validateExitQuestions(exp_data, choice, base_time);});
}

function validateExitQuestions(exp_data,choice,base_time) {
  experimentInfo.ExitQuestions = $('form').serializeArray();

  var ok = true, color_exists = false;
  for (var i = 0; i < experimentInfo.ExitQuestions.length; i++) {
    // validate age
    if ((experimentInfo.ExitQuestions[i].name === "EstNoRed") & (/[^0-9]/.test(experimentInfo.ExitQuestions[i].value))) {
      alert('Please only use numbers when estimating the number of red chocolates that were hidden');
      ok = false;
      break;
    }
	
    if ((experimentInfo.ExitQuestions[i].name === "EstNoBlue") & (/[^0-9]/.test(experimentInfo.ExitQuestions[i].value))) {
      alert('Please only use numbers when estimating the number of blue chocolates that were hidden.');
      ok = false;
      break;
    }

	if ((experimentInfo.ExitQuestions[i].name === "EstNoOther") & (/[^0-9]/.test(experimentInfo.ExitQuestions[i].value))) {
      alert('Please only use numbers when estimating the number of other colors of the hidden chocolates');
      ok = false;
      break;
    }

	
    // test for empty answers
    if(experimentInfo.ExitQuestions[i].value === "") {
      alert('Please fill out all fields.');
      ok = false;
      break;
    }

    if(experimentInfo.ExitQuestions[i].name === "OtherColors") {
      color_exists = true;
    }
  }
  
  if ((color_exists === false) && ok){
    alert('Please select a gender.');
    ok = false;
  }

  if(!ok) {
    showExitQuestions(exp_data, choice, base_time);
  }
  else {
    // remove ExitQuestions form
    $('#demographics').html('');
	 
	 exp_data.EstBlue=experimentInfo.ExitQuestions[0].value;
	 exp_data.EstRed=experimentInfo.ExitQuestions[1].value;
	 exp_data.OtherColors=experimentInfo.ExitQuestions[2].value;
	 exp_data.EstOther=experimentInfo.ExitQuestions[3].value;
	 console.log(exp_data);
     //save trial data
	 console.log(choice);
	 console.log(base_time);
    saveTestTrial(exp_data, choice, base_time);
    testFeedback(exp_data);
  }
}