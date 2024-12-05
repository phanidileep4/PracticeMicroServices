package com.practicemicroservices.order.mapper;

import com.practicemicroservices.order.dto.OrderDTO;
import com.practicemicroservices.order.entity.Order;
import org.mapstruct.Mapper;
import org.mapstruct.factory.Mappers;

@Mapper
public interface OrderMapper {

    OrderMapper INSTANCE= Mappers.getMapper(OrderMapper.class);

    Order mapOrderDTOTOOrder(OrderDTO orderDTO);
    OrderDTO mapOrderTOOrderDTO(Order order);
}
