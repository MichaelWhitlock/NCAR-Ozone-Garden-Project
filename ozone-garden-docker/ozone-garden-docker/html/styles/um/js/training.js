'use strict';

function getRandomInt(max) {
    return Math.floor(Math.random() * Math.floor(max));
}

function getFilePath() {
    var filepath = "/Images/ozone/1.jpg";
    const type = getRandomInt(3); 
    if(type == 0) { // no injury
        filepath = "/Images/".concat("noinjury/", getRandomInt(2), ".jpg")
    }
    if(type == 1) { // ozone
        filepath = "/Images/".concat("ozone/", getRandomInt(3), ".jpg")
    }
    if(type == 2) { // other dmg
        filepath = "/Images/".concat("other/", getRandomInt(3), ".jpg")
    }  

    return filepath;
}

class checkAnswer extends React.Component {
    constructor(props) {
        super(props);

        this.state = {
            correct: true,
        };
    }

    render () {

    }
}

const next = React.createElement;

class NextQuestion extends React.Component {

    constructor(props) {
        super(props);

        this.state = { 
            file: "/Images/ozone/1.jpg",
        };
    }

    render() {
        document.getElementById("displayed_leaf").src = this.state.file;

        return next(
            "button",
            { onClick: () => this.setState({ file: getFilePath() }) },
            "Next Question"
        );
    }
}

const domContainer = document.getElementById("next_question");
ReactDOM.render(next(NextQuestion), domContainer);