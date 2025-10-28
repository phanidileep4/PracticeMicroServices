package com.practicemicroservices.order.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class FoodItemsDTO {
    private String id;
    private String itemName;
    private String itemDescription;
    private boolean isVeg;
    private Number price;
    private String chefId;
    private Integer quantity;
    private String cuisine; // new field

    // Explicit getter and setter for cuisine to ensure compatibility
    public String getCuisine() {
        return cuisine;
    }

    public void setCuisine(String cuisine) {
        this.cuisine = cuisine;
    }
}