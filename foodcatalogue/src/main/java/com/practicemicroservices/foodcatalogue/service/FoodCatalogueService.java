package com.practicemicroservices.foodcatalogue.service;

import com.practicemicroservices.foodcatalogue.dto.Chef;
import com.practicemicroservices.foodcatalogue.dto.FoodCataloguePage;
import com.practicemicroservices.foodcatalogue.dto.FoodItemDTO;
import com.practicemicroservices.foodcatalogue.entity.FoodItem;
import com.practicemicroservices.foodcatalogue.mapper.FoodItemMapper;
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
        FoodItem foodItemisedInDB=foodItemRepo.save(FoodItemMapper.INSTANCE.mapFoodItemDTOTOFoodItem(foodItemDTO));
        return FoodItemMapper.INSTANCE.mapFoodItemTOFoodItemDTO(foodItemisedInDB);
    }

    public FoodCataloguePage fetchFoodCataloguePageDetails(Integer chefId) {

        List<FoodItem> foodItemList=fetchFoodItemList(chefId);
        Chef chef=fetchChefDetailsFromChefListing(chefId);
       return createFoodCataloguePage(foodItemList, chef);
    }

    private FoodCataloguePage createFoodCataloguePage(List<FoodItem> foodItemList, Chef chef) {
        FoodCataloguePage foodCataloguePage= new FoodCataloguePage();
        foodCataloguePage.setFoodItemsList(foodItemList);
        foodCataloguePage.setChef(chef);
        return foodCataloguePage;
    }

    private Chef fetchChefDetailsFromChefListing(Integer chefId) {
        return restTemplate.getForObject("http://CHEF-SERVICE/chef/fetchById/"+chefId, Chef.class);
    }

    private List<FoodItem> fetchFoodItemList(Integer chefId) {
        return foodItemRepo.findByChefId(chefId);
    }

}
