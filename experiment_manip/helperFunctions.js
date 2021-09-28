// between block instructions.
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


function create_occurence_survey(num, order){
  var multi_choice = {
    type: 'survey-multi-choice',
    questions: [
    {prompt: 
      '<p class="center-content">Which of the two pictures below appeared more often in this block? </p>' +
      '<table style="margin-left:auto;margin-right:auto;table-layout:fixed !important; width:580px;"><tr>' +
      '<td><img src="img/set' +num+ '/S' +order[0]+ '.jpg" style="width: 220px; height: 150px"></td>' +
      '<td><img src="img/set' +num+ '/S' +order[1]+ '.jpg" style="width: 220px; height: 150px"></td>' +
      '</tr><tr>' +
      '<td>Picture A</td><td>Picture B</td>' +
      '</tr></table>',
      options: ["Picture A", "Picture B", "They had the same number of occurrences"]
      }],
    };
  return multi_choice;
}

function create_occurence_feedback(freq_order, stateDist){
  var freq_discr_feedback = {
    type: 'html-keyboard-response',
    stimulus: function(){
    var prev_trial = jsPsych.data.getDataByTimelineNode(trial_node_id);
    var response = prev_trial.select('responses').values[0];
    if (stateDist[freq_order[0]] > stateDist[freq_order[1]]){
      var isCorrect = response === "Picture A";
    }
    else if (stateDist[freq_order[0]] < stateDist[freq_order[1]]){
      var isCorrect = response === "Picture B";
    }
    else{
      var isCorrect = response === "They had the same number of occurrences";
    }

    if (isCorrect){
      return ['<p class="center-content">Congratulations, you selected the correct answer! </p>'+
        '<p class="center-content">A bonus of $2 has been assigned to you. </p>'+ 
        '<p class="center-content">You will know the total amount of your performance-based bonus at the end of the task. </p>' +
        '<p class="center-content">Please press any key to continue. </p>' ];
    }
    else{
      return ['<p class="center-content">Underfortunately, the answer you selected was not correct. </p>'+
        '<p class="center-content">Please press any key to continue. </p>'];
    }
  },
  stimulus_duration: 20000,
  trial_duration: 20000
  }
  return freq_discr_feedback;
}


function bonus_freq_discr(freq_order, stateDist){
  var prev_trial = jsPsych.data.getDataByTimelineNode(trial_node_id);
  var response = prev_trial.select('responses').values[0];
  if (stateDist[freq_order[0]] > stateDist[freq_order[1]]){
    var isCorrect = response === "Picture A";
  }
  else if (stateDist[freq_order[0]] < stateDist[freq_order[1]]){
    var isCorrect = response === "Picture B";
  }
  else{
    var isCorrect = response === "They had the same number of occurrences";
  }

  if (isCorrect){
    return 2;
  }
  else{
    return 0;
  }
}


