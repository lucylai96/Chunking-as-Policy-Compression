// stimuli

// import images
var Ns4_perform = [
  { stimulus: 'img/nature/S1.jpg', data:{state:1, test_part:'Ns4,perform', correct_response:49} },
  { stimulus: 'img/nature/S2.jpg', data:{state:2, test_part:'Ns4,perform', correct_response:50} },
  { stimulus: 'img/nature/S3.jpg', data:{state:3, test_part:'Ns4,perform', correct_response:51} },
  { stimulus: 'img/nature/S4.jpg', data:{state:4, test_part:'Ns4,perform', correct_response:52} } ];

var Ns4_train = [
  { stimulus: 'img/nature/S1.jpg', data:{state:1, test_part:'Ns4,train', correct_response:49} },
  { stimulus: 'img/nature/S2.jpg', data:{state:2, test_part:'Ns4,train', correct_response:50} },
  { stimulus: 'img/nature/S3.jpg', data:{state:3, test_part:'Ns4,train', correct_response:51} },
  { stimulus: 'img/nature/S4.jpg', data:{state:4, test_part:'Ns4,train', correct_response:52} } ];

var Ns4_test = [
  { stimulus: 'img/nature/S1.jpg', data:{state:1, test_part:'Ns4,test', correct_response:49} },
  { stimulus: 'img/nature/S2.jpg', data:{state:2, test_part:'Ns4,test', correct_response:50} },
  { stimulus: 'img/nature/S3.jpg', data:{state:3, test_part:'Ns4,test', correct_response:51} },
  { stimulus: 'img/nature/S4.jpg', data:{state:4, test_part:'Ns4,test', correct_response:52} } ];

var Ns6_perform = [
  { stimulus: 'img/animals/S1.jpg', data:{state:1, test_part:'Ns6,perform', correct_response:49} },
  { stimulus: 'img/animals/S2.jpg', data:{state:2, test_part:'Ns6,perform', correct_response:50} },
  { stimulus: 'img/animals/S3.jpg', data:{state:3, test_part:'Ns6,perform', correct_response:51} },
  { stimulus: 'img/animals/S4.jpg', data:{state:4, test_part:'Ns6,perform', correct_response:52} }, 
  { stimulus: 'img/animals/S5.jpg', data:{state:5, test_part:'Ns6,perform', correct_response:53} },
  { stimulus: 'img/animals/S6.jpg', data:{state:6, test_part:'Ns6,perform', correct_response:54} } ];

var Ns6_train = [
  { stimulus: 'img/animals/S1.jpg', data:{state:1, test_part:'Ns6,train', correct_response:49} },
  { stimulus: 'img/animals/S2.jpg', data:{state:2, test_part:'Ns6,train', correct_response:50} },
  { stimulus: 'img/animals/S3.jpg', data:{state:3, test_part:'Ns6,train', correct_response:51} },
  { stimulus: 'img/animals/S4.jpg', data:{state:4, test_part:'Ns6,train', correct_response:52} }, 
  { stimulus: 'img/animals/S5.jpg', data:{state:5, test_part:'Ns6,train', correct_response:53} },
  { stimulus: 'img/animals/S6.jpg', data:{state:6, test_part:'Ns6,train', correct_response:54} } ];

var Ns6_test = [
  { stimulus: 'img/animals/S1.jpg', data:{state:1, test_part:'Ns6,test', correct_response:49} },
  { stimulus: 'img/animals/S2.jpg', data:{state:2, test_part:'Ns6,test', correct_response:50} },
  { stimulus: 'img/animals/S3.jpg', data:{state:3, test_part:'Ns6,test', correct_response:51} },
  { stimulus: 'img/animals/S4.jpg', data:{state:4, test_part:'Ns6,test', correct_response:52} },
  { stimulus: 'img/animals/S5.jpg', data:{state:5, test_part:'Ns6,test', correct_response:53} },
  { stimulus: 'img/animals/S6.jpg', data:{state:6, test_part:'Ns6,test', correct_response:54} } ];



function importImages(){
 	return [Ns4_train, Ns4_test, Ns6_train, Ns6_test];
};


// between block instructions

var between_block = {
    type: 'html-keyboard-response',
    stimulus: [
    '<p class="center-content">You have completed a block! </p>'+
    '<p class="center-content">Press any key on the keyboard to continue to the next block,</p>'+ 
    '<p class="center-content">or wait for the automatic progression to the next block after one minute.</p>' 
    ],
    stimulus_duration: 60000,
    trial_duration: 60000
  };


var between_block_beforebaseline= {
    type: 'instructions',
    pages: [
    '<p class="center-content">You have completed a block!</p>'+ 
    '<p class="center-content">Take a break if you would like and then press "Next" to continue to the second part of the experiment. </p>'
    ],
    show_clickable_nav: true,
    on_finish: function(data){
      jsPsych.setProgressBar(0.5);
    }
  };


