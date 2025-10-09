package com.practicemicroservices.chefListing.service;

import com.practicemicroservices.chefListing.dto.ChefDTO;
import com.practicemicroservices.chefListing.entity.Chef;
import com.practicemicroservices.chefListing.repo.ChefRepo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

@Service
public class ChefService {

    @Autowired
    ChefRepo chefRepo;

    public List<ChefDTO> findAllChefs() {
        List<Chef> chefs = chefRepo.findAll();
        List<ChefDTO> chefDTOList = chefs.stream().map(this::mapChefToChefDTO).collect(Collectors.toList());
        return chefDTOList;
    }

    public ChefDTO addChef(ChefDTO chefDTO) {
        Chef newChef = chefRepo.save(mapChefDTOToChef(chefDTO));
        return mapChefToChefDTO(newChef);
    }

    public ResponseEntity<ChefDTO> fetchChefById(String id) {
        Optional<Chef> chef = chefRepo.findById(id);
        if(chef.isPresent())
            return new ResponseEntity<>(mapChefToChefDTO(chef.get()), HttpStatus.OK);
        return new ResponseEntity<>(null, HttpStatus.NOT_FOUND);
    }

    // Manual mapping methods to replace MapStruct
    private ChefDTO mapChefToChefDTO(Chef chef) {
        ChefDTO chefDTO = new ChefDTO();
        chefDTO.setId(chef.getId());
        chefDTO.setName(chef.getName());
        chefDTO.setAddress(chef.getAddress());
        chefDTO.setCity(chef.getCity());
        chefDTO.setChefDescription(chef.getChefDescription());
        return chefDTO;
    }

    private Chef mapChefDTOToChef(ChefDTO chefDTO) {
        Chef chef = new Chef();
        chef.setId(chefDTO.getId());
        chef.setName(chefDTO.getName());
        chef.setAddress(chefDTO.getAddress());
        chef.setCity(chefDTO.getCity());
        chef.setChefDescription(chefDTO.getChefDescription());
        return chef;
    }
}