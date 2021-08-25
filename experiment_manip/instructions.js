var instructions = {
  type: 'instructions',
  pages: [
    // Welcome (page 1)
    '<p class="center-content">Welcome to the experiment!</p>' +
    '<p class="center-content">You will earn $6 plus a performance-dependent bonus of $0-10 for completing this HIT.</p>' +
    '<p class="center-content">Press "Next" to view the instructions.</p>',

    // Instructions (page 2)
    '<p class="center-content">Imagine you are a photographer, trying to capture the beauty in every sparking moment you see. </p>' +
    '<p class="center-content">Each time you take a picture, you will decide which buttons to press on the camera</p>' +
    '<p class="center-content">to adjust the parameters and create the best photo.  </p>',

    // Instructions (page 3)
    '<p class="center-content">In this experiment, you will learn which key to press in response to each picture that appears on the screen.  </p>' +
    '<p class="center-content">You want to press the correct key as fast as possible, to capture the fleeting moment that would give the best picture.  </p>' +
    '<p class="center-content"><b>You will obtain monetary reward based on both how accurate and how fast your responses are. </b> </p>' ,

    '<p class="center-content">Each time you see a picture, </p>' +
    '<p class="center-content">you should decide which one of <b>[S]</b>, <b>[D]</b>, <b>[H]</b>, <b>[J]</b>  to press before the picture disappears.</p>' +
    '<p class="center-content">Please use the following fingers to press the corresponding keys.  </p>'+
    '<img src="img/fingerPosition.png" style="width: 600px;">',


    '<p class="center-content">This experiment is consisted of 4 blocks, with 120 trials in each block. </p>' +
    '<p class="center-content">Different blocks will present different set of pictures. </p>' +
    '<p class="center-content">You may see block-specific instructions at the beginning of each block. </p>', 

    '<p class="center-content">You will only see each picture for a very short time, so please make a decision as fast as you can.</p>'+
    '<p class="center-content">An orange border will appear after you press the correct key. </p>'+
    '<p class="center-content">A monetary reward will be assigned to you every time you press the correct key. </p>'+
    '<table style="margin-left:auto;margin-right:auto;table-layout:fixed !important; width:650px;"><tr>' +
    '<td><img src="img/sample_picture.png" width="240" style="border:12px solid orange"></td>' +
    '<td><img src="img/sample_picture.png" style="width: 240px; "></td>' +
    '</tr><tr>' +
    '<td>Orange border-></td><td>No border-></td>' +
    '<table style="margin-left:auto;margin-right:auto;table-layout:fixed !important; width:650px;"><tr>' +
    '<td>Correct response</td><td>Incorrect response</td>' +
    '</tr></table>'+
    '</tr></table>',


    '<p class="center-content">Please try your best to make the best response for each picture. We really appreciate your hard work! </p>' +
    '<p class="center-content"><b>Please note that if you respond randomly, always press the same key, or never press, we reserve the right to withold your bonus.</b></p>'+
    '<p class="center-content">Please click "Next" to enter the first experimental block.</p>'
  ],
  show_clickable_nav: true,
  allow_backward: true,
  show_page_number: true
};


var instructions_noBlockSpecific = {
  type: 'instructions',
  pages: [
  '<p class="center-content">There is no block-specific rule associated with the upcoming block. </p>' +
  '<p class="center-content">Please try your best to answer as fast and accurately as possible to obtain more performance-based bonus. </p>' +
  '<p class="center-content">Please click "Next" to start.</p>',
  ],
  show_clickable_nav: true,
  allow_backward: true,
  show_page_number: true

}


function present_pictures(set_num){
  var num_order = [1, 2, 3, 4];
  num_order = shuffle(num_order);
  var instructions = {
    type: 'instructions',
    pages: [
      '<p class="center-content">In this block, you will see the following four pictures. </p>' +
      '<p class="center-content">The correct response to each picture will be learned during the task. </p>'+   
      '<p class="center-content">Note that it is possible that two of the pictures have the same correct response.</p>'+
      '<table style="margin-left:auto;margin-right:auto;table-layout:fixed !important; width:1000px;"><tr>' +
      '<td><img src="img/set' +set_num+ '/S' +num_order[0]+ '.jpg" style="width: 220px; height: 150px"></td>' +
      '<td><img src="img/set' +set_num+ '/S' +num_order[1]+ '.jpg" style="width: 220px; height: 150px"></td>' +
      '<td><img src="img/set' +set_num+ '/S' +num_order[2]+ '.jpg" style="width: 220px; height: 150px"></td>' +
      '<td><img src="img/set' +set_num+ '/S' +num_order[3]+ '.jpg" style="width: 220px; height: 150px"></td>' +
      '</tr><tr>' +
      '</tr></table>'
    ],
    show_clickable_nav: true,
    allow_backward: true,
    show_page_number: true
  }
  return instructions;
}


function create_incentive_instructions(set_num, chunk, exoChunk){
  var instructions = {
  type: 'instructions',
  pages: [
  '<p class="center-content">This block is associated with block-specific rules. </p>' + 
  '<p class="center-content"><b>In this block, correctly responding to the picture below will be 5 times more rewarding than to other pictures.</b> </p>' +
  '<table style="margin-left:auto;margin-right:auto;table-layout:fixed !important; width:300px;"><tr>' +
  '<td><img src="img/set' +set_num+ '/S' +chunk[1]+ '.jpg" style="width: 300px; height: 210px"></td>' +
  '</tr><tr>' +
  '</tr></table>', 

  '<p class="center-content">A violet border will appear after you press the correct key for the chosen picture.</p>'+
  '<table style="margin-left:auto;margin-right:auto;table-layout:fixed !important; width:650px;"><tr>' +
  '<td><img src="img/set' +set_num+ '/S' +chunk[1]+ '.jpg" width="240" height="160" style="border:14px solid Violet"></td>' +
  '<td><img src="img/set' +set_num+ '/S' +exoChunk[1]+ '.jpg" width="240" height="160" style="border:14px solid orange"></td>' +
  '</tr><tr>' +
  '<td>Violet border-></td><td>Orange border-></td>' +
  '<table style="margin-left:auto;margin-right:auto;table-layout:fixed !important; width:650px;"><tr>' +
  '<td>5x more monetary bonus</td><td>Normal monetary bonus</td>' +
  '</tr></table>'+
  '</tr></table>'+
  '<p class="center-content">Please click "Next" to start the block.</p>'
  ],
  show_clickable_nav: true,
  allow_backward: true,
  show_page_number: true
  }
  return instructions;
}


function create_load_instructions(set_num){
  var instructions = {
  type: 'instructions',
  pages: [
    '<p class="center-content">This block is associated with block-specific rules. </p>'+
    '<p class="center-content">During this block, you will see numbers from 1-10 below the picture 30% of the time.</p>'+
    '<p class="center-content"><b>Please perform addition on these numbers and keep track of a running sum. </b> </p>' +
    '<p class="center-content"><b>At the end of the block, you will be asked to enter the sum of all numbers you have seen during the block.</b> </p>' +
    '<p class="center-content"><b>You will obtain a monetary bonus of $2 upon entering the correct number.</b> </p>',
   
    '<p class="center-content">You will still need to respond as fast and accurately as possible to obtain more performance-based bonus.  </p>' +
    '<p class="center-content">Please click "Next" to start.</p>',
    ],
  show_clickable_nav: true,
  allow_backward: true,
  show_page_number: true
  }
return instructions;

}