var changePictureSet_animal = {
  type: 'instructions',
  pages: [
  '<p class="center-content">In the following blocks, you will see a different set of animal pictures. </p>'+
  '<p class="center-content">The correct response to each animal picture will be learned during the experiment. </p>'+    
  '<table style="margin-left:auto;margin-right:auto;table-layout:fixed !important; width:800px;"><tr>' +
  '<td><img src="img/animals/S3.jpg" style="width: 220px;"></td>' +
  '<td><img src="img/animals/S4.jpg" style="width: 220px; "></td>' +
  '<td><img src="img/animals/S6.jpg" style="width: 220px; "></td>' +
  '</tr><tr>' +
  '</tr></table>'+
  '<table style="margin-left:auto;margin-right:auto;table-layout:fixed !important; width:800px;"><tr>' +
  '<td><img src="img/animals/S2.jpg" style="width: 220px; "></td>' +
  '<td><img src="img/animals/S1.jpg" style="width: 220px;"></td>' +
  '<td><img src="img/animals/S5.jpg" style="width: 220px; "></td>' +
  '</tr><tr>' +
  '</tr></table>'+
  '<p class="center-content">Please click "Next" to continue to the experiment. </p>'
  ],
  show_clickable_nav: true,
  show_page_number: true
};

var changePictureSet_nature = {
  type: 'instructions',
  pages: [
  '<p class="center-content">In the following blocks, you will see a different set of natural scenes. </p>'+
  '<p class="center-content">The correct response to each natural scene will be learned during the experiment. </p>'+    
    '<table style="margin-left:auto;margin-right:auto;table-layout:fixed !important; width:1100px;"><tr>' +
    '<td><img src="img/nature/S1.jpg" style="width: 250px; height:170px"></td>' +
    '<td><img src="img/nature/S2.jpg" style="width: 250px; height:170px"></td>' +
    '<td><img src="img/nature/S3.jpg" style="width: 250px; height:170px"></td>' +
    '<td><img src="img/nature/S4.jpg" style="width: 250px; height:170px"></td>' +
    '</tr><tr>' +
    '</tr></table>'+
    '<p class="center-content">Please click "Next" to continue to the experiment. </p>'
  ],
  show_clickable_nav: true,
  show_page_number: true
};

 // feedback
 var feedback = {
  type: 'html-keyboard-response',
  stimulus: function(){
    var prev_trial = jsPsych.data.getDataByTimelineNode(trial_node_id);
    var feedback_img = prev_trial.select('stimulus').values[0];
    var feedback = prev_trial.select('key_press').values[0];
    if (prev_trial.select('correct').values[0]){
        return '<img src="' + feedback_img + '" width="540" height = "360" style="border:14px solid orange">';
    }else{
        return '<img src="' + feedback_img + '" width="540" height = "360">';
    } 
  },
  choices: jsPsych.NO_KEYS,
  trial_duration: 350
};


// fixation
var fixation = {
    type: 'html-keyboard-response',
    stimulus: '',
    choices: jsPsych.NO_KEYS,
    trial_duration: 80 // ms
  };



 // push trials
 function pushTrials(num, block, timeline){
  var trial = {
    type: 'image-keyboard-response',
    stimulus: function(){
      switch(block){
        case 'Ns4_perform':
          return Ns4_perform[num-1].stimulus; break;
        case 'Ns4_train': 
          return Ns4_train[num-1].stimulus; break;
        case 'Ns4_test':
          return Ns4_test[num-1].stimulus; break;
        case 'Ns6_perform':
          return Ns6_perform[num-1].stimulus; break;
        case 'Ns6_train':
          return Ns6_train[num-1].stimulus; break;
        case 'Ns6_test':
          return Ns6_test[num-1].stimulus; break;
      }
    },
    stimulus_height: 360, stimulus_width: 540,
    choices: function(){
      if (block.includes('4')){
        return ['1','2','3','4'];
      }
      else if (block.includes('6')){
        return ['1', '2', '3', '4', '5', '6'];
      }
    },
    trial_duration: 2500,
    data: function(){
      switch(block){
        case 'Ns4_perform':
          return Ns4_perform[num-1].data; break;
        case 'Ns4_train': 
          return Ns4_train[num-1].data; break;
        case 'Ns4_test':
          return Ns4_test[num-1].data; break;
        case 'Ns6_perform':
          return Ns6_perform[num-1].data; break;
        case 'Ns6_train':
          return Ns6_train[num-1].data; break;
        case 'Ns6_test':
          return Ns6_test[num-1].data; break;
      }
    },
    on_finish: function(data){
      data.correct = data.key_press == data.correct_response;
      trial_node_id = jsPsych.currentTimelineNodeID();
      var curr_progress_bar_value = jsPsych.getProgressBarCompleted();
      jsPsych.setProgressBar(curr_progress_bar_value + (1/(700+60)));
    }
  }
  timeline.push(trial);
  timeline.push(feedback);
  timeline.push(fixation);
};



