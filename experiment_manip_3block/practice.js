var stimuli = [
  { stimulus: 'img/control/S1.jpg', data:{state: 1, test_part:'random train', correct_response:49}},
  { stimulus: 'img/control/S2.jpg', data:{state: 2, test_part:'random train', correct_response:50}},
  { stimulus: 'img/control/S3.jpg', data:{state: 3, test_part:'random train', correct_response:51}},
  { stimulus: 'img/control/S4.jpg', data:{state: 4, test_part:'random train', correct_response:52}}];


var trial = {
	type: 'image-keyboard-response',
	stimulus: jsPsych.timelineVariable('stimulus'),
	stimulus_height: 360, stimulus_width: 540,
	choices: ['1', '2', '3', '4'],
	trial_duration: 3000,
	data: jsPsych.timelineVariable('data'),
	on_finish: function(data){
		data.correct = data.key_press == data.correct_response;
		trial_node_id = jsPsych.currentTimelineNodeID();
	}
};

var fixation = {
	type: 'html-keyboard-response',
    stimulus: '',
    choices: jsPsych.NO_KEYS,
    trial_duration: 200 // ms
 };

var feedback = {
	type: 'html-keyboard-response',
	stimulus: function(){
		var prev_trial = jsPsych.data.getDataByTimelineNode(trial_node_id);
		var feedback_img = prev_trial.select('stimulus').values[0];
		var feedback = prev_trial.select('key_press').values[0];
		console.log(feedback_img);
		console.log(feedback);
		console.log(prev_trial.select('correct').values[0]);
		if (prev_trial.select('correct').values[0]){
			return  '<img src="' + feedback_img + '" width="540" height = "360" style="border:16px solid orange">';
  		}else{
  			return '<img src="' + feedback_img + '" width="540" height = "360">';
  		}
  	},
	choices: jsPsych.NO_KEYS,
	trial_duration: 300
};

var finished = {
  	type: 'instructions',
  	pages: [
  	'<p class="center-content">You have completed one experimental block!</p>'+ 
  	'<p class="center-content">Take a break if you would like and then press "Next" to continue.</p>'
  	],
  	show_clickable_nav: true,
  	button_label_next: 'Next'
  };


var block = {
	timeline: [trial, feedback, fixation],
	timeline_variables: stimuli,
	randomize_order: true,
	repetitions: 20
};

function create_random_train() {
	return block; 
  console.log("Creating baseline block!");
};

function finish_random_train() {
  console.log("Finishing baseline trials.");
  return finished;
}