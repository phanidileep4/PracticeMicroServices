package com.practicemicroservices.chefListing.repo;

import com.practicemicroservices.chefListing.entity.Chef;
import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface ChefRepo extends MongoRepository<Chef, String> {
}