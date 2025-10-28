package com.practicemicroservices.foodcatalogue.dto;


import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class FoodItemDTO {

    private String id;
    private String itemName;
    private String itemDescription;
    private boolean isVeg;
    private Number price;
    private String chefId;
    private String chefName; // new field
    private Integer quantity;
    private String cuisine; // new field

    // Manual getter methods to fix Lombok compilation issue
    public String getId() {
        return id;
    }

    public String getItemName() {
        return itemName;
    }

    public String getItemDescription() {
        return itemDescription;
    }

    public boolean isVeg() {
        return isVeg;
    }

    public Number getPrice() {
        return price;
    }

    public String getChefId() {
        return chefId;
    }

    public String getChefName() {
        return chefName;
    }

    public Integer getQuantity() {
        return quantity;
    }

    public String getCuisine() {
        return cuisine;
    }

    // Manual setter methods to fix Lombok compilation issue
    public void setId(String id) {
        this.id = id;
    }

    public void setItemName(String itemName) {
        this.itemName = itemName;
    }

    public void setItemDescription(String itemDescription) {
        this.itemDescription = itemDescription;
    }

    public void setVeg(boolean veg) {
        isVeg = veg;
    }

    public void setPrice(Number price) {
        this.price = price;
    }

    public void setChefId(String chefId) {
        this.chefId = chefId;
    }

    public void setChefName(String chefName) {
        this.chefName = chefName;
    }

    public void setQuantity(Integer quantity) {
        this.quantity = quantity;
    }

    public void setCuisine(String cuisine) {
        this.cuisine = cuisine;
    }
}