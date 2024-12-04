package com.practicemicroservices.foodcatalogue.controller;

import com.practicemicroservices.foodcatalogue.dto.FoodCataloguePage;
import com.practicemicroservices.foodcatalogue.dto.FoodItemDTO;
import com.practicemicroservices.foodcatalogue.service.FoodCatalogueService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/foodCatalogue")
public class FoodCatalogueController {

    @Autowired
    FoodCatalogueService foodCatalogueService;

    @PostMapping("/addFoodItem")
    public ResponseEntity<FoodItemDTO> addFoodItem(@RequestBody FoodItemDTO foodItemDTO){
        FoodItemDTO savedFoodItem= foodCatalogueService.addFoodItem(foodItemDTO);
        return new ResponseEntity<>(savedFoodItem, HttpStatus.CREATED);
    }

    @GetMapping("/fetchChefAndFoodItemsById/{chefId}")
    public ResponseEntity<FoodCataloguePage> fetchChefAndFoodItemById(@PathVariable Integer chefId){
        FoodCataloguePage foodCataloguePage=foodCatalogueService.fetchFoodCataloguePageDetails(chefId);
        return new ResponseEntity<>(foodCataloguePage,HttpStatus.OK);
    }

}
