'use strict';

function getRandomInt(max) {
    return Math.floor(Math.random() * Math.floor(max));
}

function getFilePath() {
    var filepath = "/Images/ozone/leaf1.jpg";
    var plantType = "ozone";

    const type = getRandomInt(3); 
    if(type == 0) { // no injury
        filepath = "/Images/".concat("noinjury/leaf", getRandomInt(9), ".jpg");
        plantType = "noinjury";
    }
    if(type == 1) { // ozone
        filepath = "/Images/".concat("ozone/leaf", getRandomInt(33), ".jpg");
        plantType = "ozone";
    }
    if(type == 2) { // other dmg
        filepath = "/Images/".concat("other/leaf", getRandomInt(26), ".jpg");
        plantType = "other";
    }  

    var question = [ filepath, plantType ];

    return question;
}

class Quiz extends React.Component {
    constructor(props) {
        super(props);

        this.state = {
            response: "",
            file: "/Images/ozone/leaf1.jpg",
            type: "ozone",
        };
    }

    nextQuestion = () => {
        const question = getFilePath();
        this.setState({
            response: "",
            file: question[0],
            type: question[1],
        });
    }

    checkYes = () => {
        if(this.state.type == "ozone") { // correct
            this.setState({
                response: (
                    <div className="correct">
                        <strong>Correct!</strong>
                        <p>This is ozone damage</p>
                    </div>
                ),
            });
        }
        else { // incorrect
            this.setState({
                response: (
                    <div className="incorrect">
                        <strong>Incorrect!</strong>
                        <p>This is not ozone damage</p>
                    </div>
                ),
            });
        }
    }

    checkNo = () => {
        if(this.state.type == "noinjury") { // correct
            this.setState({
                response: (
                    <div className="correct">
                        <strong>Correct!</strong>
                        <p>There is no ozone damage on this leaf.</p>
                    </div>
                ),
            });
        }
        if(this.state.type == "other") { // correct
            this.setState({
                response: (
                    <div className="correct">
                        <strong>Correct!</strong>
                        <p>The damage present is not caused by ozone.</p>
                    </div>
                ),
            });
        }
        else { // incorrect
            this.setState({
                response: (
                    <div className="incorrect">
                        <strong>Incorrect!</strong>
                        <p>The damage on the leaves was caused by ozone damage</p>
                    </div>
                ),
            });
        }
    }

    render() {
        return(

            <div className="row">
                <div className="col-lg-8">
                    <div className = "bg-light p-4 border rounded">
                        <h5 className="text-center">Is This Ozone Damage?</h5>
                        <br />
                        <h5>To summarize, ozone injury:</h5>

                        <ul>

                            <li>Typically occurs on the top surface of the leaf</li>

                            <li>Starts as stipple, but can progress to yellowing and patches of tissue death</li>

                            <li>Only occurs between the leaf veins</li>

                            <li>Accumulates through time</li>

                            <li>Affects older leaves</li>

                        </ul>

                        <br />
                        <img id="displayed_leaf" src={`${this.state.file}`} alt="A test image pay no mind" className="img-fluid" />
                        <br />
                        <br />

                        {this.state.response}

                        <div className="row">

                            <div className="col-lg-6">
                                <button id="yes" type="button" className="btn btn-primary btn-block" name="yes" onClick={this.checkYes}>YES</button>
                            </div>

                            <div className="col-lg-6">
                                <button id="no" type="button" className="btn btn-primary btn-block" name="no" onClick={this.checkNo}>NO</button>
                            </div>

                            <br />

                            <div className="col-lg-12 nextButton">
                                <button id="next_question" type="button" className="btn btn-primary btn-block" onClick={this.nextQuestion}>Next Question</button>
                            </div>
                        </div>
                    </div>
                </div>

                <div className="col-lg-3"></div>
            </div>
        );
    }
}

ReactDOM.render(<Quiz />, document.getElementById("quiz"));