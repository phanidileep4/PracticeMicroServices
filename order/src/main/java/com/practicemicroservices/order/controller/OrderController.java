package com.practicemicroservices.order.controller;

import com.practicemicroservices.order.dto.OrderDTO;
import com.practicemicroservices.order.dto.OrderDTOFromUI;
import com.practicemicroservices.order.service.OrderService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/order")
public class OrderController {
    @Autowired
    private OrderService orderService;

    @PostMapping("/saveOrder")
    public ResponseEntity<OrderDTO> saveOrder(@RequestBody OrderDTOFromUI orderDTOFromUI){
        OrderDTO orderProcessed=orderService.processOrder(orderDTOFromUI);
        return new ResponseEntity<>(orderProcessed, HttpStatus.CREATED);
    }
}
