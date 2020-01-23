import { Result, ResultData } from '@cliqz/compontent-ui-result';
import { Weather } from '@cliqz/component-ui-snippet-weather';
import { Button } from '@cliqz/component-ui-snippet-button';
import PropTypes from 'prop-types';

class WeatherResult extends Result {
    state = {
      isSelected: false,
    }

    next() {
      if (this.state.isSelected) {
        this.setState({
          isSelected: false,
        });
        return true;
      } else {
        this.setState({
          isSelected: true,
        });
        return false;
      }
    }

    previous() {

    }

    getSelectedUrl() {
      if (!this.state.isSelected) {
        return null;
      }
      return this.props.result.url;
    }

    render() {
        return (
            <Weather
                styles={{

                }}
                moreButtonText="More"
                lessButtonText="Less"
                button={
                    <Button
                        label="Checke weather"
                        isActive={this.state.isSelected}
                        onClicked={() => this.props.onSelected(this.props.result.url)}
                    />
                }
            />
        );
    }
}


WeatherResult.propTypes = {
  onSelected: PropTypes.func,
  result: PropTypes.instanceOf(ResultData),
};