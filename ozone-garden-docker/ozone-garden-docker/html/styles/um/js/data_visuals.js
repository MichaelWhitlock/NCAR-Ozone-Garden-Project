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
//run singleOrComparison Function whenever change is made to dropdown selection
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

//Creates graph with variables that are passed in by perl code
Plotly.newPlot('bar-div', dataBar, layoutBar, {displayModeBar: false});


