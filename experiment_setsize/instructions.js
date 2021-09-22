var instructions_block_animal_part1 = {
  type: 'instructions',
  pages: [
    // Welcome (page 1)
    '<p class="center-content">Welcome to the experiment!</p>' +
    '<p class="center-content">You will earn $6 plus a performance-dependent bonus of $0-10 for completing this HIT.</p>' +
    '<p class="center-content">This experiment consists of two parts. </p>'+
    '<p class="center-content">Press "Next" to view the task instructions for the first part.</p>',

    // Instructions (page 2)
    '<p class="center-content">Imagine you are a photographer visiting a safari park, you see animals of different species, </p>' +
    '<p class="center-content">yet you have to decide which parameters to adjust and which buttons to press on a camera to </p>' +
    '<p class="center-content">capture the unique beauty of each animal. </p>',

    // Instructions (page 3)
    '<p class="center-content">In this experiment, you will learn which key to press in response to each animal picture that appears on the screen.  </p>' +
    '<p class="center-content">You want to press the correct key as fast as possible, to capture the fleeting moment that would give the best picture.  </p>' +
    '<p class="center-content"><b>You will obtain monetary reward based on both how accurate and how fast your responses are. </b> </p>' ,

    '<p class="center-content">Each time you see an animal picture, </p>' +
    '<p class="center-content">you should decide which one of <b>[1]</b>, <b>[2]</b>, <b>[3]</b>, <b>[4]</b>, <b>[5]</b>, <b>[6]</b>  to press before the picture disappears.</p>' +
    '<p class="center-content">Please use the following fingers to press the corresponding keys.  </p>'+
    '<img src="img/fingerPos_Ns6.png" style="width: 600px;">',

    '<p class="center-content">Here are the animal pictures you will see in the upcoming experimental block. </p>' +
    '<p class="center-content">The correct response to each animal picture will be learned during the experiment. </p>'+   
    '<p class="center-content">Note that it is possible that more than one of the animal pictures correspond to the same response.</p>'+
    '<table style="margin-left:auto;margin-right:auto;table-layout:fixed !important; width:800px;"><tr>' +
    '<td><img src="img/animals/control/S3.jpg" style="width: 220px; height: 150px"></td>' +
    '<td><img src="img/animals/control/S4.jpg" style="width: 220px; height: 150px"></td>' +
    '<td><img src="img/animals/control/S6.jpg" style="width: 220px; height: 150px"></td>' +
    '</tr><tr>' +
    '</tr></table>'+
    '<table style="margin-left:auto;margin-right:auto;table-layout:fixed !important; width:800px;"><tr>' +
    '<td><img src="img/animals/control/S2.jpg" style="width: 220px; height: 150px"></td>' +
    '<td><img src="img/animals/control/S1.jpg" style="width: 220px; height: 150px"></td>' +
    '<td><img src="img/animals/control/S5.jpg" style="width: 220px; height: 150px"></td>' +
    '</tr><tr>' +
    '</tr></table>',

    //Instructions (page 6)
    '<p class="center-content">This part of the experiment has 4 blocks of 90-120 trials each.</p>' +
    '<p class="center-content">After completing the 1st block, we will offer you a break. </p>' +
    '<p class="center-content">You will see a different set of animal pictures for the 2nd, 3rd, and 4th block. </p>',


    '<p class="center-content">You will only see each animal picture for a very short time, so please make a decision as fast as you can.</p>'+
    '<p class="center-content">An orange border will appear after you press the correct key. </p>'+
    '<p class="center-content">You will learn the correct response to each animal picture from this feedback signal.</p>'+
    '<table style="margin-left:auto;margin-right:auto;table-layout:fixed !important; width:650px;"><tr>' +
    '<td><img src="img/animals/control/S2.jpg" width="240" style="border:12px solid orange"></td>' +
    '<td><img src="img/animals/control/S2.jpg" style="width: 240px; "></td>' +
    '</tr><tr>' +
    '<td>Orange border-></td><td>No border-></td>' +
    '<table style="margin-left:auto;margin-right:auto;table-layout:fixed !important; width:650px;"><tr>' +
    '<td>Correct response</td><td>Incorrect response</td>' +
    '</tr></table>'+
    '</tr></table>',

    '<p class="center-content">Please try your best to make the best response for each picture. We really appreciate your hard work! </p>' +
    '<p class="center-content"><b>Please note that if you respond randomly, always press the same key, or never press, we reserve the right to withold your bonus.</b></p>'+
    '<p class="center-content">Please click "Next" to start the experiment.</p>',
  ],
  show_clickable_nav: true,
  allow_backward: true,
  show_page_number: true
};

