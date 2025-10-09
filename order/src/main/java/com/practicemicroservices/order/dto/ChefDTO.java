package com.practicemicroservices.order.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class ChefDTO {

    private String id;
    private String name;
    private String address;
    private String city;
    private String chefDescription;

}