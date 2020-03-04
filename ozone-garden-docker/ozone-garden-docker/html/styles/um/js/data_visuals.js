TESTER = document.getElementById('tester');

var Potato = {
x: [140, 200, 220, 240],
y: [10, 30, 70, 60],
  type: 'scatter',
  name: '2018'
};
//var Coneflower = {
//  x: [140, 157, 200, 220, 240],
//  y: [16, 5,30, 40, 32],
//  type: 'scatter',
//  name: '2019'
//};
var data = [Coneflower, Potato];
var layout = {title: 'NCAR Mesa Lab: Coneflower',
            xaxis: {
                title: 'Day Of Year',
                titlefont: {
                  family: 'Arial, sans-serif',
                  size: 18,
                  color: 'grey'
                },},
             yaxis: {
                    title: 'Proportion Of Injured Leaves',
                    titlefont: {
                      family: 'Arial, sans-serif',
                      size: 18,
                      color: 'grey'
                    },}




};
Plotly.newPlot(TESTER, data, layout, {displayModeBar: false});