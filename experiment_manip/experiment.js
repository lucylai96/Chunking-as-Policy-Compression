// Chunking as Policy Compression in Stimulus-Response Task
var label = ['structured_normal', 'structured_load', 'structured_incentive'];
label = shuffle(label);
label = ['random'].concat(label);
console.log(label);

var chunk_structure = [[2,1], [3,4], [2,3]];
chunk_strucure = shuffle(chunk_structure);

for (var i=1; i<label.length+1; i++){
  var path = 'img/set';
  window['stimulus_set'+i] = [
    { stimulus: path.concat(i.toString(), '/S1.jpg'), data:{state:1, test_part:label[i-1], correct_response:83, order_block:label, order_chunk: chunk_structure} },
    { stimulus: path.concat(i.toString(), '/S2.jpg'), data:{state:2, test_part:label[i-1], correct_response:68, order_block:label, order_chunk: chunk_structure} },
    { stimulus: path.concat(i.toString(), '/S3.jpg'), data:{state:3, test_part:label[i-1], correct_response:72, order_block:label, order_chunk: chunk_structure} },
    { stimulus: path.concat(i.toString(), '/S4.jpg'), data:{state:4, test_part:label[i-1], correct_response:74, order_block:label, order_chunk: chunk_structure} } ]; 
}


var timeline = [];
//timeline.push(create_load_instructions(1));

//Obtain consent 
var consent_block = create_consent();
timeline.push(consent_block); 


var trial_node_id = '';
var structured_idx = 0;
timeline.push(instructions);
for (let i=1; i<5; i++){
  console.log(i);
  timeline.push(present_pictures(i));
  if (label[i-1]=='structured_incentive'){
    var chunk = chunk_structure[structured_idx];
    var exoChunk = find_exoChunk(chunk);
    console.log(chunk);
    console.log(exoChunk);
    structured_idx = structured_idx + 1;
    timeline.push(create_incentive_instructions(i, chunk, exoChunk));
    pushBlocks(timeline, i, label[i-1], chunk);
  }
  else if (label[i-1]=='structured_load'){
    var chunk = chunk_structure[structured_idx];
    var exoChunk = find_exoChunk(chunk);
    structured_idx = structured_idx + 1;
    timeline.push(create_load_instructions(i, exoChunk));
    pushBlocks(timeline, i, label[i-1], chunk);
    timeline.push(survey_occurences);
  }
  else if (label[i-1]=='structured_normal'){
    var chunk = chunk_structure[structured_idx];
    structured_idx = structured_idx + 1;
    timeline.push(instructions_noBlockSpecific);
    pushBlocks(timeline, i, label[i-1], chunk);
  }
  else if (label[i-1]=='random'){
    var chunk = [0, 0];
    timeline.push(instructions_noBlockSpecific);
    pushBlocks(timeline, i, label[i-1], chunk);
  }
  timeline.push(between_block);
} 

timeline.push(bonus_block);
timeline.push(survey_comments);
timeline.push(save_data);
timeline.push(end_block);

images = ['img/set1/S1.jpg', 'img/set1/S2.jpg', 'img/set1/S3.jpg', 'img/set1/S4.jpg',
          'img/set2/S1.jpg', 'img/set2/S2.jpg', 'img/set2/S3.jpg', 'img/set2/S4.jpg',
          'img/set3/S1.jpg', 'img/set3/S2.jpg', 'img/set3/S3.jpg', 'img/set3/S4.jpg',
          'img/set4/S1.jpg', 'img/set4/S2.jpg', 'img/set4/S3.jpg', 'img/set4/S4.jpg', 
          'img/fingerPosition.png', 'img/sample_picture.png'];

jsPsych.pluginAPI.preloadImages(images, function () {startExperiment();});
console.log("Images preloaded.");


