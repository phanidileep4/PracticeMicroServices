package com.practicemicroservices.order.entity;

import com.practicemicroservices.order.dto.ChefDTO;
import com.practicemicroservices.order.dto.FoodItemsDTO;
import com.practicemicroservices.order.dto.UserDTO;
import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;

import java.util.List;

@Document("order")
public class Order {

    @Id
    private Integer orderId;
    private List<FoodItemsDTO> foodItemsDTOList;
    private UserDTO userDTO;
    private ChefDTO chefDTO;

    // Default constructor
    public Order() {}

    // All args constructor
    public Order(Integer orderId, List<FoodItemsDTO> foodItemsDTOList, UserDTO userDTO, ChefDTO chefDTO) {
        this.orderId = orderId;
        this.foodItemsDTOList = foodItemsDTOList;
        this.userDTO = userDTO;
        this.chefDTO = chefDTO;
    }

    // Getters and setters
    public Integer getOrderId() {
        return orderId;
    }

    public void setOrderId(Integer orderId) {
        this.orderId = orderId;
    }

    public List<FoodItemsDTO> getFoodItemsDTOList() {
        return foodItemsDTOList;
    }

    public void setFoodItemsDTOList(List<FoodItemsDTO> foodItemsDTOList) {
        this.foodItemsDTOList = foodItemsDTOList;
    }

    public UserDTO getUserDTO() {
        return userDTO;
    }

    public void setUserDTO(UserDTO userDTO) {
        this.userDTO = userDTO;
    }

    public ChefDTO getChefDTO() {
        return chefDTO;
    }

    public void setChefDTO(ChefDTO chefDTO) {
        this.chefDTO = chefDTO;
    }
}