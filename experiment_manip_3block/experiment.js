// Chunking as Policy Compression in Stimulus-Response Task
var label = ['random', 'structured_normal', 'structured_incentive'];
label = shuffle(label);
console.log(label);

var freq_chunk_structures = [[2,3], [1,2]];
shuffle(freq_chunk_structures);

var rare_chunk_structures = [];
for (let i=0; i<freq_chunk_structures.length; i++){
  chunk = freq_chunk_structures[i];
  if (chunk[0]==2 && chunk[1]==3){
    rare_chunk_structures.push([2,4]);
  }
  else if (chunk[0]==1 && chunk[1]==2){
    rare_chunk_structures.push([1,3]);
  }
}


console.log("Frequent chunk transition: " + freq_chunk_structures);
console.log("Rare chunk transition: " + rare_chunk_structures);

for (var i=1; i<label.length+1; i++){
  var path = 'img/set';
  window['stimulus_set'+i] = [
    { stimulus: path.concat(i.toString(), '/S1.jpg'), data:{state:1, test_part:label[i-1], correct_response:83, order_block:label, order_chunk: freq_chunk_structures} },
    { stimulus: path.concat(i.toString(), '/S2.jpg'), data:{state:2, test_part:label[i-1], correct_response:68, order_block:label, order_chunk: freq_chunk_structures} },
    { stimulus: path.concat(i.toString(), '/S3.jpg'), data:{state:3, test_part:label[i-1], correct_response:72, order_block:label, order_chunk: freq_chunk_structures} },
    { stimulus: path.concat(i.toString(), '/S4.jpg'), data:{state:4, test_part:label[i-1], correct_response:74, order_block:label, order_chunk: freq_chunk_structures} } ]; 
}


var timeline = [];


//Obtain consent 
var consent_block = create_consent();
timeline.push(consent_block); 


var trial_node_id = '';
var structured_idx = 0;
var stateDist = [0, 0, 0, 0, 0];
timeline.push(instructions);
for (let i=1; i<4; i++){
  timeline.push(present_pictures(i));
  if (label[i-1]=='structured_incentive'){
    var chunk_freq = freq_chunk_structures[structured_idx];
    var chunk_rare = rare_chunk_structures[structured_idx];
    structured_idx = structured_idx + 1;
    var outChunk = find_outChunk(chunk_rare);
    timeline.push(create_incentive_instructions(i, chunk_rare, outChunk));
    pushBlocks(timeline, i, label[i-1], chunk_freq, chunk_rare);
  }
  else if (label[i-1]=='structured_normal'){
    var chunk_freq = freq_chunk_structures[structured_idx];
    var chunk_rare = rare_chunk_structures[structured_idx];
    structured_idx = structured_idx + 1;
    timeline.push(instructions_noBlockSpecific);
    pushBlocks(timeline, i, label[i-1], chunk_freq, chunk_rare);
  }
  else if (label[i-1]=='random'){
    var chunk_freq = [0, 0];
    var chunk_rare = [0, 0];
    timeline.push(instructions_noBlockSpecific);
    pushBlocks(timeline, i, label[i-1], chunk_freq, chunk_rare);
  }
  timeline.push(between_block);
} 

timeline.push(create_bonus_page());
timeline.push(survey_comments);
timeline.push(save_data);
timeline.push(end_block);

images = ['img/set1/S1.jpg', 'img/set1/S2.jpg', 'img/set1/S3.jpg', 'img/set1/S4.jpg',
          'img/set2/S1.jpg', 'img/set2/S2.jpg', 'img/set2/S3.jpg', 'img/set2/S4.jpg',
          'img/set3/S1.jpg', 'img/set3/S2.jpg', 'img/set3/S3.jpg', 'img/set3/S4.jpg',
          'img/fingerPosition.png', 'img/sample_picture.png'];

jsPsych.pluginAPI.preloadImages(images, function () {startExperiment();});
console.log("Images preloaded.");


