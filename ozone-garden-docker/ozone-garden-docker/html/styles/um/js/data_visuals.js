//logic for getting dropdowns to appear and dissappear as well as submit post request when year is selected
function singleOrComparison() {
    if (document.getElementById("single").selected) {
        document.getElementById("plant-type-group").style.display = "block";
    } else {
        document.getElementById("plant-type-group").style.display = "none";
        document.getElementById("year-select-group").style.display = "none";
    }
}
window.onload = singleOrComparison();
var graphType = document.getElementById('graph-type');
graphType.addEventListener('change', singleOrComparison ,false);

function plantCheck() {
    if (document.getElementById("select-plant-type").selected) {
        document.getElementById("year-select-group").style.display = "none";
    } else {
        document.getElementById("year-select-group").style.display = "block";
    }
}
window.onload = plantCheck();
var graphType = document.getElementById('plant-type');
graphType.addEventListener('change', plantCheck ,false);



//TESTER = document.getElementById('tester');
TESTER2 = document.getElementById('tester3');

//var line1 = {
//x: [140, 200, 220, 240],
//y: [10, 30, 70, 60],
//  type: 'scatter',
//  name: '2018'
//};
//var line2 = {
//  x: [140, 157, 200, 220, 240],
//  y: [16, 5,30, 40, 32],
//  type: 'scatter',
//  name: '2019'
//};
//var data = [line1, line2];

// var layout = {title: 'NCAR Mesa Lab: Coneflower',
//             xaxis: {
//                   title: 'Day Of Year',
//                   titlefont: {
//                   family: 'Arial, sans-serif',
//                   size: 18,
//                   color: 'grey'
//                 },},
//              yaxis: {
//                   title: 'Proportion Of Injured Leaves',
//                   titlefont: {
//                   family: 'Arial, sans-serif',
//                   size: 18,
//                   color: 'grey'
//                 },} };

var dataBar = [line0,line1,line2,line3,line4,line5];





//Plotly.newPlot('tester', data, layout, {displayModeBar: false});
Plotly.newPlot('tester3', dataBar, layoutBar, {displayModeBar: false});