var instructions_block_animal_part2 = {
  type: 'instructions',
  pages: [
    '<p class="center-content">In the second part of the experiment, imagine you are a photographer visiting a safari park. </p>' +
    '<p class="center-content">You will learn which key to press in response to each animal picture that appears on the screen.  </p>',

    '<p class="center-content">Each time you see an animal picture, </p>' +
    '<p class="center-content">you should decide which one of <b>[1]</b>, <b>[2]</b>, <b>[3]</b>, <b>[4]</b>, <b>[5]</b>, <b>[6]</b>  to press before the picture disappears.</p>' +
    '<p class="center-content">Please use the following fingers to press the corresponding keys.  </p>'+
    '<img src="img/fingerPos_Ns6.png" style="width: 600px;">',

    // Instructions (page 4)
    '<p class="center-content">Here are the animal pictures you will see in the upcoming block. </p>' +
    '<p class="center-content">The correct response to each animal picture will be learned during the experiment. </p>'+
    '<table style="margin-left:auto;margin-right:auto;table-layout:fixed !important; width:800px;"><tr>' +
    '<td><img src="img/animals/control/S3.jpg" style="width: 220px;"></td>' +
    '<td><img src="img/animals/control/S1.jpg" style="width: 220px; "></td>' +
    '<td><img src="img/animals/control/S6.jpg" style="width: 220px; "></td>' +
    '</tr><tr>' +
    '</tr></table>'+
    '<table style="margin-left:auto;margin-right:auto;table-layout:fixed !important; width:800px;"><tr>' +
    '<td><img src="img/animals/control/S4.jpg" style="width: 220px; "></td>' +
    '<td><img src="img/animals/control/S5.jpg" style="width: 220px;"></td>' +
    '<td><img src="img/animals/control/S2.jpg" style="width: 220px; "></td>' +
    '</tr><tr>' +
    '</tr></table>',

    //Instructions (page 6)
    '<p class="center-content">This part of the experiment has 4 blocks of 90-120 trials each.</p>' +
    '<p class="center-content">After completing the 1st block, we will offer you a break. </p>' +
    '<p class="center-content">You will see a different set of animal pictures in the 2nd, 3rd, and 4th block.</p>' +  
    '<p class="center-content">Please click "Next" to start the experiment.</p>'
  ],
  show_clickable_nav: true,
  allow_backward: true,
  show_page_number: true
}; 



var instructions_block_nature_part1 = {
  type: 'instructions',
  pages: [
    // Welcome (page 1)
    '<p class="center-content">Welcome to the experiment!</p>' +
    '<p class="center-content">You will earn $6 plus a performance-dependent bonus of $0-10 for completing this HIT.</p>' +
    '<p class="center-content">This experiment consists of two parts. </p>'+
    '<p class="center-content">Press "Next" to view the task instructions for the first part.</p>',
  
    // Instructions (page 2)
    '<p class="center-content">Imagine you are a photographer travelling around the world, </p>' +
    '<p class="center-content">you are amazed by the magnificance of different landscapes, </p>' +
    '<p class="center-content">yet you have to decide which parameters to adjust and which buttons to press on a camera to capture their unique beauty.</p>',


    '<p class="center-content">In this experiment, you will learn which key to press in response to each natural scene that appears on the screen.  </p>' +
    '<p class="center-content">You want to press the correct key as fast as possible, to capture the fleeting moment that would give the best picture.  </p>' +
    '<p class="center-content"><b>You will obtain monetary reward based on both how accurate and how fast your responses are. </b> </p>' ,

    '<p class="center-content">Each time you see a natural scene image, </p>' +
    '<p class="center-content">you should decide which one of <b>[1]</b>, <b>[2]</b>, <b>[3]</b>, <b>[4]</b> to press before the image disappears.</p>' +
    '<p class="center-content">Please use the following fingers to press the corresponding keys.  </p>'+
    '<img src="img/fingerPos_Ns4.png" style="width: 600px;">',

    // Instructions (page 4)
    '<p class="center-content">Here are the natural scenes you will see during the experiment. </p>' +
    '<p class="center-content">The correct response to each natural scene will be learned during the experiment.</p>'+
    '<p class="center-content">Note that it is possible that two of the natural scenes correspond to the same response,</p>'+
    '<p class="center-content">and one of the numeric key among <b>[1]</b>, <b>[2]</b>, <b>[3]</b>, <b>[4]</b> may be unused.</p>'+
    '<table style="margin-left:auto;margin-right:auto;table-layout:fixed !important; width:1100px;"><tr>' +
    '<td><img src="img/nature/control/S3.jpg" style="width: 250px; height:170px"></td>' +
    '<td><img src="img/nature/control/S1.jpg" style="width: 250px; height:170px"></td>' +
    '<td><img src="img/nature/control/S4.jpg" style="width: 250px; height:170px"></td>' +
    '<td><img src="img/nature/control/S2.jpg" style="width: 250px; height:170px"></td>' +
    '</tr><tr>' +
    '</tr></table>',


    //Instructions (page 6)
     '<p class="center-content">This part of the experiment has 4 blocks of 60-80 trials each.</p>' +
    '<p class="center-content">After completing the 1st block, we will offer you a break. </p>' +
    '<p class="center-content">You will see a different set of animal pictures in the 2nd, 3rd, and 4th block.</p>',

    '<p class="center-content">You will only see each picture for a very short time, so please make a decision as fast as you can.</p>'+
    '<p class="center-content">An orange border will appear after you press the correct key. </p>'+
    '<p class="center-content">You will learn the correct response to each natural scence from this feedback signal.</p>'+
    '<table style="margin-left:auto;margin-right:auto;table-layout:fixed !important; width:650px;"><tr>' +
    '<td><img src="img/nature/control/S2.jpg" width="240" style="border:12px solid orange"></td>' +
    '<td><img src="img/nature/control/S2.jpg" style="width: 240px; "></td>' +
    '</tr><tr>' +
    '<td>Orange border-></td><td>No border-></td>' +
    '<table style="margin-left:auto;margin-right:auto;table-layout:fixed !important; width:650px;"><tr>' +
    '<td>Correct response</td><td>Incorrect response</td>' +
    '</tr></table>'+
    '</tr></table>',

    '<p class="center-content">Please try your best to make the best response for each picture. We really appreciate your hard work! </p>' +
    '<p class="center-content"><b>Please note that if you respond randomly, always press the same key, or never press, we reserve the right to withold your bonus.</b></p>',
  ],
  show_clickable_nav: true,
  allow_backward: true,
  show_page_number: true
};