function train_block(timeline, condition){
	switch (condition){
		case 'Ns6':
			var stateDist_n6 = [20, 20, 20, 0, 0, 20, 20];
			var randomizedTrials = jsPsych.randomization.repeat([1,2,3,4,5,6,7], stateDist_n6);
			for (i=0; i<randomizedTrials.length; i++){
				num = randomizedTrials[i];
    		if (num < 7){
          pushTrials(num, 'Ns6_train', timeline);
        }
    		else{
      		pushTrials(5, 'Ns6_train', timeline);
      		pushTrials(4, 'Ns6_train', timeline);
        }
      }
      break;
    case 'Ns4':
      var stateDist_n4 = [0, 0, 20, 20, 20];
      var randomizedTrials = jsPsych.randomization.repeat([1,2,3,4,7], stateDist_n4);
			for (i=0; i<randomizedTrials.length; i++){
				num = randomizedTrials[i];
    		if (num < 7){
      		pushTrials(num, 'Ns4_train', timeline);
    		}
    		else{
      		pushTrials(2, 'Ns4_train', timeline);
      		pushTrials(1, 'Ns4_train', timeline);
      	}
      }
      break;
  } 
};


function perform_block(timeline, condition){
  switch (condition){
    case 'Ns6':
      var randomizedTrials = jsPsych.randomization.repeat([1,2,3,4,5,6,7], [15,15,15,0,0,15,15]);
        for (i=0; i<randomizedTrials.length; i++){
          num = randomizedTrials[i];
          if (num < 7){
            pushTrials(num, 'Ns6_perform', timeline);
          }
          else{
            pushTrials(5, 'Ns6_perform', timeline);
            pushTrials(4, 'Ns6_perform', timeline);
          }
        }
      break;
    case 'Ns4':
      var randomizedTrials = jsPsych.randomization.repeat([1,2,3,4,7], [0,0,15,15,15]);
        for (i=0; i<randomizedTrials.length; i++){
          num = randomizedTrials[i];
          if (num < 7){
            pushTrials(num, 'Ns4_perform', timeline);
          }
          else{
            pushTrials(2, 'Ns4_perform', timeline);
            pushTrials(1, 'Ns4_perform', timeline);
          }
        }
      break;
  }
};

function test_block(timeline, condition){
  switch (condition){
    case 'Ns6':
      var randomizedTrials = jsPsych.randomization.repeat([1,2,3,4,5,6], 15);
      for (i=0; i<randomizedTrials.length; i++){
        num = randomizedTrials[i];
        pushTrials(num, 'Ns6_test', timeline);
      }
      break;
    case 'Ns4':
      var randomizedTrials = jsPsych.randomization.repeat([1,2,3,4], 15);
      for (i=0; i<randomizedTrials.length; i++){
        num = randomizedTrials[i];
        pushTrials(num, 'Ns4_test', timeline);
      }
      break;
  }
};



function experimentalBlocks(timeline, setsize){
  train_block(timeline, setsize);
  timeline.push(between_block);
  perform_block(timeline, setsize);
  timeline.push(between_block);
  test_block(timeline, setsize);
};


// Save data to CSV
function saveData(name, data) {
  var xhr = new XMLHttpRequest();
    xhr.open('POST', 'write_data.php'); 
    xhr.setRequestHeader('Content-Type', 'application/json');
    xhr.send(JSON.stringify({
      filename: name,
      filedata: data
    }));
};  


 // Calculate bonus at end
  var bonus_block = {
    type: 'instructions',
    pages: function() {
      var correct_bonus = Math.round(100 * jsPsych.data.get().filter({correct: true}).count() / 700); 
      jsPsych.data.addDataToLastTrial({"bonus": correct_bonus});
      return ['<p class="center-content">You won a bonus of <b>$' + (correct_bonus == 1 ? '10.00' : 0.1 * correct_bonus) + '</b>.</p>' +
      '<p class="center-content"> IMPORTANT: <b>Press "Next"</b> to continue to the survey questions.</p>'];
    },
    show_clickable_nav: true,
    on_finish: function(data){
      jsPsych.setProgressBar(1);
    }
  };


// survey comment at the end
  var survey_comments = {
    type: 'survey-text',
    questions: [{prompt: 'You have finished the experiment! We\'re always trying to improve. Please let us know if you have any feedback or comments about the task.', value: 'Comments'}],
    button_label: 'Submit'
  };



// save data
 var save_data = {
    type: "survey-text",
    questions: [{prompt: 'Please input your MTurk Worker ID so that we can pay you the appropriate bonus. Your ID will not be shared with anyone outside of our research team. Your data will now be saved.', value: 'Worker ID'}],
    on_finish: function(data) {
      var responses = JSON.parse(data.responses);
      var subject_id = responses.Q0;
      console.log(subject_id)
      saveData(subject_id, jsPsych.data.get().csv());;
    },
  }


// end block
 var end_block = {
    type: 'instructions',
    pages: [
    '<p class="center-content"> <b>Thank you for participating in our experiment!</b></p>' +
    '<p class="center-content"> <b>Please wait on this page for a minute while your data saves.</b></p>'+
    '<p class="center-content"> Your bonus will be applied after your data has been processed and your HIT has been approved.</p>'+
    '<p class="center-content"> Please email zixiang_huang@fas.harvard.edu with any additional questions or concerns. You may now exit this window.</p>'
    ],
    show_clickable_nav: false,
    allow_backward: false,
    show_page_number: false
  };
