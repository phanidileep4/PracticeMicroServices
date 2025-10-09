package com.practicemicroservices.order.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class OrderDTO {
    private Integer orderId;
    private List<FoodItemsDTO> foodItemsDTOList;
    private UserDTO userDTO;
    private ChefDTO chefDTO;
    
    // Explicit setter methods to ensure compilation works
    public void setOrderId(Integer orderId) {
        this.orderId = orderId;
    }
    
    public void setFoodItemsDTOList(List<FoodItemsDTO> foodItemsDTOList) {
        this.foodItemsDTOList = foodItemsDTOList;
    }
    
    public void setUserDTO(UserDTO userDTO) {
        this.userDTO = userDTO;
    }
    
    public void setChefDTO(ChefDTO chefDTO) {
        this.chefDTO = chefDTO;
    }
}