function pushFeedback(num, block, chunk_rare, timeline){
    var feedback = {
    type: 'html-keyboard-response',
    stimulus: function(){
      var prev_trial = jsPsych.data.getDataByTimelineNode(trial_node_id);
      var feedback_img = prev_trial.select('stimulus').values[0];
      console.log(feedback_img);
      var feedback = prev_trial.select('key_press').values[0];
      if (prev_trial.select('correct').values[0]){
        if (block=='structured_incentive' && num==chunk_rare[1]){
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

 // push trials
function pushTrials(set, num, block, chunk_rare, timeline){
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
      jsPsych.setProgressBar(curr_progress_bar_value + (1/560));
    }
  }
  timeline.push(trial);
  pushFeedback(num, block, chunk_rare, timeline);
  timeline.push(fixation);
};


function pushBlocks(timeline, set, condition, chunk_freq, chunk_rare){
  // i is the picture set to be used
  // condition tells us whether it is structured or random
  // chunk tells us the structure of the chunk
  if (condition=='random'){
    var probs = [1, 1, 1, 1];
    var mult = SJS.Multinomial(140, probs);
    var stateDist = mult.draw();
    stateDist = stateDist.concat([0, 0]);
  }
  else{
    var mult_primitive = SJS.Multinomial(140, [1, 1, 1, 1]);
    var stateDist_primitive = mult_primitive.draw();
    var mult_chunk_transition = SJS.Multinomial(35, [4, 1]);
    var stateDist_chunk_transition = mult_chunk_transition.draw();
    var stateDist = [35,35,35,35].concat(stateDist_chunk_transition);
    stateDist[chunk_freq[0]-1] = 0;
    stateDist[chunk_freq[1]-1] = 35 - stateDist_chunk_transition[0];
    stateDist[chunk_rare[1]-1] = 35 - stateDist_chunk_transition[1];
  }

  console.log(condition + ":" + stateDist);
  var randomizedTrials = jsPsych.randomization.repeat([1,2,3,4,7,8], stateDist);
  for (let i=0; i<randomizedTrials.length; i++){
    num = randomizedTrials[i];
    if (num < 7){
      pushTrials(set, num, condition, chunk_rare, timeline);
    }
    else if (num == 7){
      pushTrials(set, chunk_freq[0], condition, chunk_rare, timeline);
      pushTrials(set, chunk_freq[1], condition, chunk_rare, timeline); 
    }
    else if (num == 8){
      pushTrials(set, chunk_rare[0], condition, chunk_rare, timeline);
      pushTrials(set, chunk_rare[1], condition, chunk_rare, timeline); 
    }
  }
  return stateDist;
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

function find_outChunk(chunk){
  if (chunk[0]==2 && chunk[1]==4){
    return [1,3]; 
  }
  else if (chunk[0]==1 && chunk[1]==4){
    return [3,2];
  }
  else if (chunk[0]==4 && chunk[1]==3){
    return [2,1];
  }
}


function startExperiment(){
    //console.log("Timeline: " + JSON.stringify(timeline));
    jsPsych.init({
      timeline: timeline,
      show_progress_bar: true,
      auto_update_progress_bar: false,
    })
  };

//define redirect link for qualtrics and add turk variables
var urlVar = jsPsych.data.urlVariables();
var turkInfo = jsPsych.turk.turkInfo();

// add mturk info to data csv

jsPsych.data.addProperties({
assignmentID: turkInfo.assignmentId
});

jsPsych.data.addProperties({
mturkID: turkInfo.workerId
});

jsPsych.data.addProperties({
hitID: turkInfo.hitId
});

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
function create_bonus_page(freq_order, stateDist){
  var bonus_block = {
    type: 'instructions',
    pages: function() {
      var correct_bonus = Math.round(60 * jsPsych.data.get().filter({correct: true}).count() / 480); 
      correct_bonus = 0.1 * correct_bonus + bonus_freq_discr(freq_order, stateDist);
      jsPsych.data.addDataToLastTrial({"bonus": correct_bonus});
      return ['<p class="center-content">You won a bonus of <b>$' + (correct_bonus == 1 ? '9.00' : correct_bonus) + '</b>.</p>' +
      '<p class="center-content"> IMPORTANT: <b>Press "Next"</b> to continue to the survey questions.</p>'];
    },
    show_clickable_nav: true,
    on_finish: function(data){
      jsPsych.setProgressBar(1);
    }
  };
  return bonus_block;
}


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
      saveData(subject_id, jsPsych.data.get().csv());
      },
  }


// end block
 var end_block = {
    type: 'instructions',
    pages: [
    '<p class="center-content"> <b>Thank you for participating in our experiment!</b></p>' +
    '<p class="center-content"> <b>Please wait on this page for a minute while your data saves.</b></p>'+
    '<p class="center-content"> Your bonus will be applied after your data (including the survey) has been processed and your HIT has been approved. YOU MUST DO THE SURVEY TO BE PAID.</p>'+
    '<p class="center-content"> Please email zixiang.huang@mail.mcgill.ca with any additional questions or concerns. Please click "Next"; You will be redirected to the survey shortly.</p>'
    ],
    show_clickable_nav: true,
    allow_backward: false,
    show_page_number: false,
    on_finish: function(data) {
    window.location.href = "https://harvard.az1.qualtrics.com/jfe/form/SV_0kwdhI6iH5OSrBA/?&workerId=" + turkInfo.workerId + "&assignmentId=" + turkInfo.assignmentId + "&hitId=" + turkInfo.hitId;
     },
                       
  };
