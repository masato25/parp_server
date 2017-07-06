import 'dva' from 'dva';
import {fetch} from '../../common/fetch.js';

export default {
  namespace: 'falcon',
  state: {
    list: []
  },
  effects: {
    *query(date){
      const {success,data} = yield fetch(`/api/v1/events?selected=${date}`)
      if(success){
        yield put({
          type: 'querySuccess',
          payload: data,
        })
      }
    }
  }
  reducers: {
    'querySuccess'(state, { payload }) {
      return {...state, list: data}
    },
  },
};
