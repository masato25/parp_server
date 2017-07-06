import React from 'react';
import { Table, Icon } from 'antd';
import {ifetch} from '../../common/fetch.js';
const Chartist = require("Chartist")

const PieChart = class PieChart extends React.Component {
  componentWillReceiveProps(nextProps){
    this.componentDidMount()
  }
  componentDidMount(){
    var data = this.props.pdata
    console.log("piedata", data)

    var options = {
      labelInterpolationFnc: function(value) {
        return value[0]
      }
    };

    var responsiveOptions = [
      ['screen and (min-width: 640px)', {
        chartPadding: 30,
        labelOffset: 100,
        labelDirection: 'explode',
        labelInterpolationFnc: function(value) {
          return value;
        }
      }],
      ['screen and (min-width: 1024px)', {
        labelOffset: 80,
        chartPadding: 20
      }]
    ];
    new Chartist.Pie('.pi', data, options, responsiveOptions);
  }
  render() {
    return (
      <div className="pi-row">
        <div className="pi"></div>
      </div>
    )
  }
}

module.exports = {PieChart}
