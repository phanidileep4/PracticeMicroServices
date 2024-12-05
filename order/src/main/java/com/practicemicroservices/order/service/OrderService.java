package com.practicemicroservices.order.service;

import com.practicemicroservices.order.dto.OrderDTO;
import com.practicemicroservices.order.dto.OrderDTOFromUI;
import com.practicemicroservices.order.dto.UserDTO;
import com.practicemicroservices.order.entity.Order;
import com.practicemicroservices.order.mapper.OrderMapper;
import com.practicemicroservices.order.repo.OrderRepo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;

@Service
public class OrderService {
    @Autowired
    private OrderRepo orderRepo;

    @Autowired
    SequenceGenerator sequenceGenerator;

    @Autowired
    RestTemplate restTemplate;

    public OrderDTO processOrder(OrderDTOFromUI orderDTOFromUI) {
        Integer newOrderId=sequenceGenerator.generateNextOrderId();
        UserDTO userDTO=fetchUserDetailsFromUserId(orderDTOFromUI.getUserId());
        Order orderToProcess= new Order(newOrderId, orderDTOFromUI.getFoodItemsDTOList(),userDTO, orderDTOFromUI.getChefDTO());
        orderRepo.save(orderToProcess);
        return OrderMapper.INSTANCE.mapOrderTOOrderDTO(orderToProcess);
    }

    private UserDTO fetchUserDetailsFromUserId(Integer userId) {
        return restTemplate.getForObject("http://USER-SERVICE/user/fetchUserById/"+userId, UserDTO.class);
    }
}
