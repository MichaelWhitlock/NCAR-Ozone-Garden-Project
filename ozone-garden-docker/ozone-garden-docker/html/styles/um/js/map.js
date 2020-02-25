//Define Image for Markers
var greenIcon = L.icon({
                        iconUrl: 'Images/green-leaf.png',
                        iconSize: [38,45],
                        })

//Create map
var mymap = L.map('mapid').setView([39.5, -95], 4);
L.tileLayer('https://api.mapbox.com/styles/v1/{id}/tiles/{z}/{x}/{y}?access_token={accessToken}', {
attribution: 'Map data &copy; <a href="https://www.openstreetmap.org/">OpenStreetMap</a> contributors, <a href="https://creativecommons.org/licenses/by-sa/2.0/">CC-BY-SA</a>, Imagery © <a href="https://www.mapbox.com/">Mapbox</a>',
maxZoom: 18,
id: 'mapbox/streets-v11',
tileSize: 512,
zoomOffset: -1,
accessToken: 'pk.eyJ1IjoiaHVudGVyNTI4MCIsImEiOiJjazZ0cDF5dWUwMWk1M21wbm8wanUxcnBnIn0.Kx78AVroooRQnU_oQlJ8qg'
}).addTo(mymap);

//Add Markers
var marker = L.marker([39.9783, -105.275],{icon: greenIcon}).addTo(mymap);
marker.bindPopup("<button type='button' onclick='window.location.href = &quot;data_visual.pl&quot;'>NCAR Boulder</button>")