var instructions_block_nature_part2 = {
  type: 'instructions',
  pages: [
    '<p class="center-content">In the second part of the experiment, imagine you are a photographer travelling around the world. </p>' +
    '<p class="center-content">You will learn which key to press in response to each natural scene that appears on the screen.  </p>',

    '<p class="center-content">Each time you see a natural scene image, </p>' +
    '<p class="center-content">you should decide which one of <b>[1]</b>, <b>[2]</b>, <b>[3]</b>, <b>[4]</b> to press before the image disappears.</p>' +
    '<p class="center-content">Please use the following fingers to press the corresponding keys.  </p>'+
    '<img src="img/fingerPos_Ns4.png" style="width: 600px;">',

    // Instructions (page 4)
    '<p class="center-content">Here are the natural scenes you will see during the experiment. </p>' +
    '<p class="center-content">The correct response to each image will be learned during the experiment.</p>'+
    '<table style="margin-left:auto;margin-right:auto;table-layout:fixed !important; width:1100px;"><tr>' +
    '<td><img src="img/nature/control/S3.jpg" style="width: 250px; height:170px"></td>' +
    '<td><img src="img/nature/control/S1.jpg" style="width: 250px; height:170px"></td>' +
    '<td><img src="img/nature/control/S4.jpg" style="width: 250px; height:170px"></td>' +
    '<td><img src="img/nature/control/S2.jpg" style="width: 250px; height:170px"></td>' +
    '</tr><tr>' +
    '</tr></table>',

    //Instructions (page 6)
    '<p class="center-content">This part of the experiment has 4 blocks of 60-80 trials each. </p>' +
    '<p class="center-content">After completing the 1st block, we will offer you a break. </p>' +
    '<p class="center-content">You will see a different set of natural images in the 2nd, 3rd, and 4th block.</p>'+   
    '<p class="center-content">Please click "Next" to begin the experiment.</p>'
  ],
  show_clickable_nav: true,
  allow_backward: true,
  show_page_number: true
}; 




function create_instructions_part1(condition) {
  switch(condition){
    case 'animal':
      return instructions_block_animal_part1; break;
    case 'nature':
      return instructions_block_nature_part1; break;
  }
  console.log("Creating instructions block!");
};

function create_instructions_part2(condition) {
  switch(condition){
    case 'animal':
      return instructions_block_animal_part2; break;
    case 'nature':
      return instructions_block_nature_part2; break;
  }
  console.log("Creating instructions block!");
};