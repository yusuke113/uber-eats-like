import styled from 'styled-components';

// components
import { BaseButton } from '../shared_style';

// constants
import { FONT_SIZE } from '../../style_constants';

// 関数コンポーネントではなく、styled-somponentsで作った関数
// propsや関数が不要な場合にはこれだけでもOK
export const OrderButton = styled(BaseButton)`
  width: 390px;
  background-color: black;
  color: white;
  border-styled: none;
  padding: 8px 16px;
  font-size: ${FONT_SIZE.BODY1};
`;
