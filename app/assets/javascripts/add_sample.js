 function addSample (sampleNum, e) {
  e.preventDefault();
  firstSample = { Philosophy: ["Allan Gibbard", "Terry Horgan", "Jack Woods", "Derek Parfit", "Richard Joyce", "Sharon Street", "Mark Schroeder", "Michael Ridge"  ],
                  Economics: ["Raj Chetty", "Xavier Gabaix", "Emmanuel Saez", "Eammanuel Farhi", "Justin Wolfers", "Nathan Nunn", "Kristin Forbes", "" ],
                  Psychology: ["", "", "", "", "", "", "", "" ],
                  History: ["", "", "", "", "", "", "", "" ],
                  none: ["","","","","","","",""]};
  secondSample = { Philosophy: ["Peter Carruthers", "Daniel Dennett", "Patricia Churchland", "Susan Schneider", "Jerry Fodor", "David Papineau", "Ruth Millikan", "Murat Aydede" ],
                   Economics: ["", "", "", "", "", "", "", "" ],
                   Psychology: ["", "", "", "", "", "", "", "" ],
                   History: ["", "", "", "", "", "", "", "" ],
                   none: ["","","","","","","",""]};
  clear = ["", "", "", "", "", "", "", "" ];

  var filterVal = document.getElementsByClassName('selected')[0].dataset.name;
  var sample;
  
  switch (sampleNum) {
      case 1 :
        sample = firstSample[filterVal];
        break;
      case 2 :
        sample = secondSample[filterVal];
        break;
      default :
        sample = clear;
        break;
    }
for (var i = 0; i < 8; i++) {      fields[i].value = sample[i];
    }
}

document.addEventListener("DOMContentLoaded", function() {
  document.getElementById('sample1').addEventListener("click", addSample.bind(this,1));
  document.getElementById('sample2').addEventListener("click", addSample.bind(this,2));
  document.getElementById('clearButton').addEventListener("click", addSample.bind(this,3));
}, false);
