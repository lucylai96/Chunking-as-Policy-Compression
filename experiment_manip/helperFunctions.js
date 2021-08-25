// between block instructions
var between_block = {
    type: 'html-keyboard-response',
    stimulus: [
    '<p class="center-content">You have completed a block! </p>'+
    '<p class="center-content">Press any key on the keyboard to continue, </p>'+ 
    '<p class="center-content">or wait for the automatic progression to the next block after one minute.</p>' 
    ],
    stimulus_duration: 60000,
    trial_duration: 60000
  };


var fixation = {
    type: 'html-keyboard-response',
    stimulus: '',
    choices: jsPsych.NO_KEYS,
    trial_duration: 0 // ms
  };


var survey_occurences = {
  type: 'survey-text',
  questions: [{prompt: 'Please enter the sum of each number that appeared under the picture:', value: 'Sum'}],
  button_label: 'Submit'
}; 
 

function pushFeedback(num, block, chunk, timeline){
    var feedback = {
    type: 'html-keyboard-response',
    stimulus: function(){
      var prev_trial = jsPsych.data.getDataByTimelineNode(trial_node_id);
      var feedback_img = prev_trial.select('stimulus').values[0];
      console.log(feedback_img);
      var feedback = prev_trial.select('key_press').values[0];
      if (prev_trial.select('correct').values[0]){
        if (block=='structured_incentive' && num==chunk[1]){
          return '<img src="' + feedback_img + '" width="540" height = "360" style="border:16px solid Violet">';
        }
        else{
          return '<img src="' + feedback_img + '" width="540" height = "360" style="border:16px solid orange">';
        }
      }
      else{ 
        return '<img src="' + feedback_img + '" width="540" height = "360">'
      }
    },
    choices: jsPsych.NO_KEYS,
    trial_duration: 350
  }
  timeline.push(feedback);
};

function pushFeedback_load(timeline, presence, rand_num){
  var feedback = {
    type: 'html-keyboard-response',
    stimulus: function(){
      var prev_trial = jsPsych.data.getDataByTimelineNode(trial_node_id);
      var feedback_img = prev_trial.select('stimulus').values[0];
      console.log(feedback_img);
      var feedback = prev_trial.select('key_press').values[0];
      if (prev_trial.select('correct').values[0]){
        return '<img src="' + feedback_img + '" width="540" height = "360" style="border:16px solid orange">';
      }
      else{ 
        return '<img src="' + feedback_img + '" width="540" height = "360">'
      }
    },
    choices: jsPsych.NO_KEYS,
    prompt: function(){
      if (presence){
        return '<p><b>'+rand_num+'</b></p>';
      }
      else{
        return '<p>-</p>';
      }
    },  
    trial_duration: 350
    }
  timeline.push(feedback);
};

 // push trials
 function pushTrials(set, num, block, chunk, timeline){
  var trial = {
    type: 'image-keyboard-response',
    stimulus: eval('stimulus_set' + set + '[num-1].stimulus'),
    stimulus_height: 360, stimulus_width: 540,
    choices: ['s','d','h','j'],
    trial_duration: 2500,
    data: eval('stimulus_set' + set + '[num-1].data'),
    on_finish: function(data){
      data.correct = data.key_press == data.correct_response;
      trial_node_id = jsPsych.currentTimelineNodeID();
      var curr_progress_bar_value = jsPsych.getProgressBarCompleted();
      jsPsych.setProgressBar(curr_progress_bar_value + (1/480));
    }
  }
  timeline.push(trial);
  pushFeedback(num, block, chunk, timeline);
  timeline.push(fixation);
};

 // push trials
 function pushTrials_load(set, num, timeline){
  var presence = Math.random() < 0.3;
  var rand_num = Math.floor(Math.random()*10) + 1;
  var trial = {
    type: 'image-keyboard-response',
    stimulus: eval('stimulus_set' + set + '[num-1].stimulus'),
    stimulus_height: 360, stimulus_width: 540,
    choices: ['s','d','h','j'],
    trial_duration: 2500,
    data: eval('stimulus_set' + set + '[num-1].data'),
    prompt: function(){
      if (presence){
        return '<p><b>'+rand_num+'</b></p>';
      }
      else{
        return '<p>-</p>';
      }
    },
    on_finish: function(data){
      data.correct = data.key_press == data.correct_response;
      trial_node_id = jsPsych.currentTimelineNodeID();
      var curr_progress_bar_value = jsPsych.getProgressBarCompleted();
      jsPsych.setProgressBar(curr_progress_bar_value + (1/480));
    }
  }
  timeline.push(trial);
  pushFeedback_load(timeline, presence, rand_num);
  timeline.push(fixation);
};




function pushBlocks(timeline, set, condition, chunk){
  // i is the picture set to be used
  // condition tells us whether it is structured or random
  // chunk tells us configuraiton of the chunk
  if (condition=='random'){
    var stateDist = [30, 30, 30, 30, 0];
  }
  else{
    var stateDist = [30, 30, 30, 30, 30];
    stateDist[chunk[0]-1] = 0;
    stateDist[chunk[1]-1] = 0;
  }

  var randomizedTrials = jsPsych.randomization.repeat([1,2,3,4,7], stateDist);
  for (i=0; i<randomizedTrials.length; i++){
    num = randomizedTrials[i];
    if (num < 7){
      if (condition == 'structured_load'){
        pushTrials_load(set, num, timeline);
      }
      else{
        pushTrials(set, num, condition, chunk, timeline);
      }
    }
    else{
      if (condition == 'structured_load')
      {
        pushTrials_load(set, chunk[0], timeline);
        pushTrials_load(set, chunk[1], timeline);
      }
      else{
        pushTrials(set, chunk[0], condition, chunk, timeline);
        pushTrials(set, chunk[1], condition, chunk, timeline);
      }
    }
  }
}


function find_exoChunk(chunk){
  if (chunk[0]==2 && chunk[1]==1){
    var exoChunk = [3,4];
  }
  else if (chunk[0]==3 && chunk[1]==4){
    var exoChunk = [1,2];
  }
  else if (chunk[0]==2 && chunk[1]==3){
    var exoChunk = [1,4]
  }
  return exoChunk;
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


function startExperiment(){
    //console.log("Timeline: " + JSON.stringify(timeline));
    jsPsych.init({
      timeline: timeline,
      show_progress_bar: true,
      auto_update_progress_bar: false,
      //on_finish: function() {
        //window.location.href = "end.html";
      //}
    })
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
      var correct_bonus = Math.round(80 * jsPsych.data.get().filter({correct: true}).count() / 480); 
      jsPsych.data.addDataToLastTrial({"bonus": correct_bonus});
      return ['<p class="center-content">You won a bonus of <b>$' + (correct_bonus == 1 ? '10.00' : 0.1 * correct_bonus + 2) + '</b>.</p>' +
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
