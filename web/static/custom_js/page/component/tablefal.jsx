import React from 'react';
import { Table, Icon, Tooltip, Tag } from 'antd';
import {ifetch} from '../../common/fetch.js';
import moment from 'moment';
import _ from 'lodash';

var FalconTable = class FalconTable extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      sdate: 0,
      edate: 0,
      columns: [],
      data: [],
    };
    this.genColumn = this.genColumn.bind(this);
    // this.handleTableChange = this.handleTableChange.bind(this);
  }
  // shouldComponentUpdate(nextProps, nextState){
  //   // console.log(this.state.data.length, nextProps.data.length)
  //   if(this.state.data.length != nextProps.data.length){
  //     return true
  //   }
  //   return false
  // }
  componentWillReceiveProps(nextProps){
    this.setState({
      data: nextProps.data,
      sdate: this.copyTime(nextProps.dateStr).format('YYYY-MM-DD 00:00:00'),
      edate: this.copyTime(this.props.dateStrEnd).format('YYYY-MM-DD 00:00:00'),
    })
  }
  componentDidMount(){
    this.setState({
      sdate: this.copyTime(this.props.dateStr).format('YYYY-MM-DD 00:00:00'),
      edate: this.copyTime(this.props.dateStrEnd).format('YYYY-MM-DD 00:00:00'),
      data: this.props.data,
      columns: this.genColumn()
    })
  }
  copyTime(time){
    return moment(time, 'YYYY-MM-DD')
  }
  genColumn(){
    return [{
        title: '机器名',
        dataIndex: 'endpoint',
        key: 'endpoint',
        sorter: (a, b) => {
          if(a.endpoint == b.endpoint){
            return 1
          }else{
            return -1
          }
        },
        render: (text, record) => (
          <span>
            <span>
              {record.endpoint} ({record.platform})
            </span>
            <Tooltip placement="topLeft" title={"此机器过往告警纪录"}>
              <span style={{margin: "5px"}}>
                <a target="_blank" href={`/view/enpview?endpoint=${record.endpoint}&sdate=${this.state.sdate}&edate=${this.state.edate}`}>
                  <Icon type="laptop" style={{"font-size": "20px", "color": "#409048"}}/>
                </a>
              </span>
            </Tooltip>
            <Tooltip placement="topLeft" title={"此告警历史纪录"}>
              <span style={{margin: "5px"}}>
                <a target="_blank" href={`/view/evtview?id=${record.id}&sdate=${this.state.sdate}&edate=${this.state.edate}`}>
                  <Icon type="line-chart" style={{"font-size": "20px", "color": "#409048"}} />
                </a>
              </span>
            </Tooltip>
          </span>
        ),
      },
      {
        title: '优先等级',
        dataIndex: 'priority',
        sorter: (a, b) => a.priority - b.priority,
        key: 'priority',
      }, {
        title: '监控项',
        // sorter: true,
        dataIndex: 'metric',
        key: 'metric',
        render: (text, record) => (
          <Tooltip placement="topLeft" title={record.id}>
            <div>{record.note}</div>
            <div className="detail_metric_label">{"[ " + record.metric + " ] "}</div>
          </Tooltip>
        )
      }, {
        title: '状态',
        dataIndex: 'status',
        key: 'status',
        // filters: [
        //   { text: 'OK', value: 'OK' },
        //   { text: 'REMOVED', value: 'REMOVED' },
        //   { text: 'PROBLEM', value: 'PROBLEM' },
        //   { text: 'UNKNOWN', value: 'UNKNOWN' }
        // ],
        // filteredValue: filteredInfo.status || null,
        // onFilter: (value, record) => record.status.includes(value),
        sorter: (a, b) => a.status.length - b.status.length
      }
      , {
        title: '次数',
        dataIndex: 'count',
        key: 'count',
        sorter: (a, b) => a.count - b.count
      }
    ];
  }
  // handleTableChange(pagination, filters, sorter) {
  //   const sortedData = _.sortBy(this.state.data, function(o){
  //     return o[sorter.field]
  //   })
  //   this.setState({
  //     data: sortedData,
  //   })
  // }
  render() {
    return (
      <div>
        <Table columns={this.state.columns} dataSource={this.state.data} loading={this.props.tableLoad}  />
      </div>
    )
  }
}

module.exports = {FalconTable}
