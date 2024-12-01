package com.practicemicroservices.chefListing.service;

import com.practicemicroservices.chefListing.dto.ChefDTO;
import com.practicemicroservices.chefListing.entity.Chef;
import com.practicemicroservices.chefListing.mapper.ChefMapper;
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
        List<Chef> chefs= chefRepo.findAll();
        List<ChefDTO> chefDTOList=chefs.stream().map(chef-> ChefMapper.INSTANCE.mapChefTOChefDTO(chef)).collect(Collectors.toList());
        return chefDTOList;
    }

    public ChefDTO addChef(ChefDTO chefDTO) {
        Chef newChef= chefRepo.save(ChefMapper.INSTANCE.mapChefDTOTOChef(chefDTO));
        return ChefMapper.INSTANCE.mapChefTOChefDTO(newChef);
    }

    public ResponseEntity<ChefDTO> fetchChefById(Integer id) {
        Optional<Chef> chef=chefRepo.findById(id);
        if(chef.isPresent())
            return new ResponseEntity<>(ChefMapper.INSTANCE.mapChefTOChefDTO(chef.get()), HttpStatus.OK);
        return new ResponseEntity<>(ChefMapper.INSTANCE.mapChefTOChefDTO(chef.get()),HttpStatus.NOT_FOUND);
    }
}
