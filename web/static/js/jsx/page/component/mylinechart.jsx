import React from 'react';
import _ from 'lodash';
import {LineChart, Line, XAxis, YAxis, CartesianGrid, Tooltip, Legend, ResponsiveContainer} from "recharts";


const SimpleLineChart = class SimpleLineChart extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      rawData: [],
      data: [],
      pkey: null,
    };
    this.updateData = this.updateData.bind(this)
  }
  componentWillReceiveProps(nextProps){
    if(this.rawData != nextProps.cdata){
      this.setState({
        rawData: nextProps.cdata,
      })
    }
    this.updateData(nextProps.cdata, nextProps.pkey)
  }
  componentDidMount(){
    const rawData = this.props.cdata
    const pkey = this.props.pkey
    this.setState({
      rawData: rawData,
      pkey: pkey,
    })
  }
  updateData(data, pkey){
    if(pkey == null && data.length != 0){
      this.setState({
        rawData: data,
        data: this.transData(data["all"]),
        pkey: pkey,
      })
    }else{
      this.setState({
        rawData: data,
        data: this.transData(data[pkey]),
        pkey: pkey,
      })
    }
  }
  transData(data){
    return _.chain(data).map((k,y) =>{
      return {name: y, value: k}
    }).sortBy((o) => {
      return parseInt(o.name)
    }).value()
  }
	render () {
  	return (
      <ResponsiveContainer width="100%" height={250}>
      	<LineChart data={this.state.data} margin={{top: 5, right: 30, left: 20, bottom: 5}}>
          <XAxis dataKey="name"/>
           <YAxis/>
           <CartesianGrid strokeDasharray="3 3"/>
           <Tooltip/>
           <Legend />
           <Line type="monotone" dataKey="value" stroke="#DC143C" label={(d) => d.name + "时"}/>
        </LineChart>
      </ResponsiveContainer>
    );
  }
}

module.exports = {SimpleLineChart}
