package com.practicemicroservices.chefListing.repo;

import com.practicemicroservices.chefListing.entity.Chef;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface ChefRepo extends JpaRepository<Chef,Integer> {
}
