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

    '<p class="center-content">Here are the animal pictures you will see during the experiment, </p>' +
    '<p class="center-content">and their correct responses indicated below. </p>'+
    '<table style="margin-left:auto;margin-right:auto;table-layout:fixed !important; width:800px;"><tr>' +
    '<td><img src="img/animals/S1.jpg" style="width: 220px;"></td>' +
    '<td><img src="img/animals/S2.jpg" style="width: 220px; "></td>' +
    '<td><img src="img/animals/S3.jpg" style="width: 220px; "></td>' +
    '</tr><tr>' +
    '<td>Press <b>[1]</b></td><td>Press <b>[2]</b></td><td>Press <b>[3]</b></td>' +
    '</tr></table>'+
    '<table style="margin-left:auto;margin-right:auto;table-layout:fixed !important; width:800px;"><tr>' +
    '<td><img src="img/animals/S4.jpg" style="width: 220px; "></td>' +
    '<td><img src="img/animals/S5.jpg" style="width: 220px;"></td>' +
    '<td><img src="img/animals/S6.jpg" style="width: 220px; "></td>' +
    '</tr><tr>' +
    '<td>Press <b>[4]</b></td><td>Press <b>[5]</b></td><td>Press <b>[6]</b></td>' +
    '</tr></table>',

    //Instructions (page 6)
    '<p class="center-content">This part of the experiment has 3 blocks (not including practice) of 150 trials each.</p>' +
    '<p class="center-content">You will only see each animal picture for a very short time, so please make a decision as fast as you can.</p>'+
    '<p class="center-content">After you press the key, the current picture will disappear, followed by the presentation of the next animal picture.</p>'+
    '<p class="center-content"><b>No feedback regarding whether you have pressed the correct key will be given during the experiment, </b></p>'+
    '<p class="center-content"><b>we will let you know the amount of monetary bonus you earn after finishing the experiment.</b></p>',

    '<p class="center-content">Please try your best to make the best response for each picture. We really appreciate your hard work! </p>' +
    '<p class="center-content"><b>Please note that if you respond randomly, always press the same key, or never press, we reserve the right to withold your bonus.</b></p>',
    // Instructions (page 6)
    '<p class="center-content">We will begin with a practice round for you to get used to the keys and animal pictures.</p>' +
    '<p class="center-content"In this practice round, an orange border will appear after you press the correct key to a picture. </p>'+
    '<p class="center-content">There will be 30 practice trials in total. </p>'+
    '<table style="margin-left:auto;margin-right:auto;table-layout:fixed !important; width:650px;"><tr>' +
    '<td><img src="img/animals/S2.jpg" width="240" style="border:12px solid orange"></td>' +
    '<td><img src="img/animals/S2.jpg" style="width: 240px; "></td>' +
    '</tr><tr>' +
    '<td>Orange border-></td><td>No border-></td>' +
    '<table style="margin-left:auto;margin-right:auto;table-layout:fixed !important; width:650px;"><tr>' +
    '<td>Correct response</td><td>Incorrect response</td>' +
    '</tr></table>'+
    '</tr></table>'
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

    // Instructions (page 4)
    '<p class="center-content">Here are the animal pictures you will see during the experiment, </p>' +
    '<p class="center-content">and their correct responses indicated below. </p>'+
    '<table style="margin-left:auto;margin-right:auto;table-layout:fixed !important; width:800px;"><tr>' +
    '<td><img src="img/animals/S1.jpg" style="width: 220px;"></td>' +
    '<td><img src="img/animals/S2.jpg" style="width: 220px; "></td>' +
    '<td><img src="img/animals/S3.jpg" style="width: 220px; "></td>' +
    '</tr><tr>' +
    '<td>Press <b>[1]</b></td><td>Press <b>[2]</b></td><td>Press <b>[3]</b></td>' +
    '</tr></table>'+
    '<table style="margin-left:auto;margin-right:auto;table-layout:fixed !important; width:800px;"><tr>' +
    '<td><img src="img/animals/S4.jpg" style="width: 220px; "></td>' +
    '<td><img src="img/animals/S5.jpg" style="width: 220px;"></td>' +
    '<td><img src="img/animals/S6.jpg" style="width: 220px; "></td>' +
    '</tr><tr>' +
    '<td>Press <b>[4]</b></td><td>Press <b>[5]</b></td><td>Press <b>[6]</b></td>' +
    '</tr></table>',

    //Instructions (page 6)
    '<p class="center-content">This part of the experiment has 3 blocks (not including practice) of 150 trials each.</p>' +
    '<p class="center-content">We will begin with a practice round for you to get used to the keys and animal pictures.</p>' +
    '<p class="center-content">There will be 30 practice trials in total. </p>'
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
    '<p class="center-content">Here are the natural scenes you will see during the experiment, </p>' +
    '<p class="center-content">and their correct responses indicated below.</p>'+
    '<table style="margin-left:auto;margin-right:auto;table-layout:fixed !important; width:1100px;"><tr>' +
    '<td><img src="img/nature/S1.jpg" style="width: 250px; height:170px"></td>' +
    '<td><img src="img/nature/S2.jpg" style="width: 250px; height:170px"></td>' +
    '<td><img src="img/nature/S3.jpg" style="width: 250px; height:170px"></td>' +
    '<td><img src="img/nature/S4.jpg" style="width: 250px; height:170px"></td>' +
    '</tr><tr>' +
    '<td>Press <b>[1]</b></td><td>Press <b>[2]</b></td><td>Press <b>[3]</b></td><td>Press <b>[4]</b></td>' +
    '</tr></table>',


    //Instructions (page 6)
    '<p class="center-content">This part of the experiment consists of 3 blocks of 100 trials each.</p>'+
    '<p class="center-content">You will only see each picture for a very short time, so please make a decision as fast as you can.</p>'+
    '<p class="center-content">After you press the key, the current picture will disappear, followed by the presentation of the next animal picture.</p>'+
    '<p class="center-content"><b>No feedback regarding whether you have pressed the correct key will be given between the trials, </b></p>'+
    '<p class="center-content"><b>we will let you know the amount of monetary bonus you earn after finishing the experiment.</b></p>',


    '<p class="center-content">Please try your best to make the best response for each picture. We really appreciate your hard work! </p>' +
    '<p class="center-content"><b>Please note that if you respond randomly, always press the same key, or never press, we reserve the right to withold your bonus.</b></p>',
    // Instructions (page 6)
    '<p class="center-content">We will begin with a practice round for you to get used to the timing and the keys.</p>' +
    '<p class="center-content">In this practice round, an orange border will appear after you press the correct key to a picture. </p>'+
    '<p class="center-content">There will be 20 practice trials.</p>' +
    '<table style="margin-left:auto;margin-right:auto;table-layout:fixed !important; width:650px;"><tr>' +
    '<td><img src="img/nature/S2.jpg" width="240" style="border:12px solid orange"></td>' +
    '<td><img src="img/nature/S2.jpg" style="width: 240px; "></td>' +
    '</tr><tr>' +
    '<td>Orange border-> </b></td><td>No border-></td>' +
    '</tr></table>'+
    '<table style="margin-left:auto;margin-right:auto;table-layout:fixed !important; width:650px;"><tr>' +
    '<td>Correct response</td><td>Incorrect response</td>' +
    '</tr></table>'+
    '<p class="center-content">Please press "Next" to begin the practice.</p>'
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

    // Instructions (page 4)
    '<p class="center-content">Here are the natural scenes you will see during the experiment, </p>' +
    '<p class="center-content">and their correct responses indicated below</p>'+
    '<table style="margin-left:auto;margin-right:auto;table-layout:fixed !important; width:1100px;"><tr>' +
    '<td><img src="img/nature/S1.jpg" style="width: 250px; height:170px"></td>' +
    '<td><img src="img/nature/S2.jpg" style="width: 250px; height:170px"></td>' +
    '<td><img src="img/nature/S3.jpg" style="width: 250px; height:170px"></td>' +
    '<td><img src="img/nature/S4.jpg" style="width: 250px; height:170px"></td>' +
    '</tr><tr>' +
    '<td>Press <b>[1]</b></td><td>Press <b>[2]</b></td><td>Press <b>[3]</b></td><td>Press <b>[4]</b></td>' +
    '</tr></table>',

    //Instructions (page 6)
    '<p class="center-content">This part of the experiment has 3 blocks (not including practice) of 100 trials each. </p>' +
    '<p class="center-content">We will begin with a practice round for you to get used to the keys and animal pictures.</p>' +
    '<p class="center-content">There will be 20 practice trials in total. </p>'+
    '<p class="center-content">Please press "Next" to begin the practice.</p>'
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