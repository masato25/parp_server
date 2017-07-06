import React from 'react';
import { Table, Icon, Tooltip, Tag, Select } from 'antd';
const Option = Select.Option;
import {ifetch} from '../../common/fetch.js';
import moment from 'moment';
import _ from 'lodash';

var WeekPicker = class FalconTable extends React.Component {
  constructor(props) {
    super(props)
    this.moment = moment
    const children = [];
    let o = 3
    //check today grate than friday?
    if (parseInt(this.moment().format("d")) >= 5) {
      console.log("today is friday")
      const stime = this.moment().day(-2).format("YYYY-MM-DD")
      const etime =  this.moment().day(4).format("YYYY-MM-DD")
      //this is cause of we want get data the end of previous day
      const realetime = this.moment().day(5).format("YYYY-MM-DD")
      const datekey = `${stime},${realetime}`
      children.push(<Option key={datekey}>{`${stime} ~ ${etime}` }</Option>)
      o = 2
    }
    for (let i = 0; i < o; i++) {
      const stime = this.moment().weekday(-10 + (-7*i)).format("YYYY-MM-DD")
      const etime =  this.moment().weekday(-4 + (-7*i)).format("YYYY-MM-DD")
      //this is cause of we want get data the end of previous day
      const realetime =  this.moment().weekday(-3 + (-7*i)).format("YYYY-MM-DD")
      const datekey = `${stime},${realetime}`
      switch(i){
        case 0:
          children.push(<Option key={datekey}>{`${stime} ~ ${etime}`}</Option>)
          break
        case 1:
          children.push(<Option key={datekey}>{`${stime} ~ ${etime}`}</Option>)
          break
        case 2:
          children.push(<Option key={datekey}>{`${stime} ~ ${etime}`}</Option>)
          break
      }
    }

    this.state = {children: children}
  }
  componentDidMount(){

  }
  render() {
    return (
      <span>
        <Select
          size={"default"}
          onChange={this.props.onChange}
          style={{ "min-width": 200 }}
          value={this.props.weekpickdate}
          disabled={this.props.disabled}
        >
          {this.state.children}
        </Select>
      </span>
    )
  }
}

module.exports = {WeekPicker}
