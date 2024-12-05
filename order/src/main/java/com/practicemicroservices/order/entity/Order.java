package com.practicemicroservices.order.entity;

import com.practicemicroservices.order.dto.ChefDTO;
import com.practicemicroservices.order.dto.FoodItemsDTO;
import com.practicemicroservices.order.dto.UserDTO;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.springframework.data.mongodb.core.mapping.Document;

import java.util.List;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Document("order")
public class Order {

    private Integer orderId;
    private List<FoodItemsDTO> foodItemsDTOList;
    private UserDTO userDTO;
    private ChefDTO chefDTO;
}
