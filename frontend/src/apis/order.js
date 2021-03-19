import axios from 'axios';
import { order } from '../urls/index';


export const postOrder = (params) => {
  return axios.post(order,
    {
      line_food_ids: params.line_food_ids
    },
  )
  .then(res => {
    return res.data
  })
  .catch((e) => console.error(e))
};