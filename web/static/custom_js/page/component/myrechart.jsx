import React from 'react';
import {PieChart, Pie, Legend, Cell, ResponsiveContainer} from "recharts";

const COLORS = ['#00C49F', '#ff4040', '#0088FE', '#FFBB28', '#FF804', '#8ee5ee', '#76ee00', '#ff7f24', '#FE2EC8', '#9932cc'];

const SimpleBarChart = class SimpleBarChart extends React.Component {
	render () {
  	return (
      <ResponsiveContainer width="100%" height={300}>
      	<PieChart width={600} height={300} onClick={this.props.handleBarClick}>
          <Pie data={this.props.ppdata} fill="#82ca9d" label={
           (a) => {return a.name + ":" + a.value }
          }>
            {
              this.props.ppdata.map((entry, index) => <Cell key={entry.name} fill={COLORS[index]}/>)
            }
          </Pie>
         </PieChart>
      </ResponsiveContainer>
    );
  }
}

module.exports = {SimpleBarChart}
