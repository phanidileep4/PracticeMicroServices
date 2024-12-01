package com.practicemicroservices.chefListing.mapper;

import com.practicemicroservices.chefListing.dto.ChefDTO;
import com.practicemicroservices.chefListing.entity.Chef;
import org.mapstruct.Mapper;
import org.mapstruct.factory.Mappers;

@Mapper
public interface ChefMapper {

    ChefMapper INSTANCE= Mappers.getMapper(ChefMapper.class);

    ChefDTO mapChefTOChefDTO(Chef chef);
    Chef mapChefDTOTOChef(ChefDTO chefDTO);
}
