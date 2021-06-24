// Chunking as Policy Compression in Stimulus-Response Task

var stimuli = ['img/nature/S1.jpg', 'img/nature/S2.jpg', 'img/nature/S3.jpg', 'img/nature/S4.jpg',
              'img/animals/S1.jpg', 'img/animals/S2.jpg','img/animals/S3.jpg',
              'img/animals/S4.jpg','img/animals/S5.jpg', 'img/animals/S6.jpg','img/fingerPos_Ns4.png', 'img/fingerPos_Ns6.png'];


var stateDist_n4 = [3, 3, 25, 25, 22];
var stateDist_n6 = [25, 25, 25, 3, 3, 25, 22];
var timeline = [];

//Obtain consent 
var consent_block = create_consent();
timeline.push(consent_block);

var trial_node_id = '';
var random = Math.random();
console.log(random);
if (random < 0.5){
  // Instructions, Ns=6
  var instructions_block = create_instructions_part1('animal');
  timeline.push(instructions_block);

  // Practice, Ns=6
  var practice_block_Ns6 = create_practice(6);
  var finish_practice = finish_practice();
  timeline.push(practice_block_Ns6);
  timeline.push(finish_practice);

  // Experiment, Ns=6
  baseline_block(timeline, 'Ns6');
  timeline.push(between_block);
  //console.log('First random block created.');
  train_block(timeline, 'Ns6', stateDist_n6);
  timeline.push(between_block);
  test_block(timeline, 'Ns6');
  timeline.push(between_block_beforePractice);

  // Instructions, Ns=4
  var instructions_block = create_instructions_part2('nature');
  timeline.push(instructions_block);

  // Practice, Ns=4
  var practice_block_Ns4 = create_practice(4);
  timeline.push(practice_block_Ns4);
  timeline.push(finish_practice);

  // Experiment, Ns=4
  baseline_block(timeline, 'Ns4');
  timeline.push(between_block);
  train_block(timeline, 'Ns4', stateDist_n4);
  timeline.push(between_block);
  test_block(timeline, 'Ns4');
}
else{
  // Instructions, Ns=4
  var instructions_block = create_instructions_part1('nature');
  timeline.push(instructions_block);

  // Practice, Ns=4
  var practice_block_Ns4 = create_practice(4);
  var finish_practice = finish_practice();
  timeline.push(practice_block_Ns4);
  timeline.push(finish_practice);

  var trial_node_id = '';

  // Experiment, Ns=4
  baseline_block(timeline, 'Ns4');
  timeline.push(between_block);
  train_block(timeline, 'Ns4', stateDist_n4);
  timeline.push(between_block);
  test_block(timeline, 'Ns4');
  timeline.push(between_block_beforePractice);

  // Instructions, Ns=6
  var instructions_block = create_instructions_part2('animal');
  timeline.push(instructions_block);

  // Practice, Ns=6
  var practice_block_Ns6 = create_practice(6);
  timeline.push(practice_block_Ns6);
  timeline.push(finish_practice);

  // Experiment, Ns=6
  baseline_block(timeline, 'Ns6');
  timeline.push(between_block);
  train_block(timeline, 'Ns6', stateDist_n6);
  timeline.push(between_block);
  test_block(timeline, 'Ns6');
}


timeline.push(bonus_block);
timeline.push(survey_comments);
timeline.push(save_data);
timeline.push(end_block);


function startExperiment(){
    console.log("Timeline: " + JSON.stringify(timeline));
    jsPsych.init({
      timeline: timeline,
      show_progress_bar: true,
      auto_update_progress_bar: false,
      //on_finish: function() {
        //window.location.href = "end.html";
      //}
    })
  };

  images = ['img/nature/S1.jpg', 'img/nature/S2.jpg', 'img/nature/S3.jpg',
              'img/animals/S1.jpg', 'img/animals/S2.jpg','img/animals/S3.jpg','img/animals/S4.jpg','img/animals/S5.jpg', 
              'img/fingerPos_Ns4.png', 'img/fingerPos_Ns6.png'].concat(stimuli);

  jsPsych.pluginAPI.preloadImages(images, function () {startExperiment();});
  console.log("Images preloaded.");


