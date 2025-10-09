package com.practicemicroservices.order.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class OrderDTOFromUI {

    private List<FoodItemsDTO> foodItemsDTOList;
    private String userId;
    private ChefDTO chefDTO;
    
    // Explicit getter methods to ensure compilation works
    public List<FoodItemsDTO> getFoodItemsDTOList() {
        return foodItemsDTOList;
    }
    
    public String getUserId() {
        return userId;
    }
    
    public ChefDTO getChefDTO() {
        return chefDTO;
    }
}