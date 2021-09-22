// Chunking as Policy Compression in Stimulus-Response Task

var stimuli = ['img/nature/S1.jpg', 'img/nature/S2.jpg', 'img/nature/S3.jpg', 'img/nature/S4.jpg',
              'img/animals/S1.jpg', 'img/animals/S2.jpg','img/animals/S3.jpg',
              'img/animals/S4.jpg','img/animals/S5.jpg', 'img/animals/S6.jpg','img/fingerPos_Ns4.png', 'img/fingerPos_Ns6.png',
              'img/animals/control/S1.jpg', 'img/animals/control/S2.jpg', 'img/animals/control/S3.jpg',
              'img/animals/control/S4.jpg', 'img/animals/control/S5.jpg','img/animals/control/S6.jpg',
              'img/nature/control/S1.jpg', 'img/nature/control/S2.jpg', 'img/nature/control/S3.jpg', 'img/nature/control/S4.jpg'];


var stateDist_n4 = [0, 0, 20, 20, 20];
var stateDist_n6 = [20, 20, 20, 0, 0, 20, 20];
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

  // baseline, Ns=6
  var baseline_block_Ns6 = create_baseline(6);
  var finish_baseline = finish_baseline();
  timeline.push(baseline_block_Ns6);
  timeline.push(finish_baseline);

  // Experiment, Ns=6
  // change to a different set of pictures
  timeline.push(changePictureSet_animal);
  experimentalBlocks(timeline, 'Ns6');
  timeline.push(between_block_beforebaseline);

  // Instructions, Ns=4
  var instructions_block = create_instructions_part2('nature');
  timeline.push(instructions_block);

  // baseline, Ns=4
  var baseline_block_Ns4 = create_baseline(4);
  timeline.push(baseline_block_Ns4);
  timeline.push(finish_baseline);

  // Experiment, Ns=4
  // change to a different set of pictures
  timeline.push(changePictureSet_nature);
  experimentalBlocks(timeline, 'Ns4');
}
else{
  // Instructions, Ns=4
  var instructions_block = create_instructions_part1('nature');
  timeline.push(instructions_block);

  // baseline, Ns=4
  var baseline_block_Ns4 = create_baseline(4);
  var finish_baseline = finish_baseline();
  timeline.push(baseline_block_Ns4);
  timeline.push(finish_baseline);

  var trial_node_id = '';

  // Experiment, Ns=4
  // change to a different set of pictures
  timeline.push(changePictureSet_nature);
  experimentalBlocks(timeline, 'Ns4');
  timeline.push(between_block_beforebaseline);

  // Instructions, Ns=6
  var instructions_block = create_instructions_part2('animal');
  timeline.push(instructions_block);

  // baseline, Ns=6
  var baseline_block_Ns6 = create_baseline(6);
  timeline.push(baseline_block_Ns6);
  timeline.push(finish_baseline);

  // Experiment, Ns=6
  // change to a different set of pictures
  timeline.push(changePictureSet_animal);
  experimentalBlocks(timeline, 'Ns6');
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
              'img/fingerPos_Ns4.png', 'img/fingerPos_Ns6.png',
               'img/animals/control/S1.jpg', 'img/animals/control/S2.jpg', 'img/animals/control/S3.jpg',
              'img/animals/control/S4.jpg', 'img/animals/control/S5.jpg','img/animals/control/S6.jpg',
              'img/nature/control/S1.jpg', 'img/nature/control/S2.jpg', 'img/nature/control/S3.jpg', 'img/nature/control/S4.jpg'].concat(stimuli);

  jsPsych.pluginAPI.preloadImages(images, function () {startExperiment();});
  console.log("Images preloaded.");


