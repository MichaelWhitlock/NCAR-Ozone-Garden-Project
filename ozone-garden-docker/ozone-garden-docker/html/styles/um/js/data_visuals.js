//logic for getting dropdowns to appear and dissappear as well as submit post request when year is selected
function singleOrComparison() {
    if (document.getElementById("single").selected) {
        document.getElementById("plant-type-group").style.display = "block";
        document.getElementById("comparison-choice-group").style.display = "none";
        document.getElementById("comparison-plant1").style.display = "none";
        document.getElementById("comparison-plant2").style.display = "none";
        document.getElementById("comparison-year1").style.display = "none";
        document.getElementById("comparison-year2").style.display = "none";
        document.getElementById("comparison-location1").style.display = "none";
        document.getElementById("comparison-location2").style.display = "none";
    } else {
        if (document.getElementById("comparison").selected) {
            document.getElementById("comparison-choice-group").style.display = "block";
            document.getElementById("plant-type-group").style.display = "none";
            document.getElementById("year-select-group").style.display = "none";
        } else {
            document.getElementById("plant-type-group").style.display = "none";
            document.getElementById("year-select-group").style.display = "none";
            document.getElementById("comparison-choice-group").style.display = "none";
            document.getElementById("comparison-plant1").style.display = "none";
            document.getElementById("comparison-plant2").style.display = "none";
            document.getElementById("comparison-year1").style.display = "none";
            document.getElementById("comparison-year2").style.display = "none";
            document.getElementById("comparison-location1").style.display = "none";
            document.getElementById("comparison-location2").style.display = "none";
        }
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
var plantType = document.getElementById('plant-type');
plantType.addEventListener('change', plantCheck ,false);

//similar to above code, checks everytime there is an update to the comparisons select field and then runs comparisonCheck Function to show/hide other fields
function comparisonCheck() {
    if (document.getElementById("select-comparison").selected) {
        document.getElementById("comparison-plant1").style.display = "none";
        document.getElementById("comparison-plant2").style.display = "none";
        document.getElementById("comparison-year1").style.display = "none";
        document.getElementById("comparison-year2").style.display = "none";
        document.getElementById("comparison-location1").style.display = "none";
        document.getElementById("comparison-location2").style.display = "none";
    }
    else if(document.getElementById("compare-years").selected){
        document.getElementById("comparison-plant1").style.display = "none";
        document.getElementById("comparison-plant2").style.display = "none";
        document.getElementById("comparison-year1").style.display = "block";
        document.getElementById("comparison-year2").style.display = "block";
        document.getElementById("comparison-location1").style.display = "none";
        document.getElementById("comparison-location2").style.display = "none";
    }
    else if(document.getElementById("compare-plants").selected){
        document.getElementById("comparison-plant1").style.display = "block";
        document.getElementById("comparison-plant2").style.display = "block";
        document.getElementById("comparison-year1").style.display = "none";
        document.getElementById("comparison-year2").style.display = "none";
        document.getElementById("comparison-location1").style.display = "none";
        document.getElementById("comparison-location2").style.display = "none";
    }
    else{
        document.getElementById("comparison-plant1").style.display = "none";
        document.getElementById("comparison-plant2").style.display = "none";
        document.getElementById("comparison-year1").style.display = "none";
        document.getElementById("comparison-year2").style.display = "none";
        document.getElementById("comparison-location1").style.display = "block";
        document.getElementById("comparison-location2").style.display = "block";
    }
}
window.onload = comparisonCheck();
var comparisonType = document.getElementById('comparison-choice');
comparisonType.addEventListener('change', comparisonCheck ,false);



//TESTER = document.getElementById('tester');
//TESTER2 = document.getElementById('tester3');

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







//Plotly.newPlot('tester', data, layout, {displayModeBar: false});
Plotly.newPlot('bar-div', dataBar, layoutBar, {displayModeBar: false});


