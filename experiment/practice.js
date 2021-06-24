var practice_stimulus_Ns6 = [
  { practice_stimulus_Ns6: 'img/animals/S1.jpg', data_Ns6:{state: 1, test_part:'practice', correct_response:49}},
  { practice_stimulus_Ns6: 'img/animals/S2.jpg', data_Ns6:{state: 2, test_part:'practice', correct_response:50}},
  { practice_stimulus_Ns6: 'img/animals/S3.jpg', data_Ns6:{state: 3, test_part:'practice', correct_response:51}},
  { practice_stimulus_Ns6: 'img/animals/S4.jpg', data_Ns6:{state: 4, test_part:'practice', correct_response:52}},
  { practice_stimulus_Ns6: 'img/animals/S5.jpg', data_Ns6:{state: 5, test_part:'practice', correct_response:53}},
  { practice_stimulus_Ns6: 'img/animals/S6.jpg', data_Ns6:{state: 6, test_part:'practice', correct_response:54}}];

var practice_stimulus_Ns4 = [
  { practice_stimulus_Ns4: 'img/nature/S1.jpg', data_Ns4:{state: 1, test_part:'practice', correct_response:49}},
  { practice_stimulus_Ns4: 'img/nature/S2.jpg', data_Ns4:{state: 2, test_part:'practice', correct_response:50}},
  { practice_stimulus_Ns4: 'img/nature/S3.jpg', data_Ns4:{state: 3, test_part:'practice', correct_response:51}},
  { practice_stimulus_Ns4: 'img/nature/S4.jpg', data_Ns4:{state: 4, test_part:'practice', correct_response:52}}];

var practice_trial_Ns6 = {
	type: 'image-keyboard-response',
	stimulus: jsPsych.timelineVariable('practice_stimulus_Ns6'),
	stimulus_height: 360, stimulus_width: 540,
	choices: ['1', '2', '3', '4', '5', '6'],
	trial_duration: 3000,
	data: jsPsych.timelineVariable('data_Ns6'),
	on_finish: function(data){
		data.correct = data.key_press == data.correct_response;
		trial_node_id = jsPsych.currentTimelineNodeID();
	}
};

var practice_trial_Ns4 = {
	type: 'image-keyboard-response',
	stimulus: jsPsych.timelineVariable('practice_stimulus_Ns4'),
	stimulus_height: 360, stimulus_width: 540,
	choices: ['1', '2', '3', '4'],
	trial_duration: 3000,
	data: jsPsych.timelineVariable('data_Ns4'),
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

var practice_feedback = {
	type: 'html-keyboard-response',
	stimulus: function(){
		var prev_trial = jsPsych.data.getDataByTimelineNode(trial_node_id);
		var feedback_img = prev_trial.select('stimulus').values[0];
		var feedback = prev_trial.select('key_press').values[0];
		console.log(feedback_img);
		console.log(feedback);
		console.log(prev_trial.select('correct').values[0]);
		if (prev_trial.select('correct').values[0]){
			return  '<img src="' + feedback_img + '" width="540" height = "360" style="border:14px solid orange">';
  		}else{
  			return '<img src="' + feedback_img + '" width="540" height = "360">';
  		}
  	},
	choices: jsPsych.NO_KEYS,
	trial_duration: 300
};

var practice_finished = {
  	type: 'instructions',
  	pages: [
  	'<p class="center-content">You have completed the practice round!</p>'+ 
  	'<p class="center-content">Take a break if you would like and then press "Begin" to start the experiment.</p>'
  	],
  	show_clickable_nav: true,
  	button_label_next: 'Begin'
  };

 var practice_block_Ns6 = {
	timeline: [practice_trial_Ns6, practice_feedback, fixation],
	timeline_variables: practice_stimulus_Ns6,
	randomize_order: true,
	repetitions: 5
};


var practice_block_Ns4 = {
	timeline: [practice_trial_Ns4, practice_feedback, fixation],
	timeline_variables: practice_stimulus_Ns4,
	randomize_order: true,
	repetitions: 5
};


function create_practice(Ns) {
	switch (Ns){
		case 4:
			return practice_block_Ns4; break;
		case 6:
			return practice_block_Ns6; break;
	}
  console.log("Creating practice block!");
};

function finish_practice() {
  console.log("Finishing practice trials.");
  return practice_finished;
}