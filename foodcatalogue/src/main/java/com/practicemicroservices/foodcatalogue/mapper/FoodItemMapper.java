package com.practicemicroservices.foodcatalogue.mapper;
import com.practicemicroservices.foodcatalogue.dto.FoodItemDTO;
import com.practicemicroservices.foodcatalogue.entity.FoodItem;
import org.mapstruct.Mapper;
import org.mapstruct.factory.Mappers;

@Mapper
public interface FoodItemMapper {
    FoodItemMapper INSTANCE= Mappers.getMapper(FoodItemMapper.class);

    FoodItemDTO mapFoodItemTOFoodItemDTO(FoodItem foodItem);

    FoodItem mapFoodItemDTOTOFoodItem(FoodItemDTO foodItemDTO);
}
