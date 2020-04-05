'use strict';

function getRandomInt(max) {
    return Math.floor(Math.random() * Math.floor(max));
}

function getFilePath() {
    var filepath = "/Images/ozone/1.jpg";
    var plantType = "ozone";

    const type = getRandomInt(3); 
    if(type == 0) { // no injury
        filepath = "/Images/".concat("noinjury/", getRandomInt(2), ".jpg");
        plantType = "noinjury";
    }
    if(type == 1) { // ozone
        filepath = "/Images/".concat("ozone/", getRandomInt(3), ".jpg");
        plantType = "ozone";
    }
    if(type == 2) { // other dmg
        filepath = "/Images/".concat("other/", getRandomInt(3), ".jpg");
        plantType = "other";
    }  

    var question = [ filepath, plantType ];

    return question;
}

class Quiz extends React.Component {
    constructor(props) {
        super(props);

        this.state = {
            correct: -1,
            file: "/Images/ozone/1.jpg",
            type: "ozone",
        };
    }

    nextQuestion = () => {
        const question = getFilePath();
        this.setState({
            file: question[0],
            type: question[1],
            correct: -1,
        });
    }

    render() {
        return(
            <div className="row">
                <div className="col-lg-6">
                    <div className = "bg-light text-center p-4 border rounded">
                        <h5>Is This Ozone Damage?</h5>
                        <br />
                        <img id="displayed_leaf" src={`${this.state.file}`} alt="A test image pay no mind" className="img-fluid" />
                        <br />
                        <br />
                        <div className="row">
                            <div className="col-lg-6">
                                <button id="yes" type="button" className="btn btn-primary btn-block" name="yes">YES</button>
                            </div>
                            <div className="col-lg-6">
                                <button id="no" type="button" className="btn btn-primary btn-block" name="no">NO </button>
                            </div>
                            <button id="next_question" type="button" className="btn btn-primary btn-block" onClick={this.nextQuestion}>Next Question</button>
                        </div>
                    </div>
                </div>

                <div className="col-lg-3"></div>
            </div>
        );
    }
}

ReactDOM.render(<Quiz />, document.getElementById("quiz"));


/*
class CheckAnswer extends React.Component {
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

*/