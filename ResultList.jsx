

class ResultList {

  state = {
    index: 0,
    results: [
      weatherResultData,
    ],
    resultComponents: [],
  }

  constructor() {
    events.sub("ui:keyup", (key) => {
      const index = this.state.index;
      const result = this.state.resultComponents[index];

      if (key === "enter") {
        const url = result.getSelectedUrl();
        this.onSelected(url);
      } else if (key === "down") {
        if (result.down()) {
          this.setState({
            index: this.state.index + 1,
          });
        }
      }
    })
  }

  onSelected(url) {
    openLink(url);
  }

  componentWillReceiveProps(nextProps) {
    this.setState({
      resultComponents: results.map(results => (
        result.type === "weather" ?
          <WeatherResult
            onSelected={this.onSelected}
          />
          : <Generic onSelected={this.onSelected} />
      ))
    })
  }

  render() {
    return (
      <div>
        {this.state.resultComponents}
      </div>
    );
  }
}