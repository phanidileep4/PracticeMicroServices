package com.practicemicroservices.userinfo.repo;

import com.practicemicroservices.userinfo.entity.User;
import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface UserRepo extends MongoRepository<User, String> {
}