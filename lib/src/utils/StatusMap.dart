const OrderStatusByConsumer = {
  "BEFORE_CONFIRM" : "주문 확인 중", // 취소 가능
  "ORDER_CONFIRM" : "주문 수락", // 구매 확정 가능
  "DELIVERY_REQUEST" : "배달 확인 중", // 취소 가능
  "DELIVERY_READY" : "배달 준비 중",
  "DELIVERY_START" : "배달 출발", // 구매 확정 가능
  "DELIVERY_END" : "배달 완료", // 구매 확정 가능
  "REFUND_CONFIRM" : "결제 취소",
  "REFUND_REQUEST" : "취소 요청 중",
  "CONFIRM" : "구매 확정",
};

const OrderStatusByProvider = {
  "BEFORE_CONFIRM" : "주문 요청",
  "ORDER_CONFIRM" : "주문 수락",
  "DELIVERY_REQUEST" : "배달 요청",
  "DELIVERY_READY" : "배달 준비 중",
  "DELIVERY_START" : "배달 출발",
  "DELIVERY_END" : "배달 완료",
  "REFUND_CONFIRM" : "결제 취소",
  "REFUND_REQUEST" : "취소 요청 중",
  "CONFIRM" : "구매 확정",
};