package com.practicemicroservices.order.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.springframework.web.bind.annotation.PostMapping;

import java.util.List;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class OrderDTO {
    private Integer orderId;
    private List<FoodItemsDTO> foodItemsDTOList;
    private UserDTO userDTO;
    private ChefDTO chefDTO;
}
