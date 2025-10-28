package com.practicemicroservices.foodcatalogue.service;

import com.practicemicroservices.foodcatalogue.dto.Chef;
import com.practicemicroservices.foodcatalogue.dto.FoodCataloguePage;
import com.practicemicroservices.foodcatalogue.dto.FoodItemDTO;
import com.practicemicroservices.foodcatalogue.entity.FoodItem;
import com.practicemicroservices.foodcatalogue.repo.FoodItemRepo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;

import java.util.List;

@Service
public class FoodCatalogueService {

    @Autowired
    FoodItemRepo foodItemRepo;

    @Autowired
    RestTemplate restTemplate;

    public FoodItemDTO addFoodItem(FoodItemDTO foodItemDTO) {
        FoodItem foodItemSavedInDB = foodItemRepo.save(mapFoodItemDTOToFoodItem(foodItemDTO));
        return mapFoodItemToFoodItemDTO(foodItemSavedInDB);
    }

    public FoodCataloguePage fetchFoodCataloguePageDetails(String chefId) {

        List<FoodItem> foodItemList=fetchFoodItemList(chefId);
        Chef chef=fetchChefDetailsFromChefListing(chefId);
       return createFoodCataloguePage(foodItemList, chef);
    }

    public List<FoodItemDTO> fetchAllFoodItems() {
        List<FoodItem> allFoodItems = foodItemRepo.findAll();
        return allFoodItems.stream()
                .map(this::mapFoodItemToFoodItemDTO)
                .toList();
    }

    private FoodCataloguePage createFoodCataloguePage(List<FoodItem> foodItemList, Chef chef) {
        FoodCataloguePage foodCataloguePage= new FoodCataloguePage();
        foodCataloguePage.setFoodItemsList(foodItemList);
        foodCataloguePage.setChef(chef);
        return foodCataloguePage;
    }

    private Chef fetchChefDetailsFromChefListing(String chefId) {
        return restTemplate.getForObject("http://CHEF-SERVICE/chef/fetchById/"+chefId, Chef.class);
    }

    private List<FoodItem> fetchFoodItemList(String chefId) {
        return foodItemRepo.findByChefId(chefId);
    }

    // Manual mapping methods to replace MapStruct
    private FoodItemDTO mapFoodItemToFoodItemDTO(FoodItem foodItem) {
        FoodItemDTO foodItemDTO = new FoodItemDTO();
        foodItemDTO.setId(foodItem.getId());
        foodItemDTO.setItemName(foodItem.getItemName());
        foodItemDTO.setItemDescription(foodItem.getItemDescription());
        foodItemDTO.setVeg(foodItem.isVeg());
        foodItemDTO.setPrice(foodItem.getPrice());
        foodItemDTO.setChefId(foodItem.getChefId());
        foodItemDTO.setChefName(foodItem.getChefName()); // map chefName
        foodItemDTO.setQuantity(foodItem.getQuantity());
        foodItemDTO.setCuisine(foodItem.getCuisine()); // map cuisine
        return foodItemDTO;
    }

    private FoodItem mapFoodItemDTOToFoodItem(FoodItemDTO foodItemDTO) {
        FoodItem foodItem = new FoodItem();
        foodItem.setId(foodItemDTO.getId());
        foodItem.setItemName(foodItemDTO.getItemName());
        foodItem.setItemDescription(foodItemDTO.getItemDescription());
        foodItem.setVeg(foodItemDTO.isVeg());
        foodItem.setPrice(foodItemDTO.getPrice());
        foodItem.setChefId(foodItemDTO.getChefId());
        foodItem.setChefName(foodItemDTO.getChefName()); // map chefName
        foodItem.setQuantity(foodItemDTO.getQuantity());
        foodItem.setCuisine(foodItemDTO.getCuisine()); // map cuisine
        return foodItem;
    }
}