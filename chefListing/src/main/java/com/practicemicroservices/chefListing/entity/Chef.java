package com.practicemicroservices.chefListing.entity;

import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Document(collection = "chefs")
@Data
@AllArgsConstructor
@NoArgsConstructor
public class Chef {

    @Id
    private String id;
    private String name;
    private String address;
    private String city;
    private String chefDescription;

    // Manual getter methods to fix Lombok compilation issue
    public String getId() {
        return id;
    }

    public String getName() {
        return name;
    }

    public String getAddress() {
        return address;
    }

    public String getCity() {
        return city;
    }

    public String getChefDescription() {
        return chefDescription;
    }

    // Manual setter methods to fix Lombok compilation issue
    public void setId(String id) {
        this.id = id;
    }

    public void setName(String name) {
        this.name = name;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public void setCity(String city) {
        this.city = city;
    }

    public void setChefDescription(String chefDescription) {
        this.chefDescription = chefDescription;
    }
}