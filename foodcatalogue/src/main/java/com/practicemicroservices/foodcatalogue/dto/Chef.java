package com.practicemicroservices.foodcatalogue.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class Chef {
    private int id;
    private String name;
    private String address;
    private String city;
    private String chefDescription;
